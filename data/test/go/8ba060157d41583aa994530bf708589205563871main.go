package main

import (
	"bytes"
	"io"
	"fmt"
)

/*
练习 7.2：
写一个带有如下函数签名的函数CountingWriter，传入一个io.Writer接口类型，
返回一个新的Writer类型把原来的Writer封装在里面和一个表示写入新的Writer字节数的int64类型指针
*/

type MyWrite struct {
	counter int64
	w       io.Writer
}

func (m *MyWrite) Write(p []byte) (int, error) {
	c, e := m.w.Write(p)
	m.counter += int64(c)
	return c, e
}

func CountingWriter(w io.Writer) (io.Writer, *int64) {
	newWrite := &MyWrite{0, w}
	return newWrite, &newWrite.counter
}

func main() {
	b := bytes.NewBufferString("Work Hard")
	newWrite, counter := CountingWriter(b)
	fmt.Fprintf(newWrite, " And %s", "Play Hard")
	fmt.Println(*counter)
	fmt.Fprintf(newWrite, "!");
	fmt.Println(*counter)
}
