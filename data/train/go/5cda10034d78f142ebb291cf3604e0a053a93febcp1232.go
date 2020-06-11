package cp1232

import (
	"bytes"
)

func FromUtf8(str string) string {
	var output bytes.Buffer

	for _, b := range str {
		switch b {
		case 'À':
			output.WriteString("\xC0")
		case 'Á':
			output.WriteString("\xC1")
		case 'Â':
			output.WriteString("\xC2")
		case 'Ã':
			output.WriteString("\xC3")
		case 'Ä':
			output.WriteString("\xC4")
		case 'Ç':
			output.WriteString("\xC7")
		case 'È':
			output.WriteString("\xC8")
		case 'É':
			output.WriteString("\xC9")
		case 'Ê':
			output.WriteString("\xCA")
		case 'Ë':
			output.WriteString("\xCB")
		case 'Ì':
			output.WriteString("\xCC")
		case 'Í':
			output.WriteString("\xCD")
		case 'Î':
			output.WriteString("\xCE")
		case 'Ï':
			output.WriteString("\xCF")
		case 'Ñ':
			output.WriteString("\xD1")
		case 'Ò':
			output.WriteString("\xD2")
		case 'Ó':
			output.WriteString("\xD3")
		case 'Ô':
			output.WriteString("\xD4")
		case 'Õ':
			output.WriteString("\xD5")
		case 'Ö':
			output.WriteString("\xD6")
		case 'Ù':
			output.WriteString("\xD9")
		case 'Ú':
			output.WriteString("\xDA")
		case 'Û':
			output.WriteString("\xDB")
		case 'Ü':
			output.WriteString("\xDC")
		case 'Ý':
			output.WriteString("\xDD")
		case 'à':
			output.WriteString("\xE0")
		case 'á':
			output.WriteString("\xE1")
		case 'â':
			output.WriteString("\xE2")
		case 'ã':
			output.WriteString("\xE3")
		case 'ä':
			output.WriteString("\xE4")
		case 'ç':
			output.WriteString("\xE7")
		case 'è':
			output.WriteString("\xE8")
		case 'é':
			output.WriteString("\xE9")
		case 'ê':
			output.WriteString("\xEA")
		case 'ë':
			output.WriteString("\xEB")
		case 'ì':
			output.WriteString("\xEC")
		case 'í':
			output.WriteString("\xED")
		case 'î':
			output.WriteString("\xEE")
		case 'ï':
			output.WriteString("\xEF")
		case 'ñ':
			output.WriteString("\xF1")
		case 'ò':
			output.WriteString("\xF2")
		case 'ó':
			output.WriteString("\xF3")
		case 'ô':
			output.WriteString("\xF4")
		case 'õ':
			output.WriteString("\xF5")
		case 'ö':
			output.WriteString("\xF6")
		case 'ù':
			output.WriteString("\xF9")
		case 'ú':
			output.WriteString("\xFA")
		case 'û':
			output.WriteString("\xFB")
		case 'ü':
			output.WriteString("\xFC")
		case 'ý':
			output.WriteString("\xFD")
		case 'ÿ':
			output.WriteString("\xFF")
		case '°':
			output.WriteString("\xB0")
		case 'º':
			output.WriteString("\xBA")
		case 'ª':
			output.WriteString("\xAA")
		case '–':
			output.WriteString("\x96")
		case '—':
			output.WriteString("\x97")
		case '“':
			output.WriteString("\x93")
		case '”':
			output.WriteString("\x94")
		case '„':
			output.WriteString("\x84")

		default:
			output.WriteRune(b)
		}

	}

	return output.String()
}
