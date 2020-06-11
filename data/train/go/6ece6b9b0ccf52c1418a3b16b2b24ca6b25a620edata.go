package data

import (
	"fmt"
	"os"
)

const (
	DELAY   = "DELAY"
	GUI     = "GUI"
	STRING  = "STRING"
	REM     = "REM"
	ENTER   = "ENTER"
	SPACE   = "SPACE"
	CONTROL = "CONTROL"
	ALT     = "ALT"
	WRITE   = "WRITE"
	PRINT   = "PRINT"
)

type Files struct {
	InFile  *os.File
	OutFile *os.File
}

func (f *Files) AppendOut(data string) {
	fmt.Fprintf(f.OutFile, data)
}

func (f *Files) AppendToFile(data string, iter int) {
	writeString := ""

	writeString += "#include \"DigiKeyboard.h\"\n\n"
	if iter > 0 {
		writeString += "int iter = 0;\n\n"
	}
	writeString += "void setup() {\n"
	if iter > 0 {
		writeString += "\tpinMode(1, OUTPUT);\n"
	}
	writeString += "}\n\n"

	writeString += "void loop() {\n"
	if iter > 0 {
		writeString += fmt.Sprintf("\tif(iter != %d) {\n\n", iter)
		writeString += "\tdigitalWrite(1, LOW);\n"
	}
	writeString += "\tDigiKeyboard.sendKeyStroke(0); // Needed for older systems.\n"
	writeString += "\tDigiKeyboard.update(); // Needed to maintain USB connection.\n\n"

	writeString += data

	if iter > 0 {
		writeString += "\tdigitalWrite(1, HIGH);\n\n"
		writeString += "\titer++;\n\n"
		writeString += "\t}\n"
	}

	writeString += "}\n"

	f.AppendOut(writeString)
}
