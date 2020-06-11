package datastructs

import (
	"450-p1/process"
)

/* queue */

type Queue []process.Process

func (q *Queue) Len() int {
	return len(*q)
}

// Add node to back
func (q *Queue) Enqueue(p process.Process) {
	*q = append(*q, p)
}

// Remove and return front node
func (q *Queue) Dequeue() (p process.Process) {
	if len(*q) == 0 {
		return process.Process{}
	}
	p = (*q)[0]
	*q = (*q)[1:]
	return
}

// Return node at front
func (q *Queue) Front() (p process.Process) {
	if len(*q) == 0 {
		return process.Process{}
	}
	p = (*q)[0]
	return
}