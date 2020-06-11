package whatsyourvectorvictor

// Translate rune returns the NATO code word for a given rune or empty string
// if not found.
func TranslateRune(c rune) string {
	switch c {
	case 'a', 'A':
		return Alphabet[0]
	case 'b', 'B':
		return Alphabet[1]
	case 'c', 'C':
		return Alphabet[2]
	case 'd', 'D':
		return Alphabet[3]
	case 'e', 'E':
		return Alphabet[4]
	case 'f', 'F':
		return Alphabet[5]
	case 'g', 'G':
		return Alphabet[6]
	case 'h', 'H':
		return Alphabet[7]
	case 'i', 'I':
		return Alphabet[8]
	case 'j', 'J':
		return Alphabet[9]
	case 'k', 'K':
		return Alphabet[10]
	case 'l', 'L':
		return Alphabet[11]
	case 'm', 'M':
		return Alphabet[12]
	case 'n', 'N':
		return Alphabet[13]
	case 'o', 'O':
		return Alphabet[14]
	case 'p', 'P':
		return Alphabet[15]
	case 'q', 'Q':
		return Alphabet[16]
	case 'r', 'R':
		return Alphabet[17]
	case 's', 'S':
		return Alphabet[18]
	case 't', 'T':
		return Alphabet[19]
	case 'u', 'U':
		return Alphabet[20]
	case 'v', 'V':
		return Alphabet[21]
	case 'w', 'W':
		return Alphabet[22]
	case 'x', 'X':
		return Alphabet[23]
	case 'y', 'Y':
		return Alphabet[24]
	case 'z', 'Z':
		return Alphabet[25]
	}
	return ""
}
