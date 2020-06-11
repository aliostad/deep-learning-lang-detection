package main

import (
	"fmt"
	"os"
	_"io"
	"bufio"
)

func WriteFile(){
	/*file should be exist*/
	//f, err := os.Open("Data.txt")

	/*open and create if file is not exist*/
	f, err := os.OpenFile("data.txt", os.O_CREATE | os.O_RDWR, 0644)
	
	if err != nil {
		fmt.Println(err)
		return
	}
	defer f.Close()

	/*write file : way - 01*/	
	f.WriteString("Write buffer by File Writer - WriteString\n")
	f.Write([]byte("Write buffer by File Writer - Write\n"))

	/*write file : way - 02*/
	w := bufio.NewWriter(f)
	w.Write([]byte("Write buffer by NewWriter - Write\n"))
	w.WriteString("Write buffer by NewWriter - WriteString\n")
	w.Flush()
	w.WriteString("write file after writer flushed")

	/*write file : way - 03*/
	
}

func WriteStdout(){
	w := bufio.NewWriter(os.Stdout)
	w.Write([]byte("Zhuweijin"))
	w.Write([]byte("Hello 2016\n"))
	w.WriteString("write string buffer\n")
	w.Flush()
	w.Write([]byte("Do it Now\n"))
}

func main() {
	//WriteStdout()
	WriteFile()

}
