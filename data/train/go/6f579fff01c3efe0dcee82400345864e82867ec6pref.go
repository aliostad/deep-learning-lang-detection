package main

import "log"

func PrefCd2Str(n string) string {
	pref := ""
	switch n {
	case "01":
		pref = "hokkaido"
	case "02":
		pref = "aomori"
	case "03":
		pref = "iwate"
	case "04":
		pref = "miyagi"
	case "05":
		pref = "akita"
	case "06":
		pref = "yamagata"
	case "07":
		pref = "fukushima"
	case "08":
		pref = "ibaraki"
	case "09":
		pref = "tochigi"
	case "10":
		pref = "gunma"
	case "11":
		pref = "saitama"
	case "12":
		pref = "chiba"
	case "13":
		pref = "tokyo"
	case "14":
		pref = "kanagawa"
	case "15":
		pref = "niigata"
	case "16":
		pref = "toyama"
	case "17":
		pref = "ishikawa"
	case "18":
		pref = "fukui"
	case "19":
		pref = "yamanashi"
	case "20":
		pref = "nagano"
	case "21":
		pref = "gifu"
	case "22":
		pref = "shizuoka"
	case "23":
		pref = "aichi"
	case "24":
		pref = "mie"
	case "25":
		pref = "shiga"
	case "26":
		pref = "kyoto"
	case "27":
		pref = "osaka"
	case "28":
		pref = "hyogo"
	case "29":
		pref = "nara"
	case "30":
		pref = "wakayama"
	case "31":
		pref = "tottori"
	case "32":
		pref = "shimane"
	case "33":
		pref = "okayama"
	case "34":
		pref = "hiroshima"
	case "35":
		pref = "yamaguchi"
	case "36":
		pref = "tokushima"
	case "37":
		pref = "kagawa"
	case "38":
		pref = "ehime"
	case "39":
		pref = "kochi"
	case "40":
		pref = "fukuoka"
	case "41":
		pref = "saga"
	case "42":
		pref = "nagasaki"
	case "43":
		pref = "kumamoto"
	case "44":
		pref = "oita"
	case "45":
		pref = "miyazaki"
	case "46":
		pref = "kagoshima"
	case "47":
		pref = "okinawa"
	default:
		log.Println("not found....")
	}
	return pref
}
