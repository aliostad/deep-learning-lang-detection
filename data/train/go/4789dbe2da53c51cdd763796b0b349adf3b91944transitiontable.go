
package lexer



/*
Let s be the current state
Let r be the current input rune
transitionTable[s](r) returns the next state.
*/
type TransitionTable [NumStates] func(rune) int

var TransTab = TransitionTable{
	
		// S0
		func(r rune) int {
			switch {
			case r == 9 : // ['\t','\t']
				return 1
			case r == 10 : // ['\n','\n']
				return 1
			case r == 13 : // ['\r','\r']
				return 1
			case r == 32 : // [' ',' ']
				return 1
			case r == 40 : // ['(','(']
				return 2
			case r == 41 : // [')',')']
				return 3
			case r == 42 : // ['*','*']
				return 4
			case r == 44 : // [',',',']
				return 5
			case r == 45 : // ['-','-']
				return 6
			case r == 47 : // ['/','/']
				return 7
			case r == 48 : // ['0','0']
				return 8
			case 49 <= r && r <= 57 : // ['1','9']
				return 9
			case r == 58 : // [':',':']
				return 10
			case r == 61 : // ['=','=']
				return 11
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 91 : // ['[','[']
				return 13
			case r == 93 : // [']',']']
				return 14
			case r == 95 : // ['_','_']
				return 4
			case r == 97 : // ['a','a']
				return 12
			case r == 98 : // ['b','b']
				return 15
			case 99 <= r && r <= 104 : // ['c','h']
				return 12
			case r == 105 : // ['i','i']
				return 16
			case 106 <= r && r <= 107 : // ['j','k']
				return 12
			case r == 108 : // ['l','l']
				return 17
			case r == 109 : // ['m','m']
				return 18
			case 110 <= r && r <= 111 : // ['n','o']
				return 12
			case r == 112 : // ['p','p']
				return 19
			case r == 113 : // ['q','q']
				return 12
			case r == 114 : // ['r','r']
				return 20
			case r == 115 : // ['s','s']
				return 21
			case 116 <= r && r <= 122 : // ['t','z']
				return 12
			case r == 123 : // ['{','{']
				return 22
			case r == 125 : // ['}','}']
				return 23
			
			
			
			}
			return NoState
			
		},
	
		// S1
		func(r rune) int {
			switch {
			
			
			
			}
			return NoState
			
		},
	
		// S2
		func(r rune) int {
			switch {
			
			
			
			}
			return NoState
			
		},
	
		// S3
		func(r rune) int {
			switch {
			
			
			
			}
			return NoState
			
		},
	
		// S4
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S5
		func(r rune) int {
			switch {
			
			
			
			}
			return NoState
			
		},
	
		// S6
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 9
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S7
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 24
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 25
			case 48 <= r && r <= 57 : // ['0','9']
				return 26
			case 65 <= r && r <= 90 : // ['A','Z']
				return 27
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 27
			
			
			
			}
			return NoState
			
		},
	
		// S8
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S9
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 9
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S10
		func(r rune) int {
			switch {
			
			
			
			}
			return NoState
			
		},
	
		// S11
		func(r rune) int {
			switch {
			
			
			
			}
			return NoState
			
		},
	
		// S12
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S13
		func(r rune) int {
			switch {
			
			
			
			}
			return NoState
			
		},
	
		// S14
		func(r rune) int {
			switch {
			
			
			
			}
			return NoState
			
		},
	
		// S15
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 120 : // ['a','x']
				return 12
			case r == 121 : // ['y','y']
				return 28
			case r == 122 : // ['z','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S16
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 109 : // ['a','m']
				return 12
			case r == 110 : // ['n','n']
				return 29
			case 111 <= r && r <= 122 : // ['o','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S17
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case r == 97 : // ['a','a']
				return 30
			case 98 <= r && r <= 122 : // ['b','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S18
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case r == 97 : // ['a','a']
				return 31
			case 98 <= r && r <= 100 : // ['b','d']
				return 12
			case r == 101 : // ['e','e']
				return 32
			case 102 <= r && r <= 104 : // ['f','h']
				return 12
			case r == 105 : // ['i','i']
				return 33
			case 106 <= r && r <= 122 : // ['j','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S19
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 100 : // ['a','d']
				return 12
			case r == 101 : // ['e','e']
				return 34
			case 102 <= r && r <= 122 : // ['f','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S20
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case r == 97 : // ['a','a']
				return 35
			case 98 <= r && r <= 100 : // ['b','d']
				return 12
			case r == 101 : // ['e','e']
				return 36
			case 102 <= r && r <= 122 : // ['f','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S21
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 115 : // ['a','s']
				return 12
			case r == 116 : // ['t','t']
				return 37
			case r == 117 : // ['u','u']
				return 38
			case 118 <= r && r <= 122 : // ['v','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S22
		func(r rune) int {
			switch {
			case r == 125 : // ['}','}']
				return 39
			
			
			
			}
			return NoState
			
		},
	
		// S23
		func(r rune) int {
			switch {
			
			
			
			}
			return NoState
			
		},
	
		// S24
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 40
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			default:
				return 41
			}
			
		},
	
		// S25
		func(r rune) int {
			switch {
			case r == 10 : // ['\n','\n']
				return 42
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			default:
				return 43
			}
			
		},
	
		// S26
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 44
			case r == 47 : // ['/','/']
				return 44
			case 48 <= r && r <= 57 : // ['0','9']
				return 26
			case 65 <= r && r <= 90 : // ['A','Z']
				return 27
			case r == 95 : // ['_','_']
				return 44
			case 97 <= r && r <= 122 : // ['a','z']
				return 27
			
			
			
			}
			return NoState
			
		},
	
		// S27
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 44
			case r == 47 : // ['/','/']
				return 44
			case 48 <= r && r <= 57 : // ['0','9']
				return 26
			case 65 <= r && r <= 90 : // ['A','Z']
				return 27
			case r == 95 : // ['_','_']
				return 44
			case 97 <= r && r <= 122 : // ['a','z']
				return 27
			
			
			
			}
			return NoState
			
		},
	
		// S28
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S29
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 115 : // ['a','s']
				return 12
			case r == 116 : // ['t','t']
				return 45
			case 117 <= r && r <= 122 : // ['u','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S30
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 115 : // ['a','s']
				return 12
			case r == 116 : // ['t','t']
				return 46
			case 117 <= r && r <= 122 : // ['u','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S31
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 119 : // ['a','w']
				return 12
			case r == 120 : // ['x','x']
				return 47
			case 121 <= r && r <= 122 : // ['y','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S32
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case r == 97 : // ['a','a']
				return 48
			case 98 <= r && r <= 99 : // ['b','c']
				return 12
			case r == 100 : // ['d','d']
				return 49
			case 101 <= r && r <= 122 : // ['e','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S33
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 109 : // ['a','m']
				return 12
			case r == 110 : // ['n','n']
				return 50
			case 111 <= r && r <= 122 : // ['o','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S34
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 113 : // ['a','q']
				return 12
			case r == 114 : // ['r','r']
				return 51
			case 115 <= r && r <= 122 : // ['s','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S35
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 115 : // ['a','s']
				return 12
			case r == 116 : // ['t','t']
				return 52
			case 117 <= r && r <= 122 : // ['u','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S36
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 102 : // ['a','f']
				return 12
			case r == 103 : // ['g','g']
				return 53
			case 104 <= r && r <= 122 : // ['h','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S37
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 99 : // ['a','c']
				return 12
			case r == 100 : // ['d','d']
				return 54
			case 101 <= r && r <= 122 : // ['e','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S38
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 108 : // ['a','l']
				return 12
			case r == 109 : // ['m','m']
				return 55
			case 110 <= r && r <= 122 : // ['n','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S39
		func(r rune) int {
			switch {
			
			
			
			}
			return NoState
			
		},
	
		// S40
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 40
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 56
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			default:
				return 41
			}
			
		},
	
		// S41
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 57
			
			
			default:
				return 41
			}
			
		},
	
		// S42
		func(r rune) int {
			switch {
			
			
			
			}
			return NoState
			
		},
	
		// S43
		func(r rune) int {
			switch {
			case r == 10 : // ['\n','\n']
				return 42
			
			
			default:
				return 43
			}
			
		},
	
		// S44
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 44
			case r == 47 : // ['/','/']
				return 44
			case 48 <= r && r <= 57 : // ['0','9']
				return 26
			case 65 <= r && r <= 90 : // ['A','Z']
				return 27
			case r == 95 : // ['_','_']
				return 44
			case 97 <= r && r <= 122 : // ['a','z']
				return 27
			
			
			
			}
			return NoState
			
		},
	
		// S45
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 100 : // ['a','d']
				return 12
			case r == 101 : // ['e','e']
				return 58
			case 102 <= r && r <= 122 : // ['f','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S46
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 100 : // ['a','d']
				return 12
			case r == 101 : // ['e','e']
				return 59
			case 102 <= r && r <= 122 : // ['f','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S47
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S48
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 109 : // ['a','m']
				return 12
			case r == 110 : // ['n','n']
				return 60
			case 111 <= r && r <= 122 : // ['o','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S49
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 104 : // ['a','h']
				return 12
			case r == 105 : // ['i','i']
				return 61
			case 106 <= r && r <= 122 : // ['j','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S50
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S51
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 98 : // ['a','b']
				return 12
			case r == 99 : // ['c','c']
				return 62
			case 100 <= r && r <= 122 : // ['d','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S52
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 100 : // ['a','d']
				return 12
			case r == 101 : // ['e','e']
				return 63
			case 102 <= r && r <= 122 : // ['f','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S53
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 116 : // ['a','t']
				return 12
			case r == 117 : // ['u','u']
				return 64
			case 118 <= r && r <= 122 : // ['v','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S54
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 99 : // ['a','c']
				return 12
			case r == 100 : // ['d','d']
				return 65
			case 101 <= r && r <= 122 : // ['e','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S55
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S56
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S57
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 57
			case r == 47 : // ['/','/']
				return 66
			
			
			default:
				return 41
			}
			
		},
	
		// S58
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 113 : // ['a','q']
				return 12
			case r == 114 : // ['r','r']
				return 67
			case 115 <= r && r <= 122 : // ['s','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S59
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 114 : // ['a','r']
				return 12
			case r == 115 : // ['s','s']
				return 68
			case 116 <= r && r <= 122 : // ['t','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S60
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S61
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case r == 97 : // ['a','a']
				return 69
			case 98 <= r && r <= 122 : // ['b','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S62
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 100 : // ['a','d']
				return 12
			case r == 101 : // ['e','e']
				return 70
			case 102 <= r && r <= 122 : // ['f','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S63
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 71
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S64
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 107 : // ['a','k']
				return 12
			case r == 108 : // ['l','l']
				return 72
			case 109 <= r && r <= 122 : // ['m','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S65
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 100 : // ['a','d']
				return 12
			case r == 101 : // ['e','e']
				return 73
			case 102 <= r && r <= 122 : // ['f','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S66
		func(r rune) int {
			switch {
			
			
			
			}
			return NoState
			
		},
	
		// S67
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 111 : // ['a','o']
				return 12
			case r == 112 : // ['p','p']
				return 74
			case 113 <= r && r <= 122 : // ['q','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S68
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 115 : // ['a','s']
				return 12
			case r == 116 : // ['t','t']
				return 75
			case 117 <= r && r <= 122 : // ['u','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S69
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 109 : // ['a','m']
				return 12
			case r == 110 : // ['n','n']
				return 76
			case 111 <= r && r <= 122 : // ['o','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S70
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 109 : // ['a','m']
				return 12
			case r == 110 : // ['n','n']
				return 77
			case 111 <= r && r <= 122 : // ['o','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S71
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 114 : // ['a','r']
				return 12
			case r == 115 : // ['s','s']
				return 78
			case 116 <= r && r <= 122 : // ['t','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S72
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case r == 97 : // ['a','a']
				return 79
			case 98 <= r && r <= 122 : // ['b','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S73
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 117 : // ['a','u']
				return 12
			case r == 118 : // ['v','v']
				return 80
			case 119 <= r && r <= 122 : // ['w','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S74
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 110 : // ['a','n']
				return 12
			case r == 111 : // ['o','o']
				return 81
			case 112 <= r && r <= 122 : // ['p','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S75
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S76
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S77
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 115 : // ['a','s']
				return 12
			case r == 116 : // ['t','t']
				return 82
			case 117 <= r && r <= 122 : // ['u','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S78
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 104 : // ['a','h']
				return 12
			case r == 105 : // ['i','i']
				return 83
			case 106 <= r && r <= 122 : // ['j','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S79
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 113 : // ['a','q']
				return 12
			case r == 114 : // ['r','r']
				return 84
			case 115 <= r && r <= 122 : // ['s','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S80
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S81
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 107 : // ['a','k']
				return 12
			case r == 108 : // ['l','l']
				return 85
			case 109 <= r && r <= 122 : // ['m','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S82
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 104 : // ['a','h']
				return 12
			case r == 105 : // ['i','i']
				return 86
			case 106 <= r && r <= 122 : // ['j','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S83
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 102 : // ['a','f']
				return 12
			case r == 103 : // ['g','g']
				return 87
			case 104 <= r && r <= 122 : // ['h','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S84
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 104 : // ['a','h']
				return 12
			case r == 105 : // ['i','i']
				return 88
			case 106 <= r && r <= 122 : // ['j','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S85
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case r == 97 : // ['a','a']
				return 89
			case 98 <= r && r <= 122 : // ['b','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S86
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 107 : // ['a','k']
				return 12
			case r == 108 : // ['l','l']
				return 90
			case 109 <= r && r <= 122 : // ['m','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S87
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 109 : // ['a','m']
				return 12
			case r == 110 : // ['n','n']
				return 91
			case 111 <= r && r <= 122 : // ['o','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S88
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 121 : // ['a','y']
				return 12
			case r == 122 : // ['z','z']
				return 92
			
			
			
			}
			return NoState
			
		},
	
		// S89
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 115 : // ['a','s']
				return 12
			case r == 116 : // ['t','t']
				return 93
			case 117 <= r && r <= 122 : // ['u','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S90
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 100 : // ['a','d']
				return 12
			case r == 101 : // ['e','e']
				return 94
			case 102 <= r && r <= 122 : // ['f','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S91
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 100 : // ['a','d']
				return 12
			case r == 101 : // ['e','e']
				return 95
			case 102 <= r && r <= 122 : // ['f','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S92
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 100 : // ['a','d']
				return 12
			case r == 101 : // ['e','e']
				return 96
			case 102 <= r && r <= 122 : // ['f','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S93
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 100 : // ['a','d']
				return 12
			case r == 101 : // ['e','e']
				return 97
			case 102 <= r && r <= 122 : // ['f','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S94
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S95
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 99 : // ['a','c']
				return 12
			case r == 100 : // ['d','d']
				return 98
			case 101 <= r && r <= 122 : // ['e','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S96
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S97
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
		// S98
		func(r rune) int {
			switch {
			case r == 42 : // ['*','*']
				return 4
			case r == 45 : // ['-','-']
				return 4
			case r == 47 : // ['/','/']
				return 4
			case 48 <= r && r <= 57 : // ['0','9']
				return 8
			case 65 <= r && r <= 90 : // ['A','Z']
				return 12
			case r == 95 : // ['_','_']
				return 4
			case 97 <= r && r <= 122 : // ['a','z']
				return 12
			
			
			
			}
			return NoState
			
		},
	
}
