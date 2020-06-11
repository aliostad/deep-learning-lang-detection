package matasano

import (
	"strings"
	"unicode"
)

func stringScore(s string) float32 {
	return scoreChars(s) + scoreDigraphs(s)
}

func scoreChars(s string) (score float32) {
	for _, c := range s {
		switch unicode.ToUpper(c) {
		case 'E':
			score += 12.02
		case 'T':
			score += 9.10
		case 'A':
			score += 8.12
		case 'O':
			score += 7.68
		case 'I':
			score += 7.31
		case 'N':
			score += 6.95
		case 'S':
			score += 6.28
		case 'R':
			score += 6.02
		case 'H':
			score += 5.92
		case 'D':
			score += 4.32
		case 'L':
			score += 3.98
		case 'U':
			score += 2.88
		case 'C':
			score += 2.71
		case 'M':
			score += 2.61
		case 'F':
			score += 2.30
		case 'Y':
			score += 2.11
		case 'W':
			score += 2.09
		case 'G':
			score += 2.03
		case 'P':
			score += 1.82
		case 'B':
			score += 1.49
		case 'V':
			score += 1.11
		case 'K':
			score += 0.69
		case 'X':
			score += 0.17
		case 'Q':
			score += 0.11
		case 'J':
			score += 0.10
		case 'Z':
			score += 0.07
		case ' ':
			score += 10.0
		case '-', '\'', '\n', '/', ',', '.', '?', '!':
			score += 0.1
		}
	}
	return
}

func scoreDigraphs(s string) (score float32) {
	for i := 0; i < len(s)-1; i++ {
		switch strings.ToUpper(s[i : i+2]) {
		case "TH":
			score += 3.88 * 4
		case "HE":
			score += 3.68 * 4
		case "IN":
			score += 2.28 * 4
		case "ER":
			score += 2.17 * 4
		case "AN":
			score += 2.14 * 4
		case "RE":
			score += 1.74 * 4
		case "ND":
			score += 1.57 * 4
		case "ON":
			score += 1.41 * 4
		case "EN":
			score += 1.38 * 4
		case "AT":
			score += 1.33 * 4
		case "OU":
			score += 1.28 * 4
		case "ED":
			score += 1.27 * 4
		case "HA":
			score += 1.27 * 4
		case "TO":
			score += 1.16 * 4
		case "OR":
			score += 1.15 * 4
		case "IT":
			score += 1.13 * 4
		case "IS":
			score += 1.10 * 4
		case "HI":
			score += 1.09 * 4
		case "ES":
			score += 1.09 * 4
		case "NG":
			score += 1.05 * 4
		}
	}
	return
}
