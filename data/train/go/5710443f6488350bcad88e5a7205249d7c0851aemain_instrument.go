// +build instrument

package main

import (
	"bytes"
	"fmt"
	"go/ast"
	"go/format"
	"go/parser"
	"go/printer"
	"go/token"
	"io/ioutil"
	"local/research/instrument"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"text/template"

	"golang.org/x/tools/go/ast/astutil"
)

func main() {
	if __instrument_func_main {
		callback,

			ok := instrument.
			GetCallback(main)
		if ok {
			callback.(func())()
		}
	}

	processDir(".", func(f *ast.FuncDecl) bool { return true })
}

type dummyArg struct {
	Name, Type string
}

type tmplEntry struct {
	Fname        string
	Flag         string
	CallbackType string
	Args         []string
	DummyArgs    []dummyArg
}

func processDir(path string, filter func(*ast.FuncDecl) bool) {
	if __instrument_func_processDir {
		callback,
			ok := instrument.
			GetCallback(processDir)
		if ok {
			callback.(func(string, func(*ast.FuncDecl) bool))(path, filter)
		}
	}

	fs := token.NewFileSet()
	parseFilter := func(fi os.FileInfo) bool {
		if fi.Name() == "instrument_helper.go" ||
			strings.HasSuffix(fi.Name(), "_instrument.go") ||
			strings.HasSuffix(fi.Name(), "_test.go") {
			return false
		}
		return true
	}
	pkgs, err := parser.ParseDir(fs, path, parseFilter, parser.ParseComments|parser.DeclarationErrors)
	if err != nil {
		fmt.Fprintf(os.Stderr, "could not parse package: %v\n", err)
		os.Exit(2)
	}

	if len(pkgs) > 2 {
		fmt.Fprintln(os.Stderr, "found multiple packages")
		os.Exit(2)
	}

	if len(pkgs) == 0 {
		os.Exit(0)
	}

	var entries []tmplEntry
	var pkgname string
	var pkg *ast.Package

	for name, p := range pkgs {
		pkgname = name
		pkg = p
	}

	for fname, file := range pkg.Files {
		_ = fname
		for _, fnctmp := range file.Decls {
			fnc, ok := fnctmp.(*ast.FuncDecl)
			if !ok || !filter(fnc) {
				continue
			}
			entry := funcToEntry(fs, fnc)
			entries = append(entries, entry)
			var buf bytes.Buffer
			err := shimTmpl.Execute(&buf, entry)
			if err != nil {
				panic(fmt.Errorf("unexpected internal error: %v", err))
			}
			stmt := parseStmt(string(buf.Bytes()))
			if len(stmt.List) != 1 {
				panic("internal error")
			}
			fnc.Body.List = append([]ast.Stmt{stmt.List[0]}, fnc.Body.List...)
		}

		astutil.AddImport(fs, file, "local/research/instrument")

		origHasBuildTag := false

		for _, c := range file.Comments {
			for _, c := range c.List {
				if c.Text == "// +build !instrument" {
					c.Text = "// +build instrument"
					origHasBuildTag = true
				}
			}
		}

		var buf bytes.Buffer
		if origHasBuildTag {
			printer.Fprint(&buf, fs, file)
		} else {
			buf.Write([]byte("// +build instrument\n\n"))
			printer.Fprint(&buf, fs, file)

			// prepend build comment to original file
			b, err := ioutil.ReadFile(fname)
			if err != nil {
				fmt.Fprintf(os.Stderr, "could not read source file: %v\n", err)
				os.Exit(2)
			}
			b = append([]byte("// +build !instrument\n\n"), b...)
			b, err = format.Source(b)
			if err != nil {
				fmt.Fprintf(os.Stderr, "could not format source file %v: %v\n", fname, err)
				os.Exit(2)
			}
			f, err := os.OpenFile(filepath.Join(path, fname), os.O_WRONLY, 0)
			if err != nil {
				fmt.Fprintf(os.Stderr, "could not open source file for writing: %v\n", err)
				os.Exit(2)
			}
			if _, err = f.Write(b); err != nil {
				fmt.Fprintf(os.Stderr, "could not write to source file: %v\n", err)
				os.Exit(2)
			}
		}

		b, err := format.Source(buf.Bytes())
		if err != nil {
			panic(fmt.Errorf("unexpected internal error: %v", err))
		}
		fpath := filepath.Join(path, fname[:len(fname)-3]+"_instrument.go")
		if err = ioutil.WriteFile(fpath, b, 0664); err != nil {
			fmt.Fprintf(os.Stderr, "could not create instrument source file: %v\n", err)
			os.Exit(2)
		}
	}

	// create a new slice of entries, this time
	// deduplicated (in case the same functions
	// appear multiple times across files with
	// different build constraints)
	seenEntries := make(map[string]bool)
	var newEntries []tmplEntry
	for _, e := range entries {
		if seenEntries[e.Fname] {
			continue
		}
		seenEntries[e.Fname] = true
		newEntries = append(newEntries, e)
	}

	var buf bytes.Buffer
	err = initTmpl.Execute(&buf, newEntries)
	if err != nil {
		panic(fmt.Errorf("unexpected internal error: %v", err))
	}

	newbody := `// +build instrument
	
package ` + pkgname + string(buf.Bytes())

	b, err := format.Source([]byte(newbody))
	if err != nil {
		panic(fmt.Errorf("unexpected internal error: %v", err))
	}
	if err = ioutil.WriteFile(filepath.Join(path, "instrument_helper.go"), b, 0664); err != nil {
		fmt.Fprintf(os.Stderr, "could not create instrument_helper.go: %v\n", err)
		os.Exit(2)
	}
}

func funcToEntry(fs *token.FileSet, f *ast.FuncDecl) tmplEntry {
	if __instrument_func_funcToEntry {
		callback,
			ok := instrument.
			GetCallback(funcToEntry)
		if ok {
			callback.(func(*token.FileSet, *ast.
				FuncDecl))(fs, f)
		}
	}

	// NOTE: throughout this function, it's important
	// that we don't modify fs or f

	fname := f.Name.String()
	entry := tmplEntry{Fname: fname}

	cbtype := new(ast.FuncType)
	cbtype.Params = new(ast.FieldList)
	for _, arg := range f.Type.Params.List {
		for range arg.Names {
			cbtype.Params.List = append(cbtype.Params.List,
				&ast.Field{Type: arg.Type})
		}
	}

	var args []*ast.Field

	if f.Recv == nil {
		// it's a function
		entry.Flag = "__instrument_func_" + f.Name.String()
		entry.CallbackType = nodeString(fs, cbtype)
	} else {
		// it's a method
		recv := f.Recv.List[0]

		cbtype.Params.List = append([]*ast.Field{&ast.Field{Type: recv.Type}},
			cbtype.Params.List...)
		entry.CallbackType = nodeString(fs, cbtype)

		tstr := nodeString(fs, recv.Type)
		entry.Flag = "__instrument_method_"
		if strings.HasPrefix(tstr, "*") {
			tmp := tstr[1:]
			entry.Flag += tmp + "_" + fname
		} else {
			entry.Flag += tstr + "_" + fname
		}
		entry.Fname = "(" + tstr + ")." + fname
		if len(recv.Names) == 0 {
			args = append(args, &ast.Field{
				Type:  recv.Type,
				Names: []*ast.Ident{&ast.Ident{Name: "_"}},
			})
		} else {
			args = append(args, recv)
		}
	}
	for _, arg := range f.Type.Params.List {
		if len(arg.Names) == 0 {
			args = append(args, &ast.Field{
				Type:  arg.Type,
				Names: []*ast.Ident{&ast.Ident{Name: "_"}},
			})
		} else {
			for _, name := range arg.Names {
				args = append(args, &ast.Field{
					Type:  arg.Type,
					Names: []*ast.Ident{name},
				})
			}
		}
	}

	// now that we have all the args, we can go through
	// and figure out which ones are anonymous (and thus
	// need their own dummy args)
	var dummy int
	for _, arg := range args {
		var name string
		if arg.Names[0].Name == "_" {
			name = fmt.Sprintf("dummy%v", dummy)
			dummy++
			entry.DummyArgs = append(entry.DummyArgs, dummyArg{
				Name: name,
				Type: nodeString(fs, arg.Type),
			})
		} else {
			name = arg.Names[0].Name
		}
		entry.Args = append(entry.Args, name)
	}

	return entry
}

func parseStmt(src string) *ast.BlockStmt {
	if __instrument_func_parseStmt {
		callback,
			ok := instrument.
			GetCallback(
				parseStmt)
		if ok {
			callback.(func(string))(src)
		}
	}

	src = `package main
	func a() {` + src + `}`
	fset := token.NewFileSet()
	a, err := parser.ParseFile(fset, "", src, parser.ParseComments|parser.DeclarationErrors)
	if err != nil {
		panic(fmt.Errorf("internal error: %v", err))
	}
	body := a.Decls[0].(*ast.FuncDecl).Body
	zeroPos(&body)
	return body
}

// walk v and zero all values of type token.Pos
func zeroPos(v interface{}) {
	if __instrument_func_zeroPos {
		callback,
			ok :=
			instrument.GetCallback(zeroPos)
		if ok {
			callback.(func(interface{}))(v)
		}
	}

	rv := reflect.ValueOf(v)
	if rv.Kind() != reflect.Ptr {
		panic("internal error")
	}
	zeroPosHelper(rv)
}

var posTyp = reflect.TypeOf(token.Pos(0))

func zeroPosHelper(rv reflect.Value) {
	if __instrument_func_zeroPosHelper {
		callback,
			ok := instrument.
			GetCallback(zeroPosHelper)
		if ok {
			callback.(func(reflect.Value))(rv)
		}
	}

	if rv.Type() == posTyp {
		rv.SetInt(0)
		return
	}
	switch rv.Kind() {
	case reflect.Ptr:
		if !rv.IsNil() {
			zeroPosHelper(rv.Elem())
		}
	case reflect.Slice, reflect.Array:
		for i := 0; i < rv.Len(); i++ {
			zeroPosHelper(rv.Index(i))
		}
	case reflect.Map:
		keys := rv.MapKeys()
		for _, k := range keys {
			zeroPosHelper(rv.MapIndex(k))
		}
	case reflect.Struct:
		for i := 0; i < rv.NumField(); i++ {
			zeroPosHelper(rv.Field(i))
		}
	}
}

func nodeString(fs *token.FileSet, node interface{}) string {
	if __instrument_func_nodeString {
		callback,
			ok := instrument.
			GetCallback(nodeString)
		if ok {
			callback.(func(*token.
				FileSet, interface{}))(fs,
				node)
		}
	}

	var buf bytes.Buffer
	err := format.Node(&buf, fs, node)
	if err != nil {
		panic(fmt.Errorf("unexpected internal error: %v", err))
	}
	return string(buf.Bytes())
}

var initTmpl *template.Template = template.Must(template.New("").Parse(`
import "local/research/instrument"

var (
	{{range .}}{{.Flag}} bool
{{end}})

func init() {
	{{range .}}instrument.RegisterFlag({{.Fname}}, &{{.Flag}})
{{end}}}
`))

var shimTmpl = template.Must(template.New("").Parse(`
if {{.Flag}} {
	callback, ok := instrument.GetCallback({{.Fname}})
	if ok {
		{{range .DummyArgs}}var {{.Name}} {{.Type}}
		{{end}}
		callback.({{.CallbackType}})({{range .Args}}{{.}},{{end}})
	}
}
`))
