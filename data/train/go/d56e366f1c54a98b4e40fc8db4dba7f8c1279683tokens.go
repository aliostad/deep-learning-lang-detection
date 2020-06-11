package jsonpath

// Token represents a jsonpath token
type Token int

const (
	Illegal            Token = iota
	EOF                      // End of file
	Whitespace               // A contigous squence of whitespace
	ParenLeft                // (
	ParenRight               // )
	BraceLeft                // {
	BraceRight               // }
	BracketLeft              // [
	BracketRight             // ]
	Dot                      // .
	Equals                   // ==
	GT                       // >
	LT                       // <
	GTE                      // >=
	LTE                      // <=
	NEQ                      // !=
	Not                      // !
	Comma                    // ,
	Identifier               // A valid field
	DotDot                   // ..
	Dollar                   // $
	At                       // @
	Integer                  // 1234
	Float                    // 123.4
	Bool                     // true or false
	SingleQuotedString       // 'literal string'
	DoubleQuotedString       // "literal string"
	Asterisk                 // *
	QuestionMark             // ?
	Pipe                     // |
	Colon                    // :
	Exists                   // virtual operator
	Slash                    // /
)

func (token Token) String() string {
	switch token {
	case Illegal:
		return "illegal"
	case EOF:
		return "eof"
	case Whitespace:
		return "whitespace"
	case ParenLeft:
		return "parenLeft"
	case ParenRight:
		return "parenRight"
	case BraceLeft:
		return "braceLeft"
	case BraceRight:
		return "braceRight"
	case BracketLeft:
		return "bracketLeft"
	case BracketRight:
		return "bracketRight"
	case Dot:
		return "dot"
	case Equals:
		return "equals"
	case GT:
		return "gt"
	case LT:
		return "lt"
	case GTE:
		return "gte"
	case LTE:
		return "lte"
	case NEQ:
		return "neq"
	case Not:
		return "not"
	case Comma:
		return "comma"
	case Identifier:
		return "identifier"
	case DotDot:
		return "range"
	case Integer:
		return "integer"
	case Float:
		return "float"
	case SingleQuotedString:
		return "single-quoted-string"
	case DoubleQuotedString:
		return "double-quoted-string"
	case Bool:
		return "bool"
	case Asterisk:
		return "asterisk"
	case QuestionMark:
		return "questionMark"
	case Pipe:
		return "pipe"
	case Dollar:
		return "dollar"
	case Colon:
		return "colon"
	case At:
		return "at"
	case Exists:
		return "exists"
	case Slash:
		return "slash"

	}
	return "UNKNOWN TOKEN"
}

// Literal converts a token id to a literal where applicable
func (token Token) Literal() string {
	switch token {
	case Illegal:
		return "<illegal>"
	case EOF:
		return "<eof>"
	case Whitespace:
		return " "
	case ParenLeft:
		return "("
	case ParenRight:
		return ")"
	case BraceLeft:
		return "{"
	case BraceRight:
		return "}"
	case BracketLeft:
		return "["
	case BracketRight:
		return "]"
	case Dot:
		return "."
	case Equals:
		return "=="
	case GT:
		return ">"
	case LT:
		return "<"
	case GTE:
		return ">="
	case LTE:
		return "<="
	case NEQ:
		return "!="
	case Not:
		return "!"
	case Comma:
		return ","
	case Identifier:
		return "<identifier>"
	case DotDot:
		return ".."
	case Integer:
		return "integer"
	case Float:
		return "float"
	case SingleQuotedString:
		return "<single-quoted-string>"
	case DoubleQuotedString:
		return "<double-quoted-string>"
	case Bool:
		return "bool"
	case Asterisk:
		return "*"
	case QuestionMark:
		return "?"
	case Pipe:
		return "|"
	case Dollar:
		return "$"
	case Colon:
		return ":"
	case At:
		return "@"
	case Exists:
		return "<exists>"
	}
	return "<unknown token>"
}

// MatchingBrace returns the brace matching the provided token, as in '(' returns ')' and '[' returns ']'
func MatchingBrace(token Token) Token {
	switch token {
	case ParenLeft:
		return ParenRight
	case BracketLeft:
		return BracketRight
	case BraceLeft:
		return BraceRight
	case ParenRight:
		return ParenLeft
	case BracketRight:
		return BracketLeft
	case BraceRight:
		return BraceLeft
	}
	return Illegal
}
