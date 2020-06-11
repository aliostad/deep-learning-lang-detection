package main

import (
	//"fmt"
	"encoding/json"
	"time"
	"strconv"
)

//oanda.go is where you just have the functions you need... this is where you call them not in main.go. In main.go you should create a new struct 
//prices is the name of the primary key in the json response
type CurrentPrices struct {
	Prices []CurrentPricesData `json:"prices"` 
}

type CurrentPricesData struct {
	Instrument string `json:"instrument"`
	Time time.Time `json:"time"`
	Bid float64 `json:"bid"`
	Ask float64 `json:"ask"`
}

//does this need to be a method? your already instantiating a CurrentPrices struct within the funtion
//using 'this' as the method recieve argument which refers to 'this' struct 
//i find the oop style usefule in this case
func (this CurrentPrices) UnmarshalCurrentPrices(instrument string) string {
	responseByte := GetCurrentPrices(instrument)

	//json.Unmarshal takes a []byte and a struct as arguments
	err := json.Unmarshal(responseByte, &this)
	if err != nil {
		panic(err)
        }
	return strconv.FormatFloat(this.Prices[0].Bid, 'f', 6, 64)
}
