package main

func toEnglish(n int) string {
	word := ""
	switch n {
	case 1:
		word = "one"
	case 2:
		word = "two"
	case 3:
		word = "three"
	case 4:
		word = "four"
	case 5:
		word = "five"
	case 6:
		word = "six"
	case 7:
		word = "seven"
	case 8:
		word = "eight"
	case 9:
		word = "nine"
	case 10:
		word = "ten"
	case 11:
		word = "eleven"
	case 12:
		word = "twelve"
	case 13:
		word = "thirteen"
	case 14:
		word = "fourteen"
	case 15:
		word = "fifteen"
	case 16:
		word = "sixteen"
	case 17:
		word = "seventeen"
	case 18:
		word = "eighteen"
	case 19:
		word = "nineteen"
	case 20:
		word = "twenty"
	case 30:
		word = "thirty"
	case 40:
		word = "forty"
	case 50:
		word = "fifty"
	case 60:
		word = "sixty"
	case 70:
		word = "seventy"
	case 80:
		word = "eighty"
	case 90:
		word = "ninety"
	case 1000:
		word = "onethousand"
	}
	if len(word) == 0 {
		switch  {
		case n < 100:
			tens := (n / 10) * 10
			ones := n % 10
			word = toEnglish(tens) + toEnglish(ones)
		case n < 1000:
			hundreds := (n / 100)
			tens := n % 100
			word = toEnglish(hundreds) + "hundred"
			if (tens != 0) {
				word = word + "and" + toEnglish(tens)
			}
		}
	}
	return word
}

func problem17() int {
	sum := 0
	for i:=1; i<=1000; i++ {
		sum += len(toEnglish(i))
	}
	return sum
}
