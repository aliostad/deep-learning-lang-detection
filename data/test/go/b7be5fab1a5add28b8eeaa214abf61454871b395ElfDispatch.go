package main

import (
	"bufio"
	"log"
	"os"
)

type ElfDispatch struct {
	Santas []*Santa
	Map    GridType

	currentSantaIndex int
	file              *os.File
	reader            *bufio.Scanner
}

func NewElfDispatch(fileName string) *ElfDispatch {
	result := &ElfDispatch{}
	var err error

	result.file, err = os.Open(fileName)
	if err != nil {
		log.Fatalf("Error reading puzzle file: %s", err.Error())
	}

	result.reader = bufio.NewScanner(result.file)
	result.reader.Split(bufio.ScanRunes)

	result.Map = make(GridType)
	result.Map.Visit(0, 0)

	result.Santas = make([]*Santa, 0)
	result.currentSantaIndex = 0

	return result
}

func (dispatch *ElfDispatch) Close() {
	dispatch.file.Close()
}

func (dispatch *ElfDispatch) AddSanta(santa *Santa) {
	log.Printf("Adding santa '%s'\n", santa.Name)
	dispatch.Santas = append(dispatch.Santas, santa)
}

func (dispatch *ElfDispatch) AddSantas(santas []*Santa) {
	for _, santa := range santas {
		dispatch.AddSanta(santa)
	}
}

/*
Returns the next direction to go, and true if we are done
*/
func (dispatch *ElfDispatch) GetNextDirection() (string, bool) {
	hasMoreDirections := dispatch.reader.Scan()

	if hasMoreDirections {
		return dispatch.reader.Text(), false
	}

	return "", true
}

func (dispatch *ElfDispatch) DispatchNextSanta(direction string) {
	nextSanta := dispatch.Santas[dispatch.currentSantaIndex]
	log.Printf("Dispatching %s '%s'", nextSanta.Name, direction)

	newPosition := nextSanta.Move(direction)
	dispatch.updateMap(newPosition)

	dispatch.changeSanta()
}

func (dispatch *ElfDispatch) changeSanta() {
	dispatch.currentSantaIndex++

	if dispatch.currentSantaIndex > len(dispatch.Santas)-1 {
		dispatch.currentSantaIndex = 0
	}
}

func (dispatch *ElfDispatch) updateMap(location Point) {
	dispatch.Map.Visit(location.X, location.Y)
}

func (dispatch *ElfDispatch) CountHousesVisited() int {
	return len(dispatch.Map)
}

func (dispatch *ElfDispatch) CountUniqueHouseVisits() int {
	result := 0

	for _, value := range dispatch.Map {
		if value == 1 {
			result++
		}
	}

	return result
}
