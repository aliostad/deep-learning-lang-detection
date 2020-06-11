package lexer

/*
Let s be the current state
Let r be the current input rune
transitionTable[s](r) returns the next state.
*/
type TransitionTable [NumStates]func(rune) int

var TransTab = TransitionTable{

	// S0
	func(r rune) int {
		switch {
		case r == 9: // ['\t','\t']
			return 1
		case r == 10: // ['\n','\n']
			return 1
		case r == 13: // ['\r','\r']
			return 1
		case r == 32: // [' ',' ']
			return 1
		case r == 33: // ['!','!']
			return 2
		case r == 34: // ['"','"']
			return 3
		case r == 35: // ['#','#']
			return 4
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 44: // [',',',']
			return 5
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 98: // ['a','b']
			return 2
		case r == 99: // ['c','c']
			return 6
		case r == 100: // ['d','d']
			return 7
		case r == 101: // ['e','e']
			return 8
		case 102 <= r && r <= 103: // ['f','g']
			return 2
		case r == 104: // ['h','h']
			return 9
		case r == 105: // ['i','i']
			return 2
		case r == 106: // ['j','j']
			return 10
		case 107 <= r && r <= 108: // ['k','l']
			return 2
		case r == 109: // ['m','m']
			return 11
		case 110 <= r && r <= 118: // ['n','v']
			return 2
		case r == 119: // ['w','w']
			return 12
		case 120 <= r && r <= 122: // ['x','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

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
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 122: // ['a','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S3
	func(r rune) int {
		switch {
		case r == 92: // ['\','\']
			return 13

		default:
			return 14
		}

	},

	// S4
	func(r rune) int {
		switch {
		case r == 10: // ['\n','\n']
			return 15
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 122: // ['a','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		default:
			return 16
		}

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
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 103: // ['a','g']
			return 2
		case r == 104: // ['h','h']
			return 17
		case 105 <= r && r <= 122: // ['i','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S7
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case r == 97: // ['a','a']
			return 18
		case 98 <= r && r <= 122: // ['b','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S8
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 117: // ['a','u']
			return 2
		case r == 118: // ['v','v']
			return 19
		case 119 <= r && r <= 122: // ['w','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S9
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case r == 97: // ['a','a']
			return 20
		case 98 <= r && r <= 110: // ['b','n']
			return 2
		case r == 111: // ['o','o']
			return 21
		case 112 <= r && r <= 122: // ['p','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S10
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 110: // ['a','n']
			return 2
		case r == 111: // ['o','o']
			return 22
		case 112 <= r && r <= 122: // ['p','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S11
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 104: // ['a','h']
			return 2
		case r == 105: // ['i','i']
			return 23
		case 106 <= r && r <= 122: // ['j','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S12
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 104: // ['a','h']
			return 2
		case r == 105: // ['i','i']
			return 24
		case 106 <= r && r <= 122: // ['j','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S13
	func(r rune) int {
		switch {

		default:
			return 25
		}

	},

	// S14
	func(r rune) int {
		switch {
		case r == 34: // ['"','"']
			return 26
		case r == 92: // ['\','\']
			return 27

		default:
			return 14
		}

	},

	// S15
	func(r rune) int {
		switch {

		}
		return NoState

	},

	// S16
	func(r rune) int {
		switch {
		case r == 10: // ['\n','\n']
			return 15

		default:
			return 16
		}

	},

	// S17
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 100: // ['a','d']
			return 2
		case r == 101: // ['e','e']
			return 28
		case 102 <= r && r <= 122: // ['f','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S18
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 120: // ['a','x']
			return 2
		case r == 121: // ['y','y']
			return 29
		case r == 122: // ['z','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S19
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 100: // ['a','d']
			return 2
		case r == 101: // ['e','e']
			return 30
		case 102 <= r && r <= 122: // ['f','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S20
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 111: // ['a','o']
			return 2
		case r == 112: // ['p','p']
			return 31
		case 113 <= r && r <= 122: // ['q','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S21
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 116: // ['a','t']
			return 2
		case r == 117: // ['u','u']
			return 32
		case 118 <= r && r <= 122: // ['v','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S22
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case r == 97: // ['a','a']
			return 2
		case r == 98: // ['b','b']
			return 33
		case 99 <= r && r <= 122: // ['c','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S23
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 109: // ['a','m']
			return 2
		case r == 110: // ['n','n']
			return 34
		case 111 <= r && r <= 122: // ['o','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S24
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 115: // ['a','s']
			return 2
		case r == 116: // ['t','t']
			return 35
		case 117 <= r && r <= 122: // ['u','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S25
	func(r rune) int {
		switch {
		case r == 34: // ['"','"']
			return 26
		case r == 92: // ['\','\']
			return 27

		default:
			return 14
		}

	},

	// S26
	func(r rune) int {
		switch {

		}
		return NoState

	},

	// S27
	func(r rune) int {
		switch {

		default:
			return 25
		}

	},

	// S28
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 98: // ['a','b']
			return 2
		case r == 99: // ['c','c']
			return 36
		case 100 <= r && r <= 122: // ['d','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S29
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 114: // ['a','r']
			return 2
		case r == 115: // ['s','s']
			return 37
		case 116 <= r && r <= 122: // ['t','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S30
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 113: // ['a','q']
			return 2
		case r == 114: // ['r','r']
			return 38
		case 115 <= r && r <= 122: // ['s','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S31
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 111: // ['a','o']
			return 2
		case r == 112: // ['p','p']
			return 39
		case 113 <= r && r <= 122: // ['q','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S32
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 113: // ['a','q']
			return 2
		case r == 114: // ['r','r']
			return 40
		case 115 <= r && r <= 122: // ['s','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S33
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 114: // ['a','r']
			return 2
		case r == 115: // ['s','s']
			return 41
		case 116 <= r && r <= 122: // ['t','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S34
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 116: // ['a','t']
			return 2
		case r == 117: // ['u','u']
			return 42
		case 118 <= r && r <= 122: // ['v','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S35
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 103: // ['a','g']
			return 2
		case r == 104: // ['h','h']
			return 43
		case 105 <= r && r <= 122: // ['i','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S36
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 106: // ['a','j']
			return 2
		case r == 107: // ['k','k']
			return 44
		case 108 <= r && r <= 122: // ['l','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S37
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 122: // ['a','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S38
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 120: // ['a','x']
			return 2
		case r == 121: // ['y','y']
			return 45
		case r == 122: // ['z','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S39
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 100: // ['a','d']
			return 2
		case r == 101: // ['e','e']
			return 46
		case 102 <= r && r <= 122: // ['f','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S40
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 114: // ['a','r']
			return 2
		case r == 115: // ['s','s']
			return 47
		case 116 <= r && r <= 122: // ['t','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S41
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 122: // ['a','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S42
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 115: // ['a','s']
			return 2
		case r == 116: // ['t','t']
			return 48
		case 117 <= r && r <= 122: // ['u','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S43
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 122: // ['a','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S44
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 122: // ['a','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S45
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 122: // ['a','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S46
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 109: // ['a','m']
			return 2
		case r == 110: // ['n','n']
			return 49
		case 111 <= r && r <= 122: // ['o','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S47
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 122: // ['a','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S48
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 100: // ['a','d']
			return 2
		case r == 101: // ['e','e']
			return 50
		case 102 <= r && r <= 122: // ['f','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S49
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 114: // ['a','r']
			return 2
		case r == 115: // ['s','s']
			return 51
		case 116 <= r && r <= 122: // ['t','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S50
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 114: // ['a','r']
			return 2
		case r == 115: // ['s','s']
			return 52
		case 116 <= r && r <= 122: // ['t','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S51
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 122: // ['a','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},

	// S52
	func(r rune) int {
		switch {
		case r == 33: // ['!','!']
			return 2
		case r == 35: // ['#','#']
			return 2
		case r == 36: // ['$','$']
			return 2
		case r == 37: // ['%','%']
			return 2
		case r == 38: // ['&','&']
			return 2
		case r == 39: // [''',''']
			return 2
		case r == 42: // ['*','*']
			return 2
		case r == 43: // ['+','+']
			return 2
		case r == 45: // ['-','-']
			return 2
		case r == 46: // ['.','.']
			return 2
		case r == 47: // ['/','/']
			return 2
		case 48 <= r && r <= 57: // ['0','9']
			return 2
		case r == 61: // ['=','=']
			return 2
		case r == 63: // ['?','?']
			return 2
		case r == 64: // ['@','@']
			return 2
		case 65 <= r && r <= 90: // ['A','Z']
			return 2
		case r == 94: // ['^','^']
			return 2
		case r == 95: // ['_','_']
			return 2
		case r == 96: // ['`','`']
			return 2
		case 97 <= r && r <= 122: // ['a','z']
			return 2
		case r == 123: // ['{','{']
			return 2
		case r == 124: // ['|','|']
			return 2
		case r == 125: // ['}','}']
			return 2
		case r == 126: // ['~','~']
			return 2
		case 256 <= r && r <= 1114111: // [\u0100,\U0010ffff]
			return 2

		}
		return NoState

	},
}
