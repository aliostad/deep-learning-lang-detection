package main

import (
	"os"

	hadoop "github.com/schmichael/hadoopfiles"
)

func main() {
	w := hadoop.NewRowWriter()
	w.WriteString("testing")
	w.WriteBool(true)
	w.WriteInt(1)
	w.WriteNull()
	w.WriteStrArray([]string{"Hello", "World!"})
	w.WriteStrIntMap(map[string]int{"ten": 10})
	os.Stdout.Write(w.Row())

	w.WriteString("row2")
	w.WriteBool(false)
	w.WriteInt(2)
	w.WriteInt(9001)
	w.WriteStrArray([]string{"Goodbye", "cruel", "world!"})
	w.WriteStrIntMap(map[string]int{"over": 9000})
	os.Stdout.Write(w.Row())
}
