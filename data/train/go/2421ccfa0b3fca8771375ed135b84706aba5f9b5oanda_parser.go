package parser

import (
	"github.com/kenshiro-o/FxNGo/model"
	"fmt"
	"io/ioutil"
	"encoding/json"
	"net/http"
	"time"
)

const(
	refTime string = "2006-01-02T15:04:05"
)

type oandaFxParser struct{}

func (o *oandaFxParser) Parse(i *interface{}) (prices []model.FxPrice, err error){
	i2 := *i
	m := i2.(map[string]interface{})
	p := m["prices"].([]interface{})
	price := model.FxPrice{}
	for _, v := range p{
		elem := v.(map[string]interface{})
		price.Bid = elem["bid"].(float64)
		price.Ask = elem["ask"].(float64)
		instrument := elem["instrument"].(string)
		price.CcyPair = model.FxCcyPair{}
		price.CcyPair.Base = fmt.Sprintf("%s", instrument[0:3])
		price.CcyPair.Terms = fmt.Sprintf("%s", instrument[4:])
		
		priceTime := elem["time"].(string)
		priceTime = priceTime[0:len(refTime)]
		price.TimeStamp, _ = time.Parse(refTime, priceTime)		
	}

	prices = make([]model.FxPrice, 1)
	prices[0] = price
	return prices, nil
}

func (o *oandaFxParser) Request(ccypair model.FxCcyPair) *interface{}{
	rq := fmt.Sprintf("http://api-sandbox.oanda.com/v1/quote?instruments=%s_%s", 
		ccypair.Base, ccypair.Terms)
	res, err := http.Get(rq)
	defer res.Body.Close()

	if err != nil{
		fmt.Println("An error occurred while trying to get price for instrument [instrument=",
			ccypair.Base, "/", ccypair.Terms, "]: ", err)
		return nil
	}
	body, _ := ioutil.ReadAll(res.Body)
	
	i := new (interface {})
	json.Unmarshal(body, &i)

	return i
}