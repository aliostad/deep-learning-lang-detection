
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
			case r == 34 : // ['"','"']
				return 2
			case r == 40 : // ['(','(']
				return 3
			case r == 41 : // [')',')']
				return 4
			case r == 42 : // ['*','*']
				return 5
			case r == 44 : // [',',',']
				return 6
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case r == 48 : // ['0','0']
				return 8
			case r == 49 : // ['1','1']
				return 9
			case 50 <= r && r <= 57 : // ['2','9']
				return 10
			case r == 58 : // [':',':']
				return 11
			case r == 60 : // ['<','<']
				return 12
			case r == 61 : // ['=','=']
				return 13
			case 65 <= r && r <= 90 : // ['A','Z']
				return 14
			case r == 95 : // ['_','_']
				return 15
			case 97 <= r && r <= 101 : // ['a','e']
				return 14
			case r == 102 : // ['f','f']
				return 16
			case 103 <= r && r <= 104 : // ['g','h']
				return 14
			case r == 105 : // ['i','i']
				return 17
			case 106 <= r && r <= 109 : // ['j','m']
				return 14
			case r == 110 : // ['n','n']
				return 18
			case r == 111 : // ['o','o']
				return 19
			case r == 112 : // ['p','p']
				return 20
			case 113 <= r && r <= 114 : // ['q','r']
				return 14
			case r == 115 : // ['s','s']
				return 21
			case r == 116 : // ['t','t']
				return 22
			case 117 <= r && r <= 118 : // ['u','v']
				return 14
			case r == 119 : // ['w','w']
				return 23
			case 120 <= r && r <= 122 : // ['x','z']
				return 14
			
			
			
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
			case r == 34 : // ['"','"']
				return 24
			
			
			default:
				return 2
			}
			
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
			
			
			
			}
			return NoState
			
		},
	
		// S7
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 25
			case 65 <= r && r <= 90 : // ['A','Z']
				return 26
			case r == 95 : // ['_','_']
				return 7
			case 97 <= r && r <= 122 : // ['a','z']
				return 26
			
			
			
			}
			return NoState
			
		},
	
		// S8
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 25
			case 65 <= r && r <= 90 : // ['A','Z']
				return 26
			case r == 95 : // ['_','_']
				return 7
			case 97 <= r && r <= 122 : // ['a','z']
				return 26
			
			
			
			}
			return NoState
			
		},
	
		// S9
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 10
			case 65 <= r && r <= 90 : // ['A','Z']
				return 26
			case r == 95 : // ['_','_']
				return 7
			case 97 <= r && r <= 122 : // ['a','z']
				return 26
			
			
			
			}
			return NoState
			
		},
	
		// S10
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 10
			case 65 <= r && r <= 90 : // ['A','Z']
				return 26
			case r == 95 : // ['_','_']
				return 7
			case 97 <= r && r <= 122 : // ['a','z']
				return 26
			
			
			
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
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S15
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S16
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case r == 97 : // ['a','a']
				return 30
			case 98 <= r && r <= 122 : // ['b','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S17
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 109 : // ['a','m']
				return 28
			case r == 110 : // ['n','n']
				return 31
			case 111 <= r && r <= 122 : // ['o','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S18
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case r == 97 : // ['a','a']
				return 32
			case 98 <= r && r <= 122 : // ['b','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S19
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 116 : // ['a','t']
				return 28
			case r == 117 : // ['u','u']
				return 33
			case 118 <= r && r <= 122 : // ['v','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S20
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case r == 97 : // ['a','a']
				return 34
			case 98 <= r && r <= 122 : // ['b','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S21
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case r == 97 : // ['a','a']
				return 35
			case r == 98 : // ['b','b']
				return 28
			case r == 99 : // ['c','c']
				return 36
			case 100 <= r && r <= 122 : // ['d','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S22
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 113 : // ['a','q']
				return 28
			case r == 114 : // ['r','r']
				return 37
			case 115 <= r && r <= 120 : // ['s','x']
				return 28
			case r == 121 : // ['y','y']
				return 38
			case r == 122 : // ['z','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S23
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case r == 97 : // ['a','a']
				return 39
			case 98 <= r && r <= 122 : // ['b','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S24
		func(r rune) int {
			switch {
			
			
			
			}
			return NoState
			
		},
	
		// S25
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 25
			case 65 <= r && r <= 90 : // ['A','Z']
				return 26
			case r == 95 : // ['_','_']
				return 7
			case 97 <= r && r <= 122 : // ['a','z']
				return 26
			
			
			
			}
			return NoState
			
		},
	
		// S26
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 25
			case 65 <= r && r <= 90 : // ['A','Z']
				return 26
			case r == 95 : // ['_','_']
				return 7
			case 97 <= r && r <= 122 : // ['a','z']
				return 26
			
			
			
			}
			return NoState
			
		},
	
		// S27
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S28
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S29
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S30
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 107 : // ['a','k']
				return 28
			case r == 108 : // ['l','l']
				return 40
			case 109 <= r && r <= 122 : // ['m','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S31
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 111 : // ['a','o']
				return 28
			case r == 112 : // ['p','p']
				return 41
			case 113 <= r && r <= 115 : // ['q','s']
				return 28
			case r == 116 : // ['t','t']
				return 42
			case 117 <= r && r <= 122 : // ['u','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S32
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 108 : // ['a','l']
				return 28
			case r == 109 : // ['m','m']
				return 43
			case 110 <= r && r <= 122 : // ['n','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S33
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 115 : // ['a','s']
				return 28
			case r == 116 : // ['t','t']
				return 44
			case 117 <= r && r <= 122 : // ['u','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S34
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 113 : // ['a','q']
				return 28
			case r == 114 : // ['r','r']
				return 45
			case 115 <= r && r <= 122 : // ['s','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S35
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 109 : // ['a','m']
				return 28
			case r == 110 : // ['n','n']
				return 46
			case 111 <= r && r <= 122 : // ['o','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S36
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 103 : // ['a','g']
				return 28
			case r == 104 : // ['h','h']
				return 47
			case 105 <= r && r <= 113 : // ['i','q']
				return 28
			case r == 114 : // ['r','r']
				return 48
			case 115 <= r && r <= 122 : // ['s','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S37
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 116 : // ['a','t']
				return 28
			case r == 117 : // ['u','u']
				return 49
			case 118 <= r && r <= 122 : // ['v','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S38
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 111 : // ['a','o']
				return 28
			case r == 112 : // ['p','p']
				return 50
			case 113 <= r && r <= 122 : // ['q','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S39
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 104 : // ['a','h']
				return 28
			case r == 105 : // ['i','i']
				return 51
			case 106 <= r && r <= 122 : // ['j','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S40
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 114 : // ['a','r']
				return 28
			case r == 115 : // ['s','s']
				return 52
			case 116 <= r && r <= 122 : // ['t','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S41
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 116 : // ['a','t']
				return 28
			case r == 117 : // ['u','u']
				return 53
			case 118 <= r && r <= 122 : // ['v','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S42
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 100 : // ['a','d']
				return 28
			case r == 101 : // ['e','e']
				return 54
			case 102 <= r && r <= 122 : // ['f','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S43
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 100 : // ['a','d']
				return 28
			case r == 101 : // ['e','e']
				return 55
			case 102 <= r && r <= 122 : // ['f','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S44
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 111 : // ['a','o']
				return 28
			case r == 112 : // ['p','p']
				return 56
			case 113 <= r && r <= 122 : // ['q','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S45
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case r == 97 : // ['a','a']
				return 57
			case 98 <= r && r <= 122 : // ['b','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S46
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 104 : // ['a','h']
				return 28
			case r == 105 : // ['i','i']
				return 58
			case 106 <= r && r <= 122 : // ['j','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S47
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 100 : // ['a','d']
				return 28
			case r == 101 : // ['e','e']
				return 59
			case 102 <= r && r <= 122 : // ['f','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S48
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 104 : // ['a','h']
				return 28
			case r == 105 : // ['i','i']
				return 60
			case 106 <= r && r <= 122 : // ['j','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S49
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 100 : // ['a','d']
				return 28
			case r == 101 : // ['e','e']
				return 61
			case 102 <= r && r <= 122 : // ['f','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S50
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 100 : // ['a','d']
				return 28
			case r == 101 : // ['e','e']
				return 62
			case 102 <= r && r <= 122 : // ['f','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S51
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 115 : // ['a','s']
				return 28
			case r == 116 : // ['t','t']
				return 63
			case 117 <= r && r <= 122 : // ['u','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S52
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 100 : // ['a','d']
				return 28
			case r == 101 : // ['e','e']
				return 64
			case 102 <= r && r <= 122 : // ['f','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S53
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 115 : // ['a','s']
				return 28
			case r == 116 : // ['t','t']
				return 65
			case 117 <= r && r <= 122 : // ['u','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S54
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 113 : // ['a','q']
				return 28
			case r == 114 : // ['r','r']
				return 66
			case 115 <= r && r <= 122 : // ['s','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S55
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S56
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 116 : // ['a','t']
				return 28
			case r == 117 : // ['u','u']
				return 67
			case 118 <= r && r <= 122 : // ['v','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S57
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 107 : // ['a','k']
				return 28
			case r == 108 : // ['l','l']
				return 68
			case 109 <= r && r <= 122 : // ['m','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S58
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 115 : // ['a','s']
				return 28
			case r == 116 : // ['t','t']
				return 69
			case 117 <= r && r <= 122 : // ['u','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S59
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 99 : // ['a','c']
				return 28
			case r == 100 : // ['d','d']
				return 70
			case 101 <= r && r <= 122 : // ['e','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S60
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 111 : // ['a','o']
				return 28
			case r == 112 : // ['p','p']
				return 71
			case 113 <= r && r <= 122 : // ['q','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S61
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S62
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S63
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S64
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S65
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 114 : // ['a','r']
				return 28
			case r == 115 : // ['s','s']
				return 72
			case 116 <= r && r <= 122 : // ['t','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S66
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 111 : // ['a','o']
				return 28
			case r == 112 : // ['p','p']
				return 73
			case 113 <= r && r <= 122 : // ['q','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S67
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 115 : // ['a','s']
				return 28
			case r == 116 : // ['t','t']
				return 74
			case 117 <= r && r <= 122 : // ['u','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S68
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 107 : // ['a','k']
				return 28
			case r == 108 : // ['l','l']
				return 75
			case 109 <= r && r <= 122 : // ['m','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S69
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 104 : // ['a','h']
				return 28
			case r == 105 : // ['i','i']
				return 76
			case 106 <= r && r <= 122 : // ['j','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S70
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 116 : // ['a','t']
				return 28
			case r == 117 : // ['u','u']
				return 77
			case 118 <= r && r <= 122 : // ['v','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S71
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 115 : // ['a','s']
				return 28
			case r == 116 : // ['t','t']
				return 78
			case 117 <= r && r <= 122 : // ['u','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S72
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S73
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 113 : // ['a','q']
				return 28
			case r == 114 : // ['r','r']
				return 79
			case 115 <= r && r <= 122 : // ['s','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S74
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 114 : // ['a','r']
				return 28
			case r == 115 : // ['s','s']
				return 80
			case 116 <= r && r <= 122 : // ['t','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S75
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 100 : // ['a','d']
				return 28
			case r == 101 : // ['e','e']
				return 81
			case 102 <= r && r <= 122 : // ['f','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S76
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 121 : // ['a','y']
				return 28
			case r == 122 : // ['z','z']
				return 82
			
			
			
			}
			return NoState
			
		},
	
		// S77
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 107 : // ['a','k']
				return 28
			case r == 108 : // ['l','l']
				return 83
			case 109 <= r && r <= 122 : // ['m','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S78
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S79
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 100 : // ['a','d']
				return 28
			case r == 101 : // ['e','e']
				return 84
			case 102 <= r && r <= 122 : // ['f','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S80
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S81
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 107 : // ['a','k']
				return 28
			case r == 108 : // ['l','l']
				return 85
			case 109 <= r && r <= 122 : // ['m','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S82
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 100 : // ['a','d']
				return 28
			case r == 101 : // ['e','e']
				return 86
			case 102 <= r && r <= 122 : // ['f','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S83
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 100 : // ['a','d']
				return 28
			case r == 101 : // ['e','e']
				return 87
			case 102 <= r && r <= 122 : // ['f','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S84
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 115 : // ['a','s']
				return 28
			case r == 116 : // ['t','t']
				return 88
			case 117 <= r && r <= 122 : // ['u','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S85
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S86
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 99 : // ['a','c']
				return 28
			case r == 100 : // ['d','d']
				return 89
			case 101 <= r && r <= 122 : // ['e','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S87
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 113 : // ['a','q']
				return 28
			case r == 114 : // ['r','r']
				return 90
			case 115 <= r && r <= 122 : // ['s','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S88
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 100 : // ['a','d']
				return 28
			case r == 101 : // ['e','e']
				return 91
			case 102 <= r && r <= 122 : // ['f','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S89
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S90
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S91
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 113 : // ['a','q']
				return 28
			case r == 114 : // ['r','r']
				return 92
			case 115 <= r && r <= 122 : // ['s','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
		// S92
		func(r rune) int {
			switch {
			case r == 45 : // ['-','-']
				return 7
			case r == 46 : // ['.','.']
				return 7
			case r == 47 : // ['/','/']
				return 7
			case 48 <= r && r <= 57 : // ['0','9']
				return 27
			case 65 <= r && r <= 90 : // ['A','Z']
				return 28
			case r == 95 : // ['_','_']
				return 29
			case 97 <= r && r <= 122 : // ['a','z']
				return 28
			
			
			
			}
			return NoState
			
		},
	
}
