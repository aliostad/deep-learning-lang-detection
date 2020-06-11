package main

import (
	"bufio"
	"log"
	"os"
	"strings"
)

func getNextNumber(number string, instruction string) string {
	switch number {
	case "1":
		switch instruction {
		case "U":
			return "1"
		case "L":
			return "1"
		case "R":
			return "1"
		case "D":
			return "3"
		}
	case "2":
		switch instruction {
		case "U":
			return "2"
		case "L":
			return "2"
		case "R":
			return "3"
		case "D":
			return "6"
		}
	case "3":
		switch instruction {
		case "U":
			return "1"
		case "L":
			return "2"
		case "R":
			return "4"
		case "D":
			return "7"
		}
	case "4":
		switch instruction {
		case "U":
			return "4"
		case "L":
			return "3"
		case "R":
			return "4"
		case "D":
			return "8"
		}
	case "5":
		switch instruction {
		case "U":
			return "5"
		case "L":
			return "5"
		case "R":
			return "6"
		case "D":
			return "5"
		}
	case "6":
		switch instruction {
		case "U":
			return "2"
		case "L":
			return "5"
		case "R":
			return "7"
		case "D":
			return "A"
		}
	case "7":
		switch instruction {
		case "U":
			return "3"
		case "L":
			return "6"
		case "R":
			return "8"
		case "D":
			return "B"
		}
	case "8":
		switch instruction {
		case "U":
			return "4"
		case "L":
			return "7"
		case "R":
			return "9"
		case "D":
			return "C"
		}
	case "9":
		switch instruction {
		case "U":
			return "9"
		case "L":
			return "8"
		case "R":
			return "9"
		case "D":
			return "9"
		}
	case "A":
		switch instruction {
		case "U":
			return "6"
		case "L":
			return "A"
		case "R":
			return "B"
		case "D":
			return "A"
		}
	case "B":
		switch instruction {
		case "U":
			return "7"
		case "L":
			return "A"
		case "R":
			return "C"
		case "D":
			return "D"
		}
	case "C":
		switch instruction {
		case "U":
			return "8"
		case "L":
			return "B"
		case "R":
			return "C"
		case "D":
			return "C"
		}
	case "D":
		switch instruction {
		case "U":
			return "B"
		case "L":
			return "D"
		case "R":
			return "D"
		case "D":
			return "D"
		}
	}

	return ""
}

func main() {

	if file, err := os.Open("input.2.1.txt"); err == nil {

		// make sure it gets closed
		defer file.Close()

		scanner := bufio.NewScanner(file)
		key := "5"

		for scanner.Scan() {
			instructions := strings.Split(scanner.Text(), "")

			for _, instruction := range instructions {
				key = getNextNumber(key, instruction)
			}
			log.Println(key)
		}
	}
}
