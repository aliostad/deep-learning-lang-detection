package oandago

import (
	"fmt"
)

// Instrument type
type Instrument string

func (ins *Instrument) String() string {
	return fmt.Sprintf("%s", string(*ins))
}

// JoinInstruments joins an array of instruments
func JoinInstruments(instruments []Instrument, sep string) string {
	// source: https://golang.org/src/strings/strings.go?m=text
	if len(instruments) == 0 {
		return ""
	}
	if len(instruments) == 1 {
		return instruments[0].String()
	}
	n := len(sep) * (len(instruments) - 1)
	for i := 0; i < len(instruments); i++ {
		n += len(instruments[i])
	}

	b := make([]byte, n)
	bp := copy(b, instruments[0])
	for _, s := range instruments[1:] {
		bp += copy(b[bp:], sep)
		bp += copy(b[bp:], s)
	}
	return string(b)
}

// List of most instruments
const (
	nullInstrument Instrument = ""           // null instrument value for internal purposes
	AU200_AUD      Instrument = "AU200_AUD"  // Australia 200
	AUD_CAD        Instrument = "AUD_CAD"    // AUD/CAD
	AUD_CHF        Instrument = "AUD_CHF"    // AUD/CHF
	AUD_HKD        Instrument = "AUD_HKD"    // AUD/HKD
	AUD_JPY        Instrument = "AUD_JPY"    // AUD/JPY
	AUD_NZD        Instrument = "AUD_NZD"    // AUD/NZD
	AUD_SGD        Instrument = "AUD_SGD"    // AUD/SGD
	AUD_USD        Instrument = "AUD_USD"    // AUD/USD
	BCO_USD        Instrument = "BCO_USD"    // Brent Crude Oil
	CAD_CHF        Instrument = "CAD_CHF"    // CAD/CHF
	CAD_HKD        Instrument = "CAD_HKD"    // CAD/HKD
	CAD_JPY        Instrument = "CAD_JPY"    // CAD/JPY
	CAD_SGD        Instrument = "CAD_SGD"    // CAD/SGD
	CH20_CHF       Instrument = "CH20_CHF"   // Swiss 20
	CHF_HKD        Instrument = "CHF_HKD"    // CHF/HKD
	CHF_JPY        Instrument = "CHF_JPY"    // CHF/JPY
	CHF_ZAR        Instrument = "CHF_ZAR"    // CHF/ZAR
	CORN_USD       Instrument = "CORN_USD"   // Corn
	DE10YB_EUR     Instrument = "DE10YB_EUR" // Bund
	DE30_EUR       Instrument = "DE30_EUR"   // Germany 30
	EU50_EUR       Instrument = "EU50_EUR"   // Europe 50
	EUR_AUD        Instrument = "EUR_AUD"    // EUR/AUD
	EUR_CAD        Instrument = "EUR_CAD"    // EUR/CAD
	EUR_CHF        Instrument = "EUR_CHF"    // EUR/CHF
	EUR_CZK        Instrument = "EUR_CZK"    // EUR/CZK
	EUR_DKK        Instrument = "EUR_DKK"    // EUR/DKK
	EUR_GBP        Instrument = "EUR_GBP"    // EUR/GBP
	EUR_HKD        Instrument = "EUR_HKD"    // EUR/HKD
	EUR_HUF        Instrument = "EUR_HUF"    // EUR/HUF
	EUR_JPY        Instrument = "EUR_JPY"    // EUR/JPY
	EUR_NOK        Instrument = "EUR_NOK"    // EUR/NOK
	EUR_NZD        Instrument = "EUR_NZD"    // EUR/NZD
	EUR_PLN        Instrument = "EUR_PLN"    // EUR/PLN
	EUR_SEK        Instrument = "EUR_SEK"    // EUR/SEK
	EUR_SGD        Instrument = "EUR_SGD"    // EUR/SGD
	EUR_TRY        Instrument = "EUR_TRY"    // EUR/TRY
	EUR_USD        Instrument = "EUR_USD"    // EUR/USD
	EUR_ZAR        Instrument = "EUR_ZAR"    // EUR/ZAR
	FR40_EUR       Instrument = "FR40_EUR"   // France 40
	GBP_AUD        Instrument = "GBP_AUD"    // GBP/AUD
	GBP_CAD        Instrument = "GBP_CAD"    // GBP/CAD
	GBP_CHF        Instrument = "GBP_CHF"    // GBP/CHF
	GBP_HKD        Instrument = "GBP_HKD"    // GBP/HKD
	GBP_JPY        Instrument = "GBP_JPY"    // GBP/JPY
	GBP_NZD        Instrument = "GBP_NZD"    // GBP/NZD
	GBP_PLN        Instrument = "GBP_PLN"    // GBP/PLN
	GBP_SGD        Instrument = "GBP_SGD"    // GBP/SGD
	GBP_USD        Instrument = "GBP_USD"    // GBP/USD
	GBP_ZAR        Instrument = "GBP_ZAR"    // GBP/ZAR
	HK33_HKD       Instrument = "HK33_HKD"   // Hong Kong 33
	HKD_JPY        Instrument = "HKD_JPY"    // HKD/JPY
	JP225_USD      Instrument = "JP225_USD"  // Japan 225
	NAS100_USD     Instrument = "NAS100_USD" // US Nas 100
	NATGAS_USD     Instrument = "NATGAS_USD" // Natural Gas
	NL25_EUR       Instrument = "NL25_EUR"   // Netherlands 25
	NZD_CAD        Instrument = "NZD_CAD"    // NZD/CAD
	NZD_CHF        Instrument = "NZD_CHF"    // NZD/CHF
	NZD_HKD        Instrument = "NZD_HKD"    // NZD/HKD
	NZD_JPY        Instrument = "NZD_JPY"    // NZD/JPY
	NZD_SGD        Instrument = "NZD_SGD"    // NZD/SGD
	NZD_USD        Instrument = "NZD_USD"    // NZD/USD
	SG30_SGD       Instrument = "SG30_SGD"   // Singapore 30
	SGD_CHF        Instrument = "SGD_CHF"    // SGD/CHF
	SGD_HKD        Instrument = "SGD_HKD"    // SGD/HKD
	SGD_JPY        Instrument = "SGD_JPY"    // SGD/JPY
	SOYBN_USD      Instrument = "SOYBN_USD"  // Soybeans
	SPX500_USD     Instrument = "SPX500_USD" // US SPX 500
	SUGAR_USD      Instrument = "SUGAR_USD"  // Sugar
	TRY_JPY        Instrument = "TRY_JPY"    // TRY/JPY
	UK100_GBP      Instrument = "UK100_GBP"  // UK 100
	UK10YB_GBP     Instrument = "UK10YB_GBP" // UK 10Y Gilt
	US2000_USD     Instrument = "US2000_USD" // US Russ 2000
	US30_USD       Instrument = "US30_USD"   // US Wall St 30
	USB02Y_USD     Instrument = "USB02Y_USD" // US 2Y T-Note
	USB05Y_USD     Instrument = "USB05Y_USD" // US 5Y T-Note
	USB10Y_USD     Instrument = "USB10Y_USD" // US 10Y T-Note
	USB30Y_USD     Instrument = "USB30Y_USD" // US T-Bond
	USD_CAD        Instrument = "USD_CAD"    // USD/CAD
	USD_CHF        Instrument = "USD_CHF"    // USD/CHF
	USD_CNH        Instrument = "USD_CNH"    // USD/CNH
	USD_CZK        Instrument = "USD_CZK"    // USD/CZK
	USD_DKK        Instrument = "USD_DKK"    // USD/DKK
	USD_HKD        Instrument = "USD_HKD"    // USD/HKD
	USD_HUF        Instrument = "USD_HUF"    // USD/HUF
	USD_INR        Instrument = "USD_INR"    // USD/INR
	USD_JPY        Instrument = "USD_JPY"    // USD/JPY
	USD_MXN        Instrument = "USD_MXN"    // USD/MXN
	USD_NOK        Instrument = "USD_NOK"    // USD/NOK
	USD_PLN        Instrument = "USD_PLN"    // USD/PLN
	USD_SAR        Instrument = "USD_SAR"    // USD/SAR
	USD_SEK        Instrument = "USD_SEK"    // USD/SEK
	USD_SGD        Instrument = "USD_SGD"    // USD/SGD
	USD_THB        Instrument = "USD_THB"    // USD/THB
	USD_TRY        Instrument = "USD_TRY"    // USD/TRY
	USD_ZAR        Instrument = "USD_ZAR"    // USD/ZAR
	WHEAT_USD      Instrument = "WHEAT_USD"  // Wheat
	WTICO_USD      Instrument = "WTICO_USD"  // West Texas Oil
	XAG_AUD        Instrument = "XAG_AUD"    // Silver/AUD
	XAG_CAD        Instrument = "XAG_CAD"    // Silver/CAD
	XAG_CHF        Instrument = "XAG_CHF"    // Silver/CHF
	XAG_EUR        Instrument = "XAG_EUR"    // Silver/EUR
	XAG_GBP        Instrument = "XAG_GBP"    // Silver/GBP
	XAG_HKD        Instrument = "XAG_HKD"    // Silver/HKD
	XAG_JPY        Instrument = "XAG_JPY"    // Silver/JPY
	XAG_NZD        Instrument = "XAG_NZD"    // Silver/NZD
	XAG_SGD        Instrument = "XAG_SGD"    // Silver/SGD
	XAG_USD        Instrument = "XAG_USD"    // Silver
	XAU_AUD        Instrument = "XAU_AUD"    // Gold/AUD
	XAU_CAD        Instrument = "XAU_CAD"    // Gold/CAD
	XAU_CHF        Instrument = "XAU_CHF"    // Gold/CHF
	XAU_EUR        Instrument = "XAU_EUR"    // Gold/EUR
	XAU_GBP        Instrument = "XAU_GBP"    // Gold/GBP
	XAU_HKD        Instrument = "XAU_HKD"    // Gold/HKD
	XAU_JPY        Instrument = "XAU_JPY"    // Gold/JPY
	XAU_NZD        Instrument = "XAU_NZD"    // Gold/NZD
	XAU_SGD        Instrument = "XAU_SGD"    // Gold/SGD
	XAU_USD        Instrument = "XAU_USD"    // Gold
	XAU_XAG        Instrument = "XAU_XAG"    // Gold/Silver
	XCU_USD        Instrument = "XCU_USD"    // Copper
	XPD_USD        Instrument = "XPD_USD"    // Palladium
	XPT_USD        Instrument = "XPT_USD"    // Platinum
	ZAR_JPY        Instrument = "ZAR_JPY"    // ZAR/JPY
)
