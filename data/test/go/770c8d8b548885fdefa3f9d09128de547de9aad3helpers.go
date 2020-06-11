package scanner

import "github.com/brettlangdon/gython/token"

func IsLetter(r rune) bool {
	return (r >= 'a' && r <= 'z') || (r >= 'A' && r <= 'Z')
}

func IsDigit(r rune) bool {
	return r >= '0' && r <= '9'
}

func IsXDigit(r rune) bool {
	return IsDigit(r) || (r >= 65 && r <= 70) || (r >= 97 && r <= 102)
}

func IsAlphaNumeric(r rune) bool {
	return IsLetter(r) || IsDigit(r)
}

func IsIdentifierStart(r rune) bool {
	return IsLetter(r) || r == '_' || r >= 128
}

func IsIdentifierChar(r rune) bool {
	return IsIdentifierStart(r) || IsDigit(r)
}

func IsQuote(r rune) bool {
	return r == '"' || r == '\''
}

func GetTwoCharTokenID(curChar rune, nextChar rune) token.TokenID {
	switch curChar {
	case '=':
		switch nextChar {
		case '=':
			return token.EQEQUAL
		}
		break
	case '!':
		switch nextChar {
		case '=':
			return token.NOTEQUAL
		}
		break
	case '<':
		switch nextChar {
		case '>':
			return token.NOTEQUAL
		case '=':
			return token.LESSEQUAL
		case '<':
			return token.LEFTSHIFT
		}
		break
	case '>':
		switch nextChar {
		case '=':
			return token.GREATEREQUAL
		case '>':
			return token.RIGHTSHIFT
		}
		break
	case '+':
		switch nextChar {
		case '=':
			return token.PLUSEQUAL
		}
		break
	case '-':
		switch nextChar {
		case '=':
			return token.MINEQUAL
		case '>':
			return token.RARROW
		}
		break
	case '*':
		switch nextChar {
		case '*':
			return token.DOUBLESTAR
		case '=':
			return token.STAREQUAL
		}
		break
	case '/':
		switch nextChar {
		case '/':
			return token.DOUBLESLASH
		case '=':
			return token.SLASHEQUAL
		}
		break
	case '|':
		switch nextChar {
		case '=':
			return token.VBAREQUAL
		}
		break
	case '%':
		switch nextChar {
		case '=':
			return token.PERCENTEQUAL
		}
		break
	case '&':
		switch nextChar {
		case '=':
			return token.AMPEREQUAL
		}
		break
	case '^':
		switch nextChar {
		case '=':
			return token.CIRCUMFLEXEQUAL
		}
		break
	case '@':
		switch nextChar {
		case '=':
			return token.ATEQUAL
		}
		break
	}
	return token.OP
}

func GetThreeCharTokenID(curChar rune, nextChar rune, thirdChar rune) token.TokenID {
	switch curChar {
	case '<':
		switch nextChar {
		case '<':
			switch thirdChar {
			case '=':
				return token.LEFTSHIFTEQUAL
			}
			break
		}
		break
	case '>':
		switch nextChar {
		case '>':
			switch thirdChar {
			case '=':
				return token.RIGHTSHIFTEQUAL
			}
			break
		}
		break
	case '*':
		switch nextChar {
		case '*':
			switch thirdChar {
			case '=':
				return token.DOUBLESTAREQUAL
			}
			break
		}
		break
	case '/':
		switch nextChar {
		case '/':
			switch thirdChar {
			case '=':
				return token.DOUBLESLASHEQUAL
			}
			break
		}
		break
	case '.':
		switch nextChar {
		case '.':
			switch thirdChar {
			case '.':
				return token.ELLIPSIS
			}
			break
		}
		break
	}
	return token.OP
}

func GetOneCharTokenID(curChar rune) token.TokenID {
	switch curChar {
	case '(':
		return token.LPAR
	case ')':
		return token.RPAR
	case '[':
		return token.LSQB
	case ']':
		return token.RSQB
	case ':':
		return token.COLON
	case ',':
		return token.COMMA
	case ';':
		return token.SEMI
	case '+':
		return token.PLUS
	case '-':
		return token.MINUS
	case '*':
		return token.STAR
	case '/':
		return token.SLASH
	case '|':
		return token.VBAR
	case '&':
		return token.AMPER
	case '<':
		return token.LESS
	case '>':
		return token.GREATER
	case '=':
		return token.EQUAL
	case '.':
		return token.DOT
	case '%':
		return token.PERCENT
	case '{':
		return token.LBRACE
	case '}':
		return token.RBRACE
	case '^':
		return token.CIRCUMFLEX
	case '~':
		return token.TILDE
	case '@':
		return token.AT
	}
	return token.OP
}
