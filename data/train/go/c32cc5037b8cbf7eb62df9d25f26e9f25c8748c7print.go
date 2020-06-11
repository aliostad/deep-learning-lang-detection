package main



func drawString(x,y float64, s string) {

	squareLength := float64(1.5)

	ra := []rune(s)

	xx := x
	for _,r := range ra {

		drawRune(xx, y ,squareLength, r)

		xx += 6 * squareLength
	}
	

}

func drawRune(x,y, length float64, r rune) {


	var mapp *[48]rune
//@TODO: Should do this with a look up table instead.
	switch r {

		case ' ':
			mapp = &fontSpace
		case '.':
			mapp = &fontPeriod
		case ',':
			mapp = &fontComma
		case ':':
			mapp = &fontColon
		case ';':
			mapp = &fontSemicolon
		case '-':
			mapp = &fontHyphen


		case 'A', 'a':
			mapp = &fontA
		case 'B', 'b':
			mapp = &fontB
		case 'C', 'c':
			mapp = &fontC
		case 'D', 'd':
			mapp = &fontD
		case 'E', 'e':
			mapp = &fontE
		case 'F', 'f':
			mapp = &fontF
		case 'G', 'g':
			mapp = &fontG
		case 'H', 'h':
			mapp = &fontH
		case 'I', 'i':
			mapp = &fontI
		case 'J', 'j':
			mapp = &fontJ
		case 'K', 'k':
			mapp = &fontK
		case 'L', 'l':
			mapp = &fontL
		case 'M', 'm':
			mapp = &fontM
		case 'N', 'n':
			mapp = &fontN
		case 'O', 'o':
			mapp = &fontO
		case 'P', 'p':
			mapp = &fontP
		case 'Q', 'q':
			mapp = &fontQ
		case 'R', 'r':
			mapp = &fontR
		case 'S', 's':
			mapp = &fontS
		case 'T', 't':
			mapp = &fontT
		case 'U', 'u':
			mapp = &fontU
		case 'V', 'v':
			mapp = &fontV
		case 'W', 'w':
			mapp = &fontW
		case 'X', 'x':
			mapp = &fontX
		case 'Y', 'y':
			mapp = &fontY
		case 'Z', 'z':
			mapp = &fontZ


		case '0':
			mapp = &font0
		case '1':
			mapp = &font1
		case '2':
			mapp = &font2
		case '3':
			mapp = &font3
		case '4':
			mapp = &font4
		case '5':
			mapp = &font5
		case '6':
			mapp = &font6
		case '7':
			mapp = &font7
		case '8':
			mapp = &font8
		case '9':
			mapp = &font9


		case 'θ', 'Θ', 'ϑ':
			mapp = &fontθ


		default:
			mapp = &fontSpace
	}

	draw6x8(x,y, length, mapp)

}
