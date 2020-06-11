package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"os"
)

var oandaUrl string = "https://api-fxpractice.oanda.com/v1/"
var bearer string = "Bearer " + os.Getenv("OANDA_TOKEN")


func GetCurrentPrices(instrument string) []byte {
	client := &http.Client{}
	queryValues := url.Values{}
	queryValues.Add("instruments", instrument)

	//Using .Add method here to pass parameters. When I tried this for multiple parameters
	//it got out of order and it did not work

	req, err := http.NewRequest("GET", oandaUrl+"prices?"+queryValues.Encode(), nil)
	req.Header.Set("Authorization", bearer)
	resp, err := client.Do(req)

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	defer resp.Body.Close()
	byte, _ := ioutil.ReadAll(resp.Body)
	return byte
}


//FIXME: Pay attention to the return type on this function. Not sure what it should return ATM
//curl -X GET "https://api-fxtrade.oanda.com/v1/candles?instrument=EUR_USD&count=2&candleFormat=midpoint&granularity=D&dailyAlignment=0&alignmentTimezone=America%2FNew_York"
func RetrieveInstrumentHistory(instrument string, count string, granularity string) []byte {
	client := &http.Client{}

	//There has got to be a way to correctly build a query string. I just have not figured it out yet
	req, err := http.NewRequest("GET",
		oandaUrl+"candles?"+
			"instrument="+instrument+
			"&count="+count+
			"&candleFormat=midpoint"+
			"&granularity="+granularity+
			"&dailyAlignment=0"+
			"&alignmentTimezone=America%2FNew_York", nil)

	req.Header.Set("Authorization", bearer)
	resp, err := client.Do(req)

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	defer resp.Body.Close()
	byte, _ := ioutil.ReadAll(resp.Body)
	return byte

}
