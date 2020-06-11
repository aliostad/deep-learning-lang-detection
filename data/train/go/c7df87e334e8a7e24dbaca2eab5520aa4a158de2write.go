package parser

import (
  "fmt"
	"go/ast"
	"go/token"
)

type outputFile struct {
	out string
	line, column int
	fileSet *token.FileSet
}

func (f *outputFile) writeAfterFirst(str string, pos token.Pos, first *bool) {
  if *first {
    f.writeAt(str, pos)
  }
  *first = false
}

func (f *outputFile) writeAt(obj interface{}, pos token.Pos) {
  position := f.fileSet.Position(pos)

	for f.line < position.Line {
		f.out += "\n"
		f.line++
		f.column = 0
	}
	for f.column < position.Column {
		f.out += " "
		f.column++
	}

  f.write(obj)
}

func (f *outputFile) write(obj interface{}) {
  first := true

  switch o := obj.(type) {
  case token.Token:
    f.write(o.String())

  case string:
  	f.out += o
  	f.column += len(o)

  case *ast.Ident:
    f.writeAt(o.Name, o.NamePos)

  case *ast.FuncDecl:
  	f.writeAt("func", o.Type.Func)
  	f.writeAt(o.Name.Name, o.Name.NamePos)
  	f.write(o.Type.Params)
  	f.write(o.Body)

  case *ast.FieldList:
  	f.writeAt("(", o.Opening)
  	for _, field := range o.List {
  		f.write(field)
      f.writeAfterFirst(",", o.Opening, &first)
  	}
    f.writeAt(")", o.Closing)

  case *ast.Field:
    for _, name := range o.Names {
      f.write(name)

      // TODO: Document this. The space is important for named arguments.
      f.write(" ")
    }

    f.write(o.Type)

  case *ast.BlockStmt:
  	f.writeAt("{", o.Lbrace)
    for _, stmt := range o.List {
      f.write(stmt)
    }
    f.writeAt("}", o.Rbrace)

  case *ast.ExprStmt:
    f.write(o.X)

  case *ast.CallExpr:
    f.write(o.Fun)
    for _, arg := range o.Args {
      if a := arg.(*ast.BinaryExpr); a != nil {
        f.write("_" + a.X.(*ast.Ident).Name)
      }
    }

  	f.writeAt("(", o.Lparen)
    for _, arg := range o.Args {
      f.write(arg)
      f.writeAfterFirst(",", o.Lparen, &first)
    }
    f.writeAt(")", o.Rparen)

  case *ast.BinaryExpr:
    if o.Op != token.COLON {
      f.write(o.X)
      f.writeAt(o.Op, o.OpPos)
    }
    f.write(o.Y)

  case *ast.BasicLit:
    f.writeAt(o.Value, o.ValuePos)

  default:
    panic(fmt.Sprintf("%#v", o))
  }
}

func RenderFile(file *ast.File, fileSet *token.FileSet) string {
	f := new(outputFile)
	f.fileSet = fileSet

	f.writeAt("package", file.Package)
	f.write(file.Name)

	for _, decl := range file.Decls {
		f.write(decl)
	}

	return f.out
}
