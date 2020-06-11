// Usage:
//  Instrument: ./jeb <pkg|file.go>
//  Server: ./jeb
// Put /tmp first on your GOPATH, then run your app as normal
// (or if a binary run from /tmp/src/<pkg>)
package main

import (
	"fmt"
	"go/ast"
	"go/build"
	"go/format"
	"go/parser"
	"go/token"
	"log"
	"os"
	"path"
	"strconv"
	"strings"
)

const (
	insertPkg      = "jeb/client"
	insertFuncPkg  = "client"
	insertFuncName = "Trace"
)

func main() {
	if len(os.Args) == 2 {
		prepare(os.Args[1])
	} else {
		runServer()
	}
}

func prepare(target string) {
	var filenames []string
	if strings.HasSuffix(target, ".go") {
		filenames = append(filenames, target)
		target = path.Dir(target)
	} else {
		filenames = listFiles(target)
	}
	log.Println("Filenames:", filenames)
	for _, filename := range filenames {
		fset, f := single(filename)
		instrument(fset, f)
		write(target+"/"+path.Base(filename), fset, f)
	}
}

func single(filename string) (*token.FileSet, *ast.File) {
	sanity, err := os.Open(filename)
	if err != nil {
		log.Println(err)
		log.Fatal("Could not open ", filename, ". Is that path right?")
	}
	sanity.Close()

	fset := new(token.FileSet)
	f, err := parser.ParseFile(fset, filename, nil, 0)
	if err != nil {
		log.Fatal("Error in ParseFile: ", err)
	}
	return fset, f
}

func listFiles(pkgName string) []string {
	pkg, err := build.Import(pkgName, "", build.FindOnly)
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Found package", pkgName, "in", pkg.Dir)

	var files []string
	d, err := os.Open(pkg.Dir)
	if err != nil {
		log.Fatal(err)
	}
	infos, err := d.Readdir(0)
	if err != nil {
		log.Fatal(err)
	}
	for _, info := range infos {
		files = append(files, pkg.Dir+"/"+info.Name())
	}
	return files
}

func importSpec() *ast.ImportSpec {
	newImport := &ast.ImportSpec{
		Path: &ast.BasicLit{
			Kind:  token.STRING,
			Value: strconv.Quote(insertPkg),
		},
	}
	return newImport
}

// Instrument this ast.File
func instrument(fset *token.FileSet, f *ast.File) {

	// Add the jeb/client import
	importSpec := importSpec()
	decl := ast.GenDecl{
		Tok:   token.IMPORT,
		Specs: []ast.Spec{importSpec},
	}
	f.Imports = append(f.Imports, importSpec)
	f.Decls = append([]ast.Decl{&decl}, f.Decls...)

	// Instrument all the functions
	for _, decl := range f.Decls {
		fdecl, ok := decl.(*ast.FuncDecl)
		if !ok {
			continue
		}

		log.Println("Instrumenting", fdecl.Name)
		instrumentFunction(fset, fdecl)
	}
}

// Write out a single instrumented file per package, to temp dir
func write(filename string, fset *token.FileSet, f *ast.File) {
	out, err := os.Create(outName(filename))
	if err != nil {
		log.Fatal(err)
	}
	err = format.Node(out, fset, f)
	if err != nil {
		log.Println(err)
		log.Println("ERROR. Writing AST to", out.Name())
		err = ast.Fprint(out, fset, f, nil)
		if err != nil {
			log.Fatal(err)
		}
	}
}

// outName is the name of the instrumented file
func outName(inName string) string {
	rootDir := os.TempDir()
	outDir := fmt.Sprintf("%s/src/%s/", rootDir, path.Dir(inName))
	os.MkdirAll(outDir, os.ModePerm)
	out := outDir + path.Base(inName)
	log.Println("Writing to ", out)
	return out
}

func instrumentFunction(fset *token.FileSet, fdecl *ast.FuncDecl) {
	funcname := fdecl.Name.String()
	instrumentBlock(fset, fdecl.Body, funcname)
}

func instrumentBlock(fset *token.FileSet, block *ast.BlockStmt, funcname string) {
	finalList := instrumentList(fset, block.List, funcname)
	block.List = finalList
}

// Can we put a statement right before this?
// False for 'switch/case' and 'select/comm'
func canStmt(expr ast.Stmt) bool {
	_, isInSwitch := expr.(*ast.CaseClause)
	_, isInSelect := expr.(*ast.CommClause)
	return !(isInSwitch || isInSelect)
}

// Add the client.Trace statement
func addTrace(l []ast.Stmt, position token.Position, funcname string) []ast.Stmt {
	return append(
		l,
		makeCall(
			insertFuncPkg,
			insertFuncName,
			strconv.Quote("LINE"),
			strconv.Quote(position.Filename),
			strconv.Quote(fmt.Sprintf("%d", position.Line)),
			strconv.Quote(funcname),
		),
	)
}

func instrumentList(fset *token.FileSet, list []ast.Stmt, funcname string) []ast.Stmt {
	var finalList []ast.Stmt
	local := make(map[string]bool)

	for _, expr := range list {

		log.Printf("%T, %v", expr, expr)
		if canStmt(expr) {
			position := fset.Position(expr.Pos())
			finalList = addTrace(finalList, position, funcname)
		}

		/*
			for varName := range local {
				finalList = append(
					finalList,
					makeCall(
						insertFuncPkg,
						insertFuncName,
						strconv.Quote("VAR"),
						strconv.Quote(varName),
						varName,	// TODO: Emit AST for fmt.Sprintf("%s", varName)
					),
				)
			}
		*/

		isCall, callName := isCallExpr(expr)
		if isCall {
			finalList = append(
				finalList,
				makeCall(
					insertFuncPkg,
					insertFuncName,
					strconv.Quote("ENTER"),
					strconv.Quote(callName),
				),
			)
		}

		finalList = append(finalList, expr)

		if isCall {
			finalList = append(
				finalList,
				makeCall(
					insertFuncPkg,
					insertFuncName,
					strconv.Quote("EXIT"),
					strconv.Quote(callName),
				),
			)
		}

		switch texpr := expr.(type) {
		case *ast.CaseClause:
			finalList := instrumentList(fset, texpr.Body, funcname)
			texpr.Body = finalList
		case *ast.AssignStmt:
			for _, expr := range texpr.Lhs {
				if ident, ok := expr.(*ast.Ident); ok {
					log.Printf("Found variable '%s'\n", ident.Name)
					local[ident.Name] = true
				}
			}
		case *ast.IfStmt:
			instrumentBlock(fset, texpr.Body, funcname)
		case *ast.ForStmt:
			instrumentBlock(fset, texpr.Body, funcname)
		case *ast.SwitchStmt:
			instrumentBlock(fset, texpr.Body, funcname)
		case *ast.SelectStmt:
			instrumentBlock(fset, texpr.Body, funcname)
		case *ast.RangeStmt:
			instrumentBlock(fset, texpr.Body, funcname)
		}
	}
	return finalList
}

func isCallExpr(expr ast.Stmt) (bool, string) {
	exprstmt, ok := expr.(*ast.ExprStmt)
	if !ok {
		return false, ""
	}
	callexpr, ok := exprstmt.X.(*ast.CallExpr)
	if !ok {
		return false, ""
	}

	var name string
	switch v := callexpr.Fun.(type) {
	case *ast.SelectorExpr:
		name = v.Sel.Name
	case *ast.Ident:
		name = v.Name
	}
	return true, name
}

func makeCall(pkg, fname string, args ...string) *ast.ExprStmt {

	call := &ast.CallExpr{
		Fun: &ast.SelectorExpr{
			X:   ast.NewIdent(pkg),
			Sel: ast.NewIdent(fname),
		},
		Args: []ast.Expr{},
	}
	for _, arg := range args {
		argsExpr := &ast.BasicLit{
			Kind:  token.STRING,
			Value: arg,
		}
		call.Args = append(call.Args, argsExpr)
	}

	return &ast.ExprStmt{X: call}
}
