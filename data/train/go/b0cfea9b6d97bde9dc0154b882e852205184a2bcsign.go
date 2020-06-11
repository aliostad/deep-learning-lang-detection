package birthsign

func GetLabel(code int, gender string) string {
	switch code {
	case 1:
		return "Arian" + genderAddition(gender)
	case 2:
		return "Taurin" + genderAddition(gender)
	case 3:
		return "Geminian" + genderAddition(gender)
	case 4:
		return "Cancerian" + genderAddition(gender)
	case 5:
		return "Leonin" + genderAddition(gender)
	case 6:
		return "Virginian" + genderAddition(gender)
	case 7:
		return "Librian" + genderAddition(gender)
	case 8:
		return "Escorpian" + genderAddition(gender)
	case 9:
		return "Sagitarian" + genderAddition(gender)
	case 10:
		return "Capricornian" + genderAddition(gender)
	case 11:
		return "Aquarian" + genderAddition(gender)
	case 12:
		return "Piscian" + genderAddition(gender)
	}

	return ``
}

func GetNameLowerCase(code int) string {
	switch code {
	case 1:
		return "aries"
	case 2:
		return "touro"
	case 3:
		return "gemeos"
	case 4:
		return "cancer"
	case 5:
		return "leao"
	case 6:
		return "virgem"
	case 7:
		return "libra"
	case 8:
		return "escorpiao"
	case 9:
		return "sagitario"
	case 10:
		return "capricornio"
	case 11:
		return "aquario"
	case 12:
		return "peixes"
	}

	return ``
}

func genderAddition(gender string) string {
	genderAddition := `o`

	if gender == `F` {
		genderAddition = `a`
	}

	return genderAddition
}