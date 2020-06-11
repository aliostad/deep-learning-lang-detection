package main

import "log"

func main() {
	log.Println("AdventOfCode.com - Day 3 - Puzzle 2")

	elfDispatch := NewElfDispatch("./puzzle-input.txt")
	defer elfDispatch.Close()

	santas := []*Santa{
		NewSanta("Santa", 1),
		NewSanta("Robo-Santa", 0),
	}

	elfDispatch.AddSantas(santas)

	var direction string
	var done bool

	for {
		direction, done = elfDispatch.GetNextDirection()
		if done {
			break
		}

		elfDispatch.DispatchNextSanta(direction)
	}

	log.Printf("Total houses visited: %d\n", elfDispatch.CountHousesVisited())
}
