package main

import (
	"bytes"
	"fmt"
)

func main() {
	// Concatenate string literal simply
	fmt.Println("Panda " + "is " + "cute.")
	// However, string object is generated for every + is used

	// If bytes.Buffer is used, new object is not generated
	// when string is concatenated
	// Here, bytes.Buffer is a variable-sized buffer of bytes.
	var buffer bytes.Buffer
	buffer.WriteString("P")
	buffer.WriteString("a")
	buffer.WriteString("n")
	buffer.WriteString("d")
	buffer.WriteString("a")
	fmt.Println(buffer.String())

	buffer.WriteString(" ")
	buffer.WriteString("i")
	buffer.WriteString("s")
	buffer.WriteString(" ")
	buffer.WriteString("c")
	buffer.WriteString("u")
	buffer.WriteString("t")
	buffer.WriteString("e")
	buffer.WriteString(".")
	fmt.Println(buffer.String())
}
