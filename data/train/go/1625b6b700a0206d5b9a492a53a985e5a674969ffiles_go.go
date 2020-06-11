package main

import "os"

func buildGoProject() {
	mkdir(path + "/bin")

	goBin(path + "/bin/build.sh")
	os.Chmod(path+"/bin/build.sh", 0755)

	goMain(path + "/" + nameSnakeCase + ".go")
	goTest(path + "/" + nameSnakeCase + "_test.go")
}

func goBin(path string) {
	f := mkfile(path)
	writeLine(f, "#!/bin/bash")
	writeLine(f, "")
	writeLine(f, "set -x")
	writeLine(f, "set -e")
	writeLine(f, "")
	writeLine(f, "ROOT=\"$(cd \"$( dirname \"${BASH_SOURCE[0]}\" )/..\" && pwd)\"")
	writeLine(f, "cd $ROOT && go build")
}

func goMain(path string) {
	f := mkfile(path)
	writeLine(f, "package main")
	writeLine(f, "")
	writeLine(f, "import \"fmt\"")
	writeLine(f, "")
	writeLine(f, "func message() string {")
	writeLine(f, "	return \"Hello World!\"")
	writeLine(f, "}")
	writeLine(f, "")
	writeLine(f, "func main() {")
	writeLine(f, "	msg := message()")
	writeLine(f, "	fmt.Println(msg)")
	writeLine(f, "}")
}

func goTest(path string) {
	f := mkfile(path)
	writeLine(f, "package main")
	writeLine(f, "")
	writeLine(f, "import \"testing\"")
	writeLine(f, "")
	writeLine(f, "func TestMyFunction(t *testing.T) {")
	writeLine(f, "	expected := \"Hello World!\"")
	writeLine(f, "	actual := message()")
	writeLine(f, "	if actual != expected {")
	writeLine(f, "		t.Errorf(\"\\nACTUAL: %s\\nEXPECTED: %s\", actual, expected)")
	writeLine(f, "	}")
	writeLine(f, "}")
}
