package parse

import (
	"strings"
	"unicode"
	"unicode/utf8"
)

// token represents a unit of information found in an IDL file.
type token struct {
	t int    // The tokens on the form T_XXX defined in the parser. Mandatory.
	v string // Any additional token value for strings, integers and floats. May be an empty string.
}

// String is an implementation of the Stringer interface. Returns a string representing the token for printing purposes.
func (t token) String() string {
	s := IdlTokname(t.t - IdlPrivate + 2)
	if t.t == 0 {
		s = "EOF"
	}
	if len(t.v) > 0 {
		s += " \"" + t.v + "\""
	}
	return s
}

// Returns a new token given the string "s".
func toToken(s string) token {
	t := token{}
	switch strings.ToLower(s) {
	case "{":
		t.t = T_LEFT_CURLY_BRACKET
	case "}":
		t.t = T_RIGHT_CURLY_BRACKET
	case "[":
		t.t = T_LEFT_SQUARE_BRACKET
	case "]":
		t.t = T_RIGHT_SQUARE_BRACKET
	case "(":
		t.t = T_LEFT_PARANTHESIS
	case ")":
		t.t = T_RIGHT_PARANTHESIS
	case ":":
		t.t = T_COLON
	case ",":
		t.t = T_COMMA
	case ";":
		t.t = T_SEMICOLON
	case "=":
		t.t = T_EQUAL
	case ">>":
		t.t = T_SHIFTRIGHT
	case "<<":
		t.t = T_SHIFTLEFT
	case "+":
		t.t = T_PLUS_SIGN
	case "-":
		t.t = T_MINUS_SIGN
	case "*":
		t.t = T_ASTERISK
	case "/":
		t.t = T_SOLIDUS
	case "%":
		t.t = T_PERCENT_SIGN
	case "~":
		t.t = T_TILDE
	case "|":
		t.t = T_VERTICAL_LINE
	case "^":
		t.t = T_CIRCUMFLEX
	case "&":
		t.t = T_AMPERSAND
	case "<":
		t.t = T_LESS_THAN_SIGN
	case ">":
		t.t = T_GREATER_THAN_SIGN
	case "const":
		t.t = T_CONST
	case "typedef":
		t.t = T_TYPEDEF
	case "float":
		t.t = T_FLOAT
	case "double":
		t.t = T_DOUBLE
	case "char":
		t.t = T_CHAR
	case "wchar":
		t.t = T_WCHAR
	case "fixed":
		t.t = T_FIXED
	case "boolean":
		t.t = T_BOOLEAN
	case "string":
		t.t = T_STRING
	case "wstring":
		t.t = T_WSTRING
	case "void":
		t.t = T_VOID
	case "unsigned":
		t.t = T_UNSIGNED
	case "long":
		t.t = T_LONG
	case "short":
		t.t = T_SHORT
	case "false":
		t.t = T_FALSE
	case "true":
		t.t = T_TRUE
	case "struct":
		t.t = T_STRUCT
	case "union":
		t.t = T_UNION
	case "switch":
		t.t = T_SWITCH
	case "case":
		t.t = T_CASE
	case "default":
		t.t = T_DEFAULT
	case "enum":
		t.t = T_ENUM
	case "in":
		t.t = T_IN
	case "out":
		t.t = T_OUT
	case "interface":
		t.t = T_INTERFACE
	case "abstract":
		t.t = T_ABSTRACT
	case "valuetype":
		t.t = T_VALUETYPE
	case "truncatable":
		t.t = T_TRUNCATABLE
	case "supports":
		t.t = T_SUPPORTS
	case "custom":
		t.t = T_CUSTOM
	case "public":
		t.t = T_PUBLIC
	case "private":
		t.t = T_PRIVATE
	case "factory":
		t.t = T_FACTORY
	case "native":
		t.t = T_NATIVE
	case "valuebase":
		t.t = T_VALUEBASE
	case "::":
		t.t = T_SCOPE
	case "module":
		t.t = T_MODULE
	case "octet":
		t.t = T_OCTET
	case "any":
		t.t = T_ANY
	case "sequence":
		t.t = T_SEQUENCE
	case "readonly":
		t.t = T_READONLY
	case "attribute":
		t.t = T_ATTRIBUTE
	case "exception":
		t.t = T_EXCEPTION
	case "oneway":
		t.t = T_ONEWAY
	case "inout":
		t.t = T_INOUT
	case "raises":
		t.t = T_RAISES
	case "context":
		t.t = T_CONTEXT
	case "object":
		t.t = T_OBJECT
	case "principal":
		t.t = T_PRINCIPAL
	default:
		t.t = T_IDENTIFIER
		t.v = s
	}

	// Is this a number of some sort?
	r, _ := utf8.DecodeRuneInString(s)
	if unicode.IsDigit(r) {
		// Is it a float (does it contain a period)?
		if strings.ContainsRune(s, '.') {
			t.t = T_FLOATING_PT_LITERAL
		} else {
			t.t = T_INTEGER_LITERAL
		}
		t.v = s
	} else if r == '"' {
		// It's a string literal. Store the string with the quotes removed.
		t.t = T_STRING_LITERAL
		t.v = strings.Trim(s, "\"")
	}
	return t
}
