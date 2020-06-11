package main

import "fmt"

func lengthNumber(number int) int {
	switch number {
	case 0:
		return 0
	case 1:
		return 3 //one
	case 2:
		return 3 //two
	case 3:
		return 5 //three
	case 4:
		return 4 //four
	case 5:
		return 4 //five
	case 6:
		return 3 //six
	case 7:
		return 5 //seven
	case 8:
		return 5 //eight
	case 9:
		return 4 //nine
	case 10:
		return 3 //ten
	case 11:
		return 6 //eleven
	case 12:
		return 6 //twelve
	case 13:
		return 8 //thirteen
	case 14:
		return 8 //fourteen
	case 15:
		return 7 //fifteen
	case 16:
		return 7 //sixteen
	case 17:
		return 9 //seventeen
	case 18:
		return 8 //eighteen
	case 19:
		return 8 //nineteen
	case 20:
		return 6 //twenty
	case 30:
		return 6 //thirty
	case 40:
		return 5 //forty
	case 50:
		return 5 //fifty
	case 60:
		return 5 //sixty
	case 70:
		return 7 //seventy
	case 80:
		return 6 //eighty
	case 90:
		return 6 //ninety
	}

	if number < 100 {
		return lengthNumber(number-(number%10)) + lengthNumber(number%10)
	}
	if number%100 == 0 {
		return lengthNumber(number/100) + 7
	}
	return lengthNumber(number/100) + 10 + lengthNumber(number%100)
}

func main() {
	sum := 0
	for i := 0; i < 1000; i++ {
		sum += lengthNumber(i)
	}

	fmt.Println(sum + len("onethousand"))
}
