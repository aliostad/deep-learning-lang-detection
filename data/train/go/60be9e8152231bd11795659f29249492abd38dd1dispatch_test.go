package dispatch

import (
	"fmt"
	"testing"
	"time"
)

func TestDispatch(t *testing.T) {
	dp := NewDispatch()
	defer dp.Close()

	dp.GlobalQueue.Execute(func() {
		fmt.Println("Hello World")
	})

	time.Sleep(10 * time.Millisecond)
}

func TestDispatchQueue(t *testing.T) {
	dp := NewDispatch()
	defer dp.Close()

	dp.NewQueue("foobar", NewConfig(128, 16)).Execute(func() {
		fmt.Println("Hello World")
	})

	dp.Queue("foobar").Execute(func() {
		fmt.Println("Hello World")
	})

	time.Sleep(10 * time.Millisecond)
}
