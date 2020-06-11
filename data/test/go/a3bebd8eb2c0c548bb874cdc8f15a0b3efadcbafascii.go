package utils

func GetAsciiS(v []int) string {
	var a string
	for _, i := range v {
		a += GetAsciiC(i)
	}
	return a
}

func GetAsciiC(v int) string {
	switch v {
	case 65:
		return "A"
		break
	case 66:
		return "B"
		break
	case 67:
		return "C"
		break
	case 68:
		return "D"
		break
	case 69:
		return "E"
		break
	case 70:
		return "F"
		break
	case 71:
		return "G"
		break
	case 72:
		return "H"
		break
	case 73:
		return "I"
		break
	case 74:
		return "J"
		break
	case 75:
		return "K"
		break
	case 76:
		return "L"
		break
	case 77:
		return "M"
		break
	case 78:
		return "N"
		break
	case 79:
		return "O"
		break
	case 80:
		return "P"
		break
	case 81:
		return "Q"
		break
	case 82:
		return "R"
		break
	case 83:
		return "S"
		break
	case 84:
		return "T"
		break
	case 85:
		return "U"
		break
	case 86:
		return "V"
		break
	case 87:
		return "W"
		break
	case 88:
		return "X"
		break
	case 89:
		return "Y"
		break
	case 90:
		return "Z"
		break
	}
	return ""
}

func GetAsciiI(v string) []int {
	var res []int
	for _, pos := range v {
		switch pos {
		case 'A':
			res = append(res, 65)
			break
		case 'B':
			res = append(res, 66)
			break
		case 'C':
			res = append(res, 67)
			break
		case 'D':
			res = append(res, 68)
			break
		case 'E':
			res = append(res, 69)
			break
		case 'F':
			res = append(res, 70)
			break
		case 'G':
			res = append(res, 71)
			break
		case 'H':
			res = append(res, 72)
			break
		case 'I':
			res = append(res, 73)
			break
		case 'J':
			res = append(res, 74)
			break
		case 'K':
			res = append(res, 75)
			break
		case 'L':
			res = append(res, 76)
			break
		case 'M':
			res = append(res, 77)
			break
		case 'N':
			res = append(res, 78)
			break
		case 'O':
			res = append(res, 79)
			break
		case 'P':
			res = append(res, 80)
			break
		case 'Q':
			res = append(res, 81)
			break
		case 'R':
			res = append(res, 82)
			break
		case 'S':
			res = append(res, 83)
			break
		case 'T':
			res = append(res, 84)
			break
		case 'U':
			res = append(res, 85)
			break
		case 'V':
			res = append(res, 86)
			break
		case 'W':
			res = append(res, 87)
			break
		case 'X':
			res = append(res, 88)
			break
		case 'Y':
			res = append(res, 89)
			break
		case 'Z':
			res = append(res, 90)
			break
		}
	}
	return res
}
