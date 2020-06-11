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
			return "2"
		case "D":
			return "4"
		}
	case "2":
		switch instruction {
		case "U":
			return "2"
		case "L":
			return "1"
		case "R":
			return "3"
		case "D":
			return "5"
		}
	case "3":
		switch instruction {
		case "U":
			return "3"
		case "L":
			return "2"
		case "R":
			return "3"
		case "D":
			return "6"
		}
	case "4":
		switch instruction {
		case "U":
			return "1"
		case "L":
			return "4"
		case "R":
			return "5"
		case "D":
			return "7"
		}
	case "5":
		switch instruction {
		case "U":
			return "2"
		case "L":
			return "4"
		case "R":
			return "6"
		case "D":
			return "8"
		}
	case "6":
		switch instruction {
		case "U":
			return "3"
		case "L":
			return "5"
		case "R":
			return "6"
		case "D":
			return "9"
		}
	case "7":
		switch instruction {
		case "U":
			return "4"
		case "L":
			return "7"
		case "R":
			return "8"
		case "D":
			return "7"
		}
	case "8":
		switch instruction {
		case "U":
			return "5"
		case "L":
			return "7"
		case "R":
			return "9"
		case "D":
			return "8"
		}
	case "9":
		switch instruction {
		case "U":
			return "6"
		case "L":
			return "8"
		case "R":
			return "9"
		case "D":
			return "9"
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
