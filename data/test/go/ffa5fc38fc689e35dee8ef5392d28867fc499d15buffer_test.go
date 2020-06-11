package buffer

import (
	"fmt"
	"testing"
)

func TestBasic(t *testing.T) {
	p := NewPool(4)
	b := p.Get()

	//	b.Write([]byte("Hello good sir, how are you?\n"))
	//	b.Write([]byte("I am well, thank you!\n"))
	//	b.Write([]byte("Oh, fantastic!\n"))
	b.Write([]byte("1"))
	b.Write([]byte("2"))
	b.Write([]byte("3"))
	b.Write([]byte("4"))
	b.Write([]byte("5"))
	var (
		n   int
		buf [2]byte
		err error
	)

	n, err = b.Read(buf[:])
	fmt.Println(n, err, string(buf[:]))

	n, err = b.Read(buf[:])
	fmt.Println(n, err, string(buf[:]))

	n, err = b.Read(buf[:])
	fmt.Println(n, err, string(buf[:]))

	n, err = b.Read(buf[:])
	fmt.Println(n, err, string(buf[:]))

	b.Reset()
	b.Write([]byte("1"))
	b.Write([]byte("2"))
	b.Write([]byte("3"))
	b.Write([]byte("4"))
	b.Write([]byte("5"))
	p.Put(b)

}
