package main

import (
	"fmt"
	"os"
	"io/ioutil"
)

func main() {
	filename := "PROT.txt"
	if len(os.Args) > 1 {
		filename = os.Args[1]
	}

	file, err := ioutil.ReadFile(filename)
	if err != nil { panic(err) }

	prot := make([]byte, 0)
	for i := 0; i <= len(file); i+=3 {
		val := string(file[i:i+3])
		fmt.Println(val)
		prot = append(prot, RnaCodon(val))
	}
	fmt.Println(string(prot))
}

func RnaCodon (rna string) byte {
	switch rna {
		case "UUU": return 'F'
		case "CUU": return 'L'
		case "AUU": return 'I'
		case "GUU": return 'V'
		case "UUC": return 'F'
		case "CUC": return 'L'
		case "AUC": return 'I'
		case "GUC": return 'V'
		case "UUA": return 'L'
		case "CUA": return 'L'
		case "AUA": return 'I'
		case "GUA": return 'V'
		case "UUG": return 'L'
		case "CUG": return 'L'
		case "AUG": return 'M'
		case "GUG": return 'V'
		case "UCU": return 'S'
		case "CCU": return 'P'
		case "ACU": return 'T'
		case "GCU": return 'A'
		case "UCC": return 'S'
		case "CCC": return 'P'
		case "ACC": return 'T'
		case "GCC": return 'A'
		case "UCA": return 'S'
		case "CCA": return 'P'
		case "ACA": return 'T'
		case "GCA": return 'A'
		case "UCG": return 'S'
		case "CCG": return 'P'
		case "ACG": return 'T'
		case "GCG": return 'A'
		case "UAU": return 'Y'
		case "CAU": return 'H'
		case "AAU": return 'N'
		case "GAU": return 'D'
		case "UAC": return 'Y'
		case "CAC": return 'H'
		case "AAC": return 'N'
		case "GAC": return 'D'
		case "CAA": return 'Q'
		case "AAA": return 'K'
		case "GAA": return 'E'
		case "CAG": return 'Q'
		case "AAG": return 'K'
		case "GAG": return 'E'
		case "UGU": return 'C'
		case "CGU": return 'R'
		case "AGU": return 'S'
		case "GGU": return 'G'
		case "UGC": return 'C'
		case "CGC": return 'R'
		case "AGC": return 'S'
		case "GGC": return 'G'
		case "CGA": return 'R'
		case "AGA": return 'R'
		case "GGA": return 'G'
		case "UGG": return 'W'
		case "CGG": return 'R'
		case "AGG": return 'R'
		case "GGG": return 'G'
		case "UAA": return '\n' // Stop bits
		case "UAG": return '\n'
		case "UGA": return '\n'
	}
	return '\n'
}

