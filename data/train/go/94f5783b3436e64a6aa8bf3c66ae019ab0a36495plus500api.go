// TODO change package to plus500api
package main

import "fmt"
import "encoding/json"
import "net/http"
import "io/ioutil"

// Instrument information.
// TODO: Update with readable names
// I: Instrument ID
// B: Buying price
// S: Selling price
// P: Unknown for the moment
type InstrumentInfo struct {
  I int
  B float64
  S float64
  P float64
}

// Object to represent the response from Plus500 call
type FeedResponse struct {
  Feeds []InstrumentInfo
}

// Retrieve instrument info by ID
func getLastInstrumentInfo(instrumentId int) InstrumentInfo {
  url := fmt.Sprintf("http://marketools.plus500.com/Feeds/UpdateTable?instsIds=%d", instrumentId)
  resp, err := http.Get(url)
  defer resp.Body.Close()
  if err != nil {
    // handle error
    panic(err)
  }
  body, err := ioutil.ReadAll(resp.Body)

  var output FeedResponse

  if err := json.Unmarshal(body, &output); err != nil {
    panic(err)
  }

  return output.Feeds[0]
}

// Get last buying price given the instrument ID
func getLastBuyPrice(instrumentId int) float64 {
  info := getLastInstrumentInfo(instrumentId)
  return info.B
}

// Get last selling price given the instrument ID
func getLastSellPrice(instrumentId int) float64 {
  info := getLastInstrumentInfo(instrumentId)
  return info.S
}

// Main method.
// This only contains some example calls
func main() {
  // Show full info
  var info = getLastInstrumentInfo(19)
  fmt.Println("Full info:")
  fmt.Println(info)

  // Show last buy price
  var lastBuyPrice = getLastBuyPrice(19)
  fmt.Println("Last buy price:")
  fmt.Println(lastBuyPrice)

  // Show last sell price
  var lastSellPrice = getLastSellPrice(19)
  fmt.Println("Last sellprice:")
  fmt.Println(lastSellPrice)
}
