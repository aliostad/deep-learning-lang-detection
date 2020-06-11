package parser

import (
  "fmt"
  xtc_core "bitbucket.org/yyuu/xtc/core"
)

type token struct {
  id int
  literal string
  location xtc_core.Location
}

func (self token) String() string {
  return fmt.Sprintf("%s %s %q", self.location, self.displayName(), self.literal)
}

func (self token) displayName() string {
  switch self.id {
    case EOF:           return "EOF"
    case SPACES:        return "SPACES"
    case BLOCK_COMMENT: return "BLOCK_COMMENT"
    case LINE_COMMENT:  return "LINE_COMMENT"
    case IDENTIFIER:    return "IDENTIFIER"
    case INTEGER:       return "INTEGER"
    case CHARACTER:     return "CHARACTER"
    case STRING:        return "STRING"
    case TYPENAME:      return "TYPENAME"

    /* keywords */
    case VOID:          return "VOID"
    case CHAR:          return "CHAR"
    case SHORT:         return "SHORT"
    case INT:           return "INT"
    case LONG:          return "LONG"
    case STRUCT:        return "STRUCT"
    case UNION:         return "UNION"
    case ENUM:          return "ENUM"
    case STATIC:        return "STATIC"
    case EXTERN:        return "EXTERN"
    case CONST:         return "CONST"
    case SIGNED:        return "SIGNED"
    case UNSIGNED:      return "UNSIGNED"
    case IF:            return "IF"
    case ELSE:          return "ELSE"
    case SWITCH:        return "SWITCH"
    case CASE:          return "CASE"
    case DEFAULT:       return "DEFAULT"
    case WHILE:         return "WHILE"
    case DO:            return "DO"
    case FOR:           return "FOR"
    case RETURN:        return "RETURN"
    case BREAK:         return "BREAK"
    case CONTINUE:      return "CONTINUE"
    case GOTO:          return "GOTO"
    case TYPEDEF:       return "TYPEDEF"
    case IMPORT:        return "IMPORT"
    case SIZEOF:        return "SIZEOF"

    /* operators */
    case DOTDOTDOT:     return "DOTDOTDOT"
    case LSHIFTEQ:      return "LSHIFTEQ"
    case RSHIFTEQ:      return "RSHIFTEQ"
    case NEQ:           return "NEQ"
    case MODEQ:         return "MODEQ"
    case ANDAND:        return "ANDAND"
    case ANDEQ:         return "ANDEQ"
    case MULEQ:         return "MULEQ"
    case PLUSPLUS:      return "PLUSPLUS"
    case PLUSEQ:        return "PLUSEQ"
    case MINUSMINUS:    return "MINUSMINUS"
    case MINUSEQ:       return "MINUSEQ"
    case ARROW:         return "ARROW"
    case DIVEQ:         return "DIVEQ"
    case LSHIFT:        return "LSHIFT"
    case LTEQ:          return "LTEQ"
    case EQEQ:          return "EQEQ"
    case GTEQ:          return "GTEQ"
    case RSHIFT:        return "RSHIFT"
    case XOREQ:         return "XOREQ"
    case OREQ:          return "OREQ"
    case OROR:          return "OROR"
    default: {
      return fmt.Sprintf("ID:%X", self.id)
    }
  }
}
