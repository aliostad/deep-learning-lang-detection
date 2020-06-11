package openhours

import (
	"fmt"
)
import (
	"bufio"
	"io"
	"strings"
)

type frame struct {
	i            int
	s            string
	line, column int
}
type Lexer struct {
	// The lexer runs in its own goroutine, and communicates via channel 'ch'.
	ch chan frame
	// We record the level of nesting because the action could return, and a
	// subsequent call expects to pick up where it left off. In other words,
	// we're simulating a coroutine.
	// TODO: Support a channel-based variant that compatible with Go's yacc.
	stack []frame
	stale bool

	// The 'l' and 'c' fields were added for
	// https://github.com/wagerlabs/docker/blob/65694e801a7b80930961d70c69cba9f2465459be/buildfile.nex
	// Since then, I introduced the built-in Line() and Column() functions.
	l, c int

	parseResult interface{}

	// The following line makes it easy for scripts to insert fields in the
	// generated code.
	// [NEX_END_OF_LEXER_STRUCT]
}

// NewLexerWithInit creates a new Lexer object, runs the given callback on it,
// then returns it.
func NewLexerWithInit(in io.Reader, initFun func(*Lexer)) *Lexer {
	type dfa struct {
		acc          []bool           // Accepting states.
		f            []func(rune) int // Transitions.
		startf, endf []int            // Transitions at start and end of input.
		nest         []dfa
	}
	yylex := new(Lexer)
	if initFun != nil {
		initFun(yylex)
	}
	yylex.ch = make(chan frame)
	var scan func(in *bufio.Reader, ch chan frame, family []dfa, line, column int)
	scan = func(in *bufio.Reader, ch chan frame, family []dfa, line, column int) {
		// Index of DFA and length of highest-precedence match so far.
		matchi, matchn := 0, -1
		var buf []rune
		n := 0
		checkAccept := func(i int, st int) bool {
			// Higher precedence match? DFAs are run in parallel, so matchn is at most len(buf), hence we may omit the length equality check.
			if family[i].acc[st] && (matchn < n || matchi > i) {
				matchi, matchn = i, n
				return true
			}
			return false
		}
		var state [][2]int
		for i := 0; i < len(family); i++ {
			mark := make([]bool, len(family[i].startf))
			// Every DFA starts at state 0.
			st := 0
			for {
				state = append(state, [2]int{i, st})
				mark[st] = true
				// As we're at the start of input, follow all ^ transitions and append to our list of start states.
				st = family[i].startf[st]
				if -1 == st || mark[st] {
					break
				}
				// We only check for a match after at least one transition.
				checkAccept(i, st)
			}
		}
		atEOF := false
		for {
			if n == len(buf) && !atEOF {
				r, _, err := in.ReadRune()
				switch err {
				case io.EOF:
					atEOF = true
				case nil:
					buf = append(buf, r)
				default:
					panic(err)
				}
			}
			if !atEOF {
				r := buf[n]
				n++
				var nextState [][2]int
				for _, x := range state {
					x[1] = family[x[0]].f[x[1]](r)
					if -1 == x[1] {
						continue
					}
					nextState = append(nextState, x)
					checkAccept(x[0], x[1])
				}
				state = nextState
			} else {
			dollar: // Handle $.
				for _, x := range state {
					mark := make([]bool, len(family[x[0]].endf))
					for {
						mark[x[1]] = true
						x[1] = family[x[0]].endf[x[1]]
						if -1 == x[1] || mark[x[1]] {
							break
						}
						if checkAccept(x[0], x[1]) {
							// Unlike before, we can break off the search. Now that we're at the end, there's no need to maintain the state of each DFA.
							break dollar
						}
					}
				}
				state = nil
			}

			if state == nil {
				lcUpdate := func(r rune) {
					if r == '\n' {
						line++
						column = 0
					} else {
						column++
					}
				}
				// All DFAs stuck. Return last match if it exists, otherwise advance by one rune and restart all DFAs.
				if matchn == -1 {
					if len(buf) == 0 { // This can only happen at the end of input.
						break
					}
					lcUpdate(buf[0])
					buf = buf[1:]
				} else {
					text := string(buf[:matchn])
					buf = buf[matchn:]
					matchn = -1
					ch <- frame{matchi, text, line, column}
					if len(family[matchi].nest) > 0 {
						scan(bufio.NewReader(strings.NewReader(text)), ch, family[matchi].nest, line, column)
					}
					if atEOF {
						break
					}
					for _, r := range text {
						lcUpdate(r)
					}
				}
				n = 0
				for i := 0; i < len(family); i++ {
					state = append(state, [2]int{i, 0})
				}
			}
		}
		ch <- frame{-1, "", line, column}
	}
	go scan(bufio.NewReader(in), yylex.ch, []dfa{
		// 24\/7
		{[]bool{false, false, false, false, true}, []func(rune) int{ // Transitions
			func(r rune) int {
				switch r {
				case 47:
					return -1
				case 50:
					return 1
				case 52:
					return -1
				case 55:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 47:
					return -1
				case 50:
					return -1
				case 52:
					return 2
				case 55:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 47:
					return 3
				case 50:
					return -1
				case 52:
					return -1
				case 55:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 47:
					return -1
				case 50:
					return -1
				case 52:
					return -1
				case 55:
					return 4
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 47:
					return -1
				case 50:
					return -1
				case 52:
					return -1
				case 55:
					return -1
				}
				return -1
			},
		}, []int{ /* Start-of-input transitions */ -1, -1, -1, -1, -1}, []int{ /* End-of-input transitions */ -1, -1, -1, -1, -1}, nil},

		// Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec
		{[]bool{false, false, false, false, false, false, false, false, false, false, true, false, true, false, true, false, true, true, false, false, true, true, true, false, true, false, true, false, false, true, true}, []func(rune) int{ // Transitions
			func(r rune) int {
				switch r {
				case 65:
					return 1
				case 68:
					return 2
				case 70:
					return 3
				case 74:
					return 4
				case 77:
					return 5
				case 78:
					return 6
				case 79:
					return 7
				case 83:
					return 8
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return 27
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return 28
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return 25
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return 23
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return 18
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return 19
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return 15
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return 13
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return 11
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return 9
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return 10
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return 12
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return 14
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return 16
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return 17
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return 22
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return 20
				case 110:
					return 21
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return 24
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return 26
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return 30
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return 29
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 65:
					return -1
				case 68:
					return -1
				case 70:
					return -1
				case 74:
					return -1
				case 77:
					return -1
				case 78:
					return -1
				case 79:
					return -1
				case 83:
					return -1
				case 97:
					return -1
				case 98:
					return -1
				case 99:
					return -1
				case 101:
					return -1
				case 103:
					return -1
				case 108:
					return -1
				case 110:
					return -1
				case 111:
					return -1
				case 112:
					return -1
				case 114:
					return -1
				case 116:
					return -1
				case 117:
					return -1
				case 118:
					return -1
				case 121:
					return -1
				}
				return -1
			},
		}, []int{ /* Start-of-input transitions */ -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, []int{ /* End-of-input transitions */ -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, nil},

		// Su|Mo|Tu|We|Th|Fr|Sa
		{[]bool{false, false, false, false, false, false, true, true, true, true, true, true, true}, []func(rune) int{ // Transitions
			func(r rune) int {
				switch r {
				case 70:
					return 1
				case 77:
					return 2
				case 83:
					return 3
				case 84:
					return 4
				case 87:
					return 5
				case 97:
					return -1
				case 101:
					return -1
				case 104:
					return -1
				case 111:
					return -1
				case 114:
					return -1
				case 117:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 70:
					return -1
				case 77:
					return -1
				case 83:
					return -1
				case 84:
					return -1
				case 87:
					return -1
				case 97:
					return -1
				case 101:
					return -1
				case 104:
					return -1
				case 111:
					return -1
				case 114:
					return 12
				case 117:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 70:
					return -1
				case 77:
					return -1
				case 83:
					return -1
				case 84:
					return -1
				case 87:
					return -1
				case 97:
					return -1
				case 101:
					return -1
				case 104:
					return -1
				case 111:
					return 11
				case 114:
					return -1
				case 117:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 70:
					return -1
				case 77:
					return -1
				case 83:
					return -1
				case 84:
					return -1
				case 87:
					return -1
				case 97:
					return 9
				case 101:
					return -1
				case 104:
					return -1
				case 111:
					return -1
				case 114:
					return -1
				case 117:
					return 10
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 70:
					return -1
				case 77:
					return -1
				case 83:
					return -1
				case 84:
					return -1
				case 87:
					return -1
				case 97:
					return -1
				case 101:
					return -1
				case 104:
					return 7
				case 111:
					return -1
				case 114:
					return -1
				case 117:
					return 8
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 70:
					return -1
				case 77:
					return -1
				case 83:
					return -1
				case 84:
					return -1
				case 87:
					return -1
				case 97:
					return -1
				case 101:
					return 6
				case 104:
					return -1
				case 111:
					return -1
				case 114:
					return -1
				case 117:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 70:
					return -1
				case 77:
					return -1
				case 83:
					return -1
				case 84:
					return -1
				case 87:
					return -1
				case 97:
					return -1
				case 101:
					return -1
				case 104:
					return -1
				case 111:
					return -1
				case 114:
					return -1
				case 117:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 70:
					return -1
				case 77:
					return -1
				case 83:
					return -1
				case 84:
					return -1
				case 87:
					return -1
				case 97:
					return -1
				case 101:
					return -1
				case 104:
					return -1
				case 111:
					return -1
				case 114:
					return -1
				case 117:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 70:
					return -1
				case 77:
					return -1
				case 83:
					return -1
				case 84:
					return -1
				case 87:
					return -1
				case 97:
					return -1
				case 101:
					return -1
				case 104:
					return -1
				case 111:
					return -1
				case 114:
					return -1
				case 117:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 70:
					return -1
				case 77:
					return -1
				case 83:
					return -1
				case 84:
					return -1
				case 87:
					return -1
				case 97:
					return -1
				case 101:
					return -1
				case 104:
					return -1
				case 111:
					return -1
				case 114:
					return -1
				case 117:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 70:
					return -1
				case 77:
					return -1
				case 83:
					return -1
				case 84:
					return -1
				case 87:
					return -1
				case 97:
					return -1
				case 101:
					return -1
				case 104:
					return -1
				case 111:
					return -1
				case 114:
					return -1
				case 117:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 70:
					return -1
				case 77:
					return -1
				case 83:
					return -1
				case 84:
					return -1
				case 87:
					return -1
				case 97:
					return -1
				case 101:
					return -1
				case 104:
					return -1
				case 111:
					return -1
				case 114:
					return -1
				case 117:
					return -1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 70:
					return -1
				case 77:
					return -1
				case 83:
					return -1
				case 84:
					return -1
				case 87:
					return -1
				case 97:
					return -1
				case 101:
					return -1
				case 104:
					return -1
				case 111:
					return -1
				case 114:
					return -1
				case 117:
					return -1
				}
				return -1
			},
		}, []int{ /* Start-of-input transitions */ -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, []int{ /* End-of-input transitions */ -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, nil},

		//
		{[]bool{false, true}, []func(rune) int{ // Transitions
			func(r rune) int {
				switch r {
				case 32:
					return 1
				}
				return -1
			},
			func(r rune) int {
				switch r {
				case 32:
					return -1
				}
				return -1
			},
		}, []int{ /* Start-of-input transitions */ -1, -1}, []int{ /* End-of-input transitions */ -1, -1}, nil},

		// .
		{[]bool{false, true}, []func(rune) int{ // Transitions
			func(r rune) int {
				return 1
			},
			func(r rune) int {
				return -1
			},
		}, []int{ /* Start-of-input transitions */ -1, -1}, []int{ /* End-of-input transitions */ -1, -1}, nil},
	}, 0, 0)
	return yylex
}

func NewLexer(in io.Reader) *Lexer {
	return NewLexerWithInit(in, nil)
}

// Text returns the matched text.
func (yylex *Lexer) Text() string {
	return yylex.stack[len(yylex.stack)-1].s
}

// Line returns the current line number.
// The first line is 0.
func (yylex *Lexer) Line() int {
	if len(yylex.stack) == 0 {
		return 0
	}
	return yylex.stack[len(yylex.stack)-1].line
}

// Column returns the current column number.
// The first column is 0.
func (yylex *Lexer) Column() int {
	if len(yylex.stack) == 0 {
		return 0
	}
	return yylex.stack[len(yylex.stack)-1].column
}

func (yylex *Lexer) next(lvl int) int {
	if lvl == len(yylex.stack) {
		l, c := 0, 0
		if lvl > 0 {
			l, c = yylex.stack[lvl-1].line, yylex.stack[lvl-1].column
		}
		yylex.stack = append(yylex.stack, frame{0, "", l, c})
	}
	if lvl == len(yylex.stack)-1 {
		p := &yylex.stack[lvl]
		*p = <-yylex.ch
		yylex.stale = false
	} else {
		yylex.stale = true
	}
	return yylex.stack[lvl].i
}
func (yylex *Lexer) pop() {
	yylex.stack = yylex.stack[:len(yylex.stack)-1]
}

// Lex runs the lexer. Always returns 0.
// When the -s option is given, this function is not generated;
// instead, the NN_FUN macro runs the lexer.
func (yylex *Lexer) Lex(lval *yySymType) int {
OUTER0:
	for {
		switch yylex.next(0) {
		case 0:
			{
				return ALWAYS
			}
		case 1:
			{
				lval.num, _ = months[yylex.Text()]
				return MONTH
			}
		case 2:
			{
				lval.num, _ = weekdays[yylex.Text()]
				return WEEKDAY
			}
		case 3:
			{
				return SEP
			}
		case 4:
			{
				return int(yylex.Text()[0])
			}
		default:
			break OUTER0
		}
		continue
	}
	yylex.pop()

	return 0
}

var months = map[string]int{"Jan": 0, "Feb": 1, "Mar": 2, "Apr": 3, "May": 4, "Jun": 5, "Jul": 6, "Aug": 7, "Sep": 8, "Oct": 9, "Nov": 10, "Dec": 11}
var weekdays = map[string]int{"Su": 0, "Mo": 1, "Tu": 2, "We": 3, "Th": 4, "Fr": 5, "Sa": 6}

func (yylex *Lexer) Error(e string) {
	switch yylex.parseResult.(type) {
	case []error: //nothing to do
	default:
		yylex.parseResult = make([]error, 0)
	}
	yylex.parseResult = append(yylex.parseResult.([]error), fmt.Errorf("%d:%d %v", yylex.Line(), yylex.Column(), e))
}
