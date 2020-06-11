package shogi

func posStrToInt(desc []rune) int {
	var vert, hor int
	switch desc[0] {
	case 'a':
		vert = 0
	case 'b':
		vert = 1
	case 'c':
		vert = 2
	case 'd':
		vert = 3
	case 'e':
		vert = 4
	}
	switch desc[1] {
	case '1':
		hor = 0
	case '2':
		hor = 1
	case '3':
		hor = 2
	case '4':
		hor = 3
	case '5':
		hor = 4
	}
	return vert*5 + hor
}

func pieceIntToStr(code int) rune {
	switch code {
	case 0:
		return 'K'
	case 1:
		return 'k'
	case 2:
		return 'R'
	case 3:
		return 'r'
	case 4:
		return 'D'
	case 5:
		return 'd'
	case 6:
		return 'B'
	case 7:
		return 'b'
	case 8:
		return 'H'
	case 9:
		return 'h'
	case 10:
		return 'G'
	case 11:
		return 'g'
	case 12:
		return 'S'
	case 13:
		return 's'
	case 14:
		return 'W'
	case 15:
		return 'w'
	case 16:
		return 'N'
	case 17:
		return 'n'
	case 18:
		return 'I'
	case 19:
		return 'i'
	case 20:
		return 'L'
	case 21:
		return 'l'
	case 22:
		return 'A'
	case 23:
		return 'a'
	case 24:
		return 'P'
	case 25:
		return 'p'
	case 26:
		return 'T'
	case 27:
		return 't'
	}
	return ' '
}

func posIntToStr(code int) string {
	out := make([]rune, 0)
	switch code / 5 {
	case 0:
		out = append(out, 'a')
	case 1:
		out = append(out, 'b')
	case 2:
		out = append(out, 'c')
	case 3:
		out = append(out, 'd')
	case 4:
		out = append(out, 'e')
	}
	switch code % 5 {
	case 0:
		out = append(out, '1')
	case 1:
		out = append(out, '2')
	case 2:
		out = append(out, '3')
	case 3:
		out = append(out, '4')
	case 4:
		out = append(out, '5')
	}
	return string(out)
}

func pieceStrToInt(desc rune) int {
	switch desc {
	case 'K':
		return 0
	case 'k':
		return 1
	case 'R':
		return 2
	case 'r':
		return 3
	case 'D':
		return 4
	case 'd':
		return 5
	case 'B':
		return 6
	case 'b':
		return 7
	case 'H':
		return 8
	case 'h':
		return 9
	case 'G':
		return 10
	case 'g':
		return 11
	case 'S':
		return 12
	case 's':
		return 13
	case 'W':
		return 14
	case 'w':
		return 15
	case 'N':
		return 16
	case 'n':
		return 17
	case 'I':
		return 18
	case 'i':
		return 19
	case 'L':
		return 20
	case 'l':
		return 21
	case 'A':
		return 22
	case 'a':
		return 23
	case 'P':
		return 24
	case 'p':
		return 25
	case 'T':
		return 26
	case 't':
		return 27
	}
	return ' '
}
