package ascii

import (
	"bytes"
	"unicode/utf8"
)

// Fold the given string into ascii, with the exemption of the Norwegian characters 'æ', 'ø', 'å'
// The implementation is a literal translation of Lucene's AsciiFoldingFilter:
// https://github.com/apache/lucene-solr/blob/master/lucene/analysis/common/src/java/org/apache/lucene/analysis/miscellaneous/ASCIIFoldingFilter.java
func Fold(s string) string {
	var b bytes.Buffer
	for _, r := range s {
		if r < utf8.RuneSelf {
			b.WriteRune(r)
		} else {
			b.WriteString(fold(r))
		}
	}
	return b.String()
}

func fold(r rune) string {
	switch r {
	case 'À', 'Á', 'Â', 'Ã', 'Ä', 'Ā', 'Ă', 'Ą', 'Ə', 'Ǎ', 'Ǟ', 'Ǡ', 'Ǻ', 'Ȁ', 'Ȃ', 'Ȧ', 'Ⱥ', 'ᴀ', 'Ḁ', 'Ạ', 'Ả', 'Ấ', 'Ầ', 'Ẩ', 'Ẫ', 'Ậ', 'Ắ', 'Ằ', 'Ẳ', 'Ẵ', 'Ặ', 'Ⓐ', 'Ａ':
		// Removed: 'Å'
		return "A"
	case 'à', 'á', 'â', 'ã', 'ä', 'ā', 'ă', 'ą', 'ǎ', 'ǟ', 'ǡ', 'ǻ', 'ȁ', 'ȃ', 'ȧ', 'ɐ', 'ə', 'ɚ', 'ᶏ', 'ḁ', 'ᶕ', 'ẚ', 'ạ', 'ả', 'ấ', 'ầ', 'ẩ', 'ẫ', 'ậ', 'ắ', 'ằ', 'ẳ', 'ẵ', 'ặ', 'ₐ', 'ₔ', 'ⓐ', 'ⱥ', 'Ɐ', 'ａ':
		// Removed: 'å'
		return "a"
	case 'Ꜳ':
		return "AA"
	case 'Æ', 'Ǣ', 'Ǽ', 'ᴁ':
		return "Æ" // Was: "AE"
	case 'Ꜵ':
		return "AO"
	case 'Ꜷ':
		return "AU"
	case 'Ꜹ', 'Ꜻ':
		return "AV"
	case 'Ꜽ':
		return "AY"
	case '⒜':
		return "(a)"
	case 'ꜳ':
		return "aa"
	case 'æ', 'ǣ', 'ǽ', 'ᴂ':
		return "æ" // Was: "ae"
	case 'ꜵ':
		return "ao"
	case 'ꜷ':
		return "au"
	case 'ꜹ', 'ꜻ':
		return "av"
	case 'ꜽ':
		return "ay"
	case 'Ɓ', 'Ƃ', 'Ƀ', 'ʙ', 'ᴃ', 'Ḃ', 'Ḅ', 'Ḇ', 'Ⓑ', 'Ｂ':
		return "B"
	case 'ƀ', 'ƃ', 'ɓ', 'ᵬ', 'ᶀ', 'ḃ', 'ḅ', 'ḇ', 'ⓑ', 'ｂ':
		return "b"
	case '⒝':
		return "(b)"
	case 'Ç', 'Ć', 'Ĉ', 'Ċ', 'Č', 'Ƈ', 'Ȼ', 'ʗ', 'ᴄ', 'Ḉ', 'Ⓒ', 'Ｃ':
		return "C"
	case 'ç', 'ć', 'ĉ', 'ċ', 'č', 'ƈ', 'ȼ', 'ɕ', 'ḉ', 'ↄ', 'ⓒ', 'Ꜿ', 'ꜿ', 'ｃ':
		return "c"
	case '⒞':
		return "(c)"
	case 'Ð', 'Ď', 'Đ', 'Ɖ', 'Ɗ', 'Ƌ', 'ᴅ', 'ᴆ', 'Ḋ', 'Ḍ', 'Ḏ', 'Ḑ', 'Ḓ', 'Ⓓ', 'Ꝺ', 'Ｄ':
		return "D"
	case 'ð', 'ď', 'đ', 'ƌ', 'ȡ', 'ɖ', 'ɗ', 'ᵭ', 'ᶁ', 'ᶑ', 'ḋ', 'ḍ', 'ḏ', 'ḑ', 'ḓ', 'ⓓ', 'ꝺ', 'ｄ':
		return "d"
	case 'Ǆ', 'Ǳ':
		return "DZ"
	case 'ǅ', 'ǲ':
		return "Dz"
	case '⒟':
		return "(d)"
	case 'ȸ':
		return "db"
	case 'ǆ', 'ǳ', 'ʣ', 'ʥ':
		return "dz"
	case 'È', 'É', 'Ê', 'Ë', 'Ē', 'Ĕ', 'Ė', 'Ę', 'Ě', 'Ǝ', 'Ɛ', 'Ȅ', 'Ȇ', 'Ȩ', 'Ɇ', 'ᴇ', 'Ḕ', 'Ḗ', 'Ḙ', 'Ḛ', 'Ḝ', 'Ẹ', 'Ẻ', 'Ẽ', 'Ế', 'Ề', 'Ể', 'Ễ', 'Ệ', 'Ⓔ', 'ⱻ', 'Ｅ':
		return "E"
	case 'è', 'é', 'ê', 'ë', 'ē', 'ĕ', 'ė', 'ę', 'ě', 'ǝ', 'ȅ', 'ȇ', 'ȩ', 'ɇ', 'ɘ', 'ɛ', 'ɜ', 'ɝ', 'ɞ', 'ʚ', 'ᴈ', 'ᶒ', 'ᶓ', 'ᶔ', 'ḕ', 'ḗ', 'ḙ', 'ḛ', 'ḝ', 'ẹ', 'ẻ', 'ẽ', 'ế', 'ề', 'ể', 'ễ', 'ệ', 'ₑ', 'ⓔ', 'ⱸ', 'ｅ':
		return "e"
	case '⒠':
		return "(e)"
	case 'Ƒ', 'Ḟ', 'Ⓕ', 'ꜰ', 'Ꝼ', 'ꟻ', 'Ｆ':
		return "F"
	case 'ƒ', 'ᵮ', 'ᶂ', 'ḟ', 'ẛ', 'ⓕ', 'ꝼ', 'ｆ':
		return "f"
	case '⒡':
		return "(f)"
	case 'ﬀ':
		return "ff"
	case 'ﬃ':
		return "ffi"
	case 'ﬄ':
		return "ffl"
	case 'ﬁ':
		return "fi"
	case 'ﬂ':
		return "fl"
	case 'Ĝ', 'Ğ', 'Ġ', 'Ģ', 'Ɠ', 'Ǥ', 'ǥ', 'Ǧ', 'ǧ', 'Ǵ', 'ɢ', 'ʛ', 'Ḡ', 'Ⓖ', 'Ᵹ', 'Ꝿ', 'Ｇ':
		return "G"
	case 'ĝ', 'ğ', 'ġ', 'ģ', 'ǵ', 'ɠ', 'ɡ', 'ᵷ', 'ᵹ', 'ᶃ', 'ḡ', 'ⓖ', 'ꝿ', 'ｇ':
		return "g"
	case '⒢':
		return "(g)"
	case 'Ĥ', 'Ħ', 'Ȟ', 'ʜ', 'Ḣ', 'Ḥ', 'Ḧ', 'Ḩ', 'Ḫ', 'Ⓗ', 'Ⱨ', 'Ⱶ', 'Ｈ':
		return "H"
	case 'ĥ', 'ħ', 'ȟ', 'ɥ', 'ɦ', 'ʮ', 'ʯ', 'ḣ', 'ḥ', 'ḧ', 'ḩ', 'ḫ', 'ẖ', 'ⓗ', 'ⱨ', 'ⱶ', 'ｈ':
		return "h"
	case 'Ƕ':
		return "HV"
	case '⒣':
		return "(h)"
	case 'ƕ':
		return "hv"
	case 'Ì', 'Í', 'Î', 'Ï', 'Ĩ', 'Ī', 'Ĭ', 'Į', 'İ', 'Ɩ', 'Ɨ', 'Ǐ', 'Ȉ', 'Ȋ', 'ɪ', 'ᵻ', 'Ḭ', 'Ḯ', 'Ỉ', 'Ị', 'Ⓘ', 'ꟾ', 'Ｉ':
		return "I"
	case 'ì', 'í', 'î', 'ï', 'ĩ', 'ī', 'ĭ', 'į', 'ı', 'ǐ', 'ȉ', 'ȋ', 'ɨ', 'ᴉ', 'ᵢ', 'ᵼ', 'ᶖ', 'ḭ', 'ḯ', 'ỉ', 'ị', 'ⁱ', 'ⓘ', 'ｉ':
		return "i"
	case 'Ĳ':
		return "IJ"
	case '⒤':
		return "(i)"
	case 'ĳ':
		return "ij"
	case 'Ĵ', 'Ɉ', 'ᴊ', 'Ⓙ', 'Ｊ':
		return "J"
	case 'ĵ', 'ǰ', 'ȷ', 'ɉ', 'ɟ', 'ʄ', 'ʝ', 'ⓙ', 'ⱼ', 'ｊ':
		return "j"
	case '⒥':
		return "(j)"
	case 'Ķ', 'Ƙ', 'Ǩ', 'ᴋ', 'Ḱ', 'Ḳ', 'Ḵ', 'Ⓚ', 'Ⱪ', 'Ꝁ', 'Ꝃ', 'Ꝅ', 'Ｋ':
		return "K"
	case 'ķ', 'ƙ', 'ǩ', 'ʞ', 'ᶄ', 'ḱ', 'ḳ', 'ḵ', 'ⓚ', 'ⱪ', 'ꝁ', 'ꝃ', 'ꝅ', 'ｋ':
		return "k"
	case '⒦':
		return "(k)"
	case 'Ĺ', 'Ļ', 'Ľ', 'Ŀ', 'Ł', 'Ƚ', 'ʟ', 'ᴌ', 'Ḷ', 'Ḹ', 'Ḻ', 'Ḽ', 'Ⓛ', 'Ⱡ', 'Ɫ', 'Ꝇ', 'Ꝉ', 'Ꞁ', 'Ｌ':
		return "L"
	case 'ĺ', 'ļ', 'ľ', 'ŀ', 'ł', 'ƚ', 'ȴ', 'ɫ', 'ɬ', 'ɭ', 'ᶅ', 'ḷ', 'ḹ', 'ḻ', 'ḽ', 'ⓛ', 'ⱡ', 'ꝇ', 'ꝉ', 'ꞁ', 'ｌ':
		return "l"
	case 'Ǉ':
		return "LJ"
	case 'Ỻ':
		return "LL"
	case 'ǈ':
		return "Lj"
	case '⒧':
		return "(l)"
	case 'ǉ':
		return "lj"
	case 'ỻ':
		return "ll"
	case 'ʪ':
		return "ls"
	case 'ʫ':
		return "lz"
	case 'Ɯ', 'ᴍ', 'Ḿ', 'Ṁ', 'Ṃ', 'Ⓜ', 'Ɱ', 'ꟽ', 'ꟿ', 'Ｍ':
		return "M"
	case 'ɯ', 'ɰ', 'ɱ', 'ᵯ', 'ᶆ', 'ḿ', 'ṁ', 'ṃ', 'ⓜ', 'ｍ':
		return "m"
	case '⒨':
		return "(m)"
	case 'Ñ', 'Ń', 'Ņ', 'Ň', 'Ŋ', 'Ɲ', 'Ǹ', 'Ƞ', 'ɴ', 'ᴎ', 'Ṅ', 'Ṇ', 'Ṉ', 'Ṋ', 'Ⓝ', 'Ｎ':
		return "N"
	case 'ñ', 'ń', 'ņ', 'ň', 'ŉ', 'ŋ', 'ƞ', 'ǹ', 'ȵ', 'ɲ', 'ɳ', 'ᵰ', 'ᶇ', 'ṅ', 'ṇ', 'ṉ', 'ṋ', 'ⁿ', 'ⓝ', 'ｎ':
		return "n"
	case 'Ǌ':
		return "NJ"
	case 'ǋ':
		return "Nj"
	case '⒩':
		return "(n)"
	case 'ǌ':
		return "nj"
	case 'Ò', 'Ó', 'Ô', 'Õ', 'Ö', 'Ō', 'Ŏ', 'Ő', 'Ɔ', 'Ɵ', 'Ơ', 'Ǒ', 'Ǫ', 'Ǭ', 'Ǿ', 'Ȍ', 'Ȏ', 'Ȫ', 'Ȭ', 'Ȯ', 'Ȱ', 'ᴏ', 'ᴐ', 'Ṍ', 'Ṏ', 'Ṑ', 'Ṓ', 'Ọ', 'Ỏ', 'Ố', 'Ồ', 'Ổ', 'Ỗ', 'Ộ', 'Ớ', 'Ờ', 'Ở', 'Ỡ', 'Ợ', 'Ⓞ', 'Ꝋ', 'Ꝍ', 'Ｏ':
		// Removed: 'Ø'
		return "O"
	case 'ò', 'ó', 'ô', 'õ', 'ö', 'ō', 'ŏ', 'ő', 'ơ', 'ǒ', 'ǫ', 'ǭ', 'ǿ', 'ȍ', 'ȏ', 'ȫ', 'ȭ', 'ȯ', 'ȱ', 'ɔ', 'ɵ', 'ᴖ', 'ᴗ', 'ᶗ', 'ṍ', 'ṏ', 'ṑ', 'ṓ', 'ọ', 'ỏ', 'ố', 'ồ', 'ổ', 'ỗ', 'ộ', 'ớ', 'ờ', 'ở', 'ỡ', 'ợ', 'ₒ', 'ⓞ', 'ⱺ', 'ꝋ', 'ꝍ', 'ｏ':
		// Removed: 'ø'
		return "o"
	case 'Œ', 'ɶ':
		return "OE"
	case 'Ꝏ':
		return "OO"
	case 'Ȣ', 'ᴕ':
		return "OU"
	case '⒪':
		return "(o)"
	case 'œ', 'ᴔ':
		return "oe"
	case 'ꝏ':
		return "oo"
	case 'ȣ':
		return "ou"
	case 'Ƥ', 'ᴘ', 'Ṕ', 'Ṗ', 'Ⓟ', 'Ᵽ', 'Ꝑ', 'Ꝓ', 'Ꝕ', 'Ｐ':
		return "P"
	case 'ƥ', 'ᵱ', 'ᵽ', 'ᶈ', 'ṕ', 'ṗ', 'ⓟ', 'ꝑ', 'ꝓ', 'ꝕ', 'ꟼ', 'ｐ':
		return "p"
	case '⒫':
		return "(p)"
	case 'Ɋ', 'Ⓠ', 'Ꝗ', 'Ꝙ', 'Ｑ':
		return "Q"
	case 'ĸ', 'ɋ', 'ʠ', 'ⓠ', 'ꝗ', 'ꝙ', 'ｑ':
		return "q"
	case '⒬':
		return "(q)"
	case 'ȹ':
		return "qp"
	case 'Ŕ', 'Ŗ', 'Ř', 'Ȑ', 'Ȓ', 'Ɍ', 'ʀ', 'ʁ', 'ᴙ', 'ᴚ', 'Ṙ', 'Ṛ', 'Ṝ', 'Ṟ', 'Ⓡ', 'Ɽ', 'Ꝛ', 'Ꞃ', 'Ｒ':
		return "R"
	case 'ŕ', 'ŗ', 'ř', 'ȑ', 'ȓ', 'ɍ', 'ɼ', 'ɽ', 'ɾ', 'ɿ', 'ᵣ', 'ᵲ', 'ᵳ', 'ᶉ', 'ṙ', 'ṛ', 'ṝ', 'ṟ', 'ⓡ', 'ꝛ', 'ꞃ', 'ｒ':
		return "r"
	case '⒭':
		return "(r)"
	case 'Ś', 'Ŝ', 'Ş', 'Š', 'Ș', 'Ṡ', 'Ṣ', 'Ṥ', 'Ṧ', 'Ṩ', 'Ⓢ', 'ꜱ', 'ꞅ', 'Ｓ':
		return "S"
	case 'ś', 'ŝ', 'ş', 'š', 'ſ', 'ș', 'ȿ', 'ʂ', 'ᵴ', 'ᶊ', 'ṡ', 'ṣ', 'ṥ', 'ṧ', 'ṩ', 'ẜ', 'ẝ', 'ⓢ', 'Ꞅ', 'ｓ':
		return "s"
	case 'ẞ':
		return "SS"
	case '⒮':
		return "(s)"
	case 'ß':
		return "ss"
	case 'ﬆ':
		return "st"
	case 'Ţ', 'Ť', 'Ŧ', 'Ƭ', 'Ʈ', 'Ț', 'Ⱦ', 'ᴛ', 'Ṫ', 'Ṭ', 'Ṯ', 'Ṱ', 'Ⓣ', 'Ꞇ', 'Ｔ':
		return "T"
	case 'ţ', 'ť', 'ŧ', 'ƫ', 'ƭ', 'ț', 'ȶ', 'ʇ', 'ʈ', 'ᵵ', 'ṫ', 'ṭ', 'ṯ', 'ṱ', 'ẗ', 'ⓣ', 'ⱦ', 'ｔ':
		return "t"
	case 'Þ', 'Ꝧ':
		return "TH"
	case 'Ꜩ':
		return "TZ"
	case '⒯':
		return "(t)"
	case 'ʨ':
		return "tc"
	case 'þ', 'ᵺ', 'ꝧ':
		return "th"
	case 'ʦ':
		return "ts"
	case 'ꜩ':
		return "tz"
	case 'Ù', 'Ú', 'Û', 'Ü', 'Ũ', 'Ū', 'Ŭ', 'Ů', 'Ű', 'Ų', 'Ư', 'Ǔ', 'Ǖ', 'Ǘ', 'Ǚ', 'Ǜ', 'Ȕ', 'Ȗ', 'Ʉ', 'ᴜ', 'ᵾ', 'Ṳ', 'Ṵ', 'Ṷ', 'Ṹ', 'Ṻ', 'Ụ', 'Ủ', 'Ứ', 'Ừ', 'Ử', 'Ữ', 'Ự', 'Ⓤ', 'Ｕ':
		return "U"
	case 'ù', 'ú', 'û', 'ü', 'ũ', 'ū', 'ŭ', 'ů', 'ű', 'ų', 'ư', 'ǔ', 'ǖ', 'ǘ', 'ǚ', 'ǜ', 'ȕ', 'ȗ', 'ʉ', 'ᵤ', 'ᶙ', 'ṳ', 'ṵ', 'ṷ', 'ṹ', 'ṻ', 'ụ', 'ủ', 'ứ', 'ừ', 'ử', 'ữ', 'ự', 'ⓤ', 'ｕ':
		return "u"
	case '⒰':
		return "(u)"
	case 'ᵫ':
		return "ue"
	case 'Ʋ', 'Ʌ', 'ᴠ', 'Ṽ', 'Ṿ', 'Ỽ', 'Ⓥ', 'Ꝟ', 'Ꝩ', 'Ｖ':
		return "V"
	case 'ʋ', 'ʌ', 'ᵥ', 'ᶌ', 'ṽ', 'ṿ', 'ⓥ', 'ⱱ', 'ⱴ', 'ꝟ', 'ｖ':
		return "v"
	case 'Ꝡ':
		return "VY"
	case '⒱':
		return "(v)"
	case 'ꝡ':
		return "vy"
	case 'Ŵ', 'Ƿ', 'ᴡ', 'Ẁ', 'Ẃ', 'Ẅ', 'Ẇ', 'Ẉ', 'Ⓦ', 'Ⱳ', 'Ｗ':
		return "W"
	case 'ŵ', 'ƿ', 'ʍ', 'ẁ', 'ẃ', 'ẅ', 'ẇ', 'ẉ', 'ẘ', 'ⓦ', 'ⱳ', 'ｗ':
		return "w"
	case '⒲':
		return "(w)"
	case 'Ẋ', 'Ẍ', 'Ⓧ', 'Ｘ':
		return "X"
	case 'ᶍ', 'ẋ', 'ẍ', 'ₓ', 'ⓧ', 'ｘ':
		return "x"
	case '⒳':
		return "(x)"
	case 'Ý', 'Ŷ', 'Ÿ', 'Ƴ', 'Ȳ', 'Ɏ', 'ʏ', 'Ẏ', 'Ỳ', 'Ỵ', 'Ỷ', 'Ỹ', 'Ỿ', 'Ⓨ', 'Ｙ':
		return "Y"
	case 'ý', 'ÿ', 'ŷ', 'ƴ', 'ȳ', 'ɏ', 'ʎ', 'ẏ', 'ẙ', 'ỳ', 'ỵ', 'ỷ', 'ỹ', 'ỿ', 'ⓨ', 'ｙ':
		return "y"
	case '⒴':
		return "(y)"
	case 'Ź', 'Ż', 'Ž', 'Ƶ', 'Ȝ', 'Ȥ', 'ᴢ', 'Ẑ', 'Ẓ', 'Ẕ', 'Ⓩ', 'Ⱬ', 'Ꝣ', 'Ｚ':
		return "Z"
	case 'ź', 'ż', 'ž', 'ƶ', 'ȝ', 'ȥ', 'ɀ', 'ʐ', 'ʑ', 'ᵶ', 'ᶎ', 'ẑ', 'ẓ', 'ẕ', 'ⓩ', 'ⱬ', 'ꝣ', 'ｚ':
		return "z"
	case '⒵':
		return "(z)"
	case '⁰', '₀', '⓪', '⓿', '０':
		return "0"
	case '¹', '₁', '①', '⓵', '❶', '➀', '➊', '１':
		return "1"
	case '⒈':
		return "1."
	case '⑴':
		return "(1)"
	case '²', '₂', '②', '⓶', '❷', '➁', '➋', '２':
		return "2"
	case '⒉':
		return "2."
	case '⑵':
		return "(2)"
	case '³', '₃', '③', '⓷', '❸', '➂', '➌', '３':
		return "3"
	case '⒊':
		return "3."
	case '⑶':
		return "(3)"
	case '⁴', '₄', '④', '⓸', '❹', '➃', '➍', '４':
		return "4"
	case '⒋':
		return "4."
	case '⑷':
		return "(4)"
	case '⁵', '₅', '⑤', '⓹', '❺', '➄', '➎', '５':
		return "5"
	case '⒌':
		return "5."
	case '⑸':
		return "(5)"
	case '⁶', '₆', '⑥', '⓺', '❻', '➅', '➏', '６':
		return "6"
	case '⒍':
		return "6."
	case '⑹':
		return "(6)"
	case '⁷', '₇', '⑦', '⓻', '❼', '➆', '➐', '７':
		return "7"
	case '⒎':
		return "7."
	case '⑺':
		return "(7)"
	case '⁸', '₈', '⑧', '⓼', '❽', '➇', '➑', '８':
		return "8"
	case '⒏':
		return "8."
	case '⑻':
		return "(8)"
	case '⁹', '₉', '⑨', '⓽', '❾', '➈', '➒', '９':
		return "9"
	case '⒐':
		return "9."
	case '⑼':
		return "(9)"
	case '⑩', '⓾', '❿', '➉', '➓':
		return "10"
	case '⒑':
		return "10."
	case '⑽':
		return "(10)"
	case '⑪', '⓫':
		return "11"
	case '⒒':
		return "11."
	case '⑾':
		return "(11)"
	case '⑫', '⓬':
		return "12"
	case '⒓':
		return "12."
	case '⑿':
		return "(12)"
	case '⑬', '⓭':
		return "13"
	case '⒔':
		return "13."
	case '⒀':
		return "(13)"
	case '⑭', '⓮':
		return "14"
	case '⒕':
		return "14."
	case '⒁':
		return "(14)"
	case '⑮', '⓯':
		return "15"
	case '⒖':
		return "15."
	case '⒂':
		return "(15)"
	case '⑯', '⓰':
		return "16"
	case '⒗':
		return "16."
	case '⒃':
		return "(16)"
	case '⑰', '⓱':
		return "17"
	case '⒘':
		return "17."
	case '⒄':
		return "(17)"
	case '⑱', '⓲':
		return "18"
	case '⒙':
		return "18."
	case '⒅':
		return "(18)"
	case '⑲', '⓳':
		return "19"
	case '⒚':
		return "19."
	case '⒆':
		return "(19)"
	case '⑳', '⓴':
		return "20"
	case '⒛':
		return "20."
	case '⒇':
		return "(20)"
	case '«', '»', '“', '”', '„', '″', '‶', '❝', '❞', '❮', '❯', '＂':
		return "\""
	case '‘', '’', '‚', '‛', '′', '‵', '‹', '›', '❛', '❜', '＇':
		return "'"
	case '‐', '‑', '‒', '–', '—', '⁻', '₋', '－':
		return "-"
	case '⁅', '❲', '［':
		return "["
	case '⁆', '❳', '］':
		return "]"
	case '⁽', '₍', '❨', '❪', '（':
		return "("
	case '⸨':
		return "(("
	case '⁾', '₎', '❩', '❫', '）':
		return ")"
	case '⸩':
		return "))"
	case '❬', '❰', '＜':
		return "<"
	case '❭', '❱', '＞':
		return ">"
	case '❴', '｛':
		return "{"
	case '❵', '｝':
		return "}"
	case '⁺', '₊', '＋':
		return "+"
	case '⁼', '₌', '＝':
		return "="
	case '！':
		return "!"
	case '‼':
		return "!!"
	case '⁉':
		return "!?"
	case '＃':
		return "#"
	case '＄':
		return "$"
	case '⁒', '％':
		return "%"
	case '＆':
		return "&"
	case '⁎', '＊':
		return "*"
	case '，':
		return ","
	case '．':
		return "."
	case '⁄', '／':
		return "/"
	case '：':
		return ":"
	case '⁏', '；':
		return ";"
	case '？':
		return "?"
	case '⁇':
		return "??"
	case '⁈':
		return "?!"
	case '＠':
		return "@"
	case '＼':
		return "\\"
	case '‸', '＾':
		return "^"
	case '＿':
		return "_"
	case '⁓', '～':
		return "~"

	default:
		return string(r)
	}
}
