package aqm0802

import (
	"errors"
)

func stringToLcdcode(s string) (code []byte, err error) {
	//initialize with white space code
	code = make([]byte, 8, 8)
	for i := 0; i < len(code); i++ {
		code[i] = 0xa0
	}
	runeArray := []rune(s)
	if len(runeArray) > 8 {
		err = errors.New("Exceeded number of charactor per one line")
		return
	}
	for i, r := range runeArray {
		code[i], err = charToLcdcode(r)
	}
	return
}

func charToLcdcode(r rune) (code byte, err error) {
	switch string(r) {
	case "A":
		code = 0x41
	case "B":
		code = 0x42
	case "C":
		code = 0x43
	case "D":
		code = 0x44
	case "E":
		code = 0x45
	case "F":
		code = 0x46
	case "G":
		code = 0x47
	case "H":
		code = 0x48
	case "I":
		code = 0x49
	case "J":
		code = 0x4a
	case "K":
		code = 0x4b
	case "L":
		code = 0x4c
	case "M":
		code = 0x4d
	case "N":
		code = 0x4e
	case "O":
		code = 0x4f
	case "P":
		code = 0x50
	case "Q":
		code = 0x51
	case "R":
		code = 0x52
	case "S":
		code = 0x53
	case "T":
		code = 0x54
	case "U":
		code = 0x55
	case "V":
		code = 0x56
	case "W":
		code = 0x57
	case "X":
		code = 0x58
	case "Y":
		code = 0x59
	case "Z":
		code = 0x5a

	case "a":
		code = 0x61
	case "b":
		code = 0x62
	case "c":
		code = 0x63
	case "d":
		code = 0x64
	case "e":
		code = 0x65
	case "f":
		code = 0x66
	case "g":
		code = 0x67
	case "h":
		code = 0x68
	case "i":
		code = 0x69
	case "j":
		code = 0x6a
	case "k":
		code = 0x6b
	case "l":
		code = 0x6c
	case "m":
		code = 0x6d
	case "n":
		code = 0x6e
	case "o":
		code = 0x6f
	case "p":
		code = 0x70
	case "q":
		code = 0x71
	case "r":
		code = 0x72
	case "s":
		code = 0x73
	case "t":
		code = 0x74
	case "u":
		code = 0x75
	case "v":
		code = 0x76
	case "w":
		code = 0x77
	case "x":
		code = 0x78
	case "y":
		code = 0x79
	case "z":
		code = 0x7a
	default:
		err = errors.New("Unsupported string: " + string(r))
	}
	return
}
