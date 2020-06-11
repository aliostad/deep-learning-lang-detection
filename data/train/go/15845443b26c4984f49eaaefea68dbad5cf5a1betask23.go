package main

import (
	"fmt"
	"sort"
	"time"
)

func main23() {
	timestamp := []int{1450625399, 1450625400, 1450625500, 1450625550, 1451644200, 1451690100, 1451691000}
	instrument := []string{"HPQ", "HPQ", "HPQ", "HPQ", "AAPL", "HPQ", "GOOG"}
	side := []string{"sell", "buy", "buy", "sell", "buy", "buy", "buy"}
	price := []float32{10, 20.3, 35.5, 8.65, 20, 10, 100.35}
	size := []int{10, 1, 2, 3, 5, 1, 10}
	res := dailyOHLC(timestamp, instrument, side, price, size)
	fmt.Printf("res = %+v\n", res)
}

type Bid struct {
	time   int
	ticket string
}

type BidDetail struct {
	open  float32
	close float32
	low   float32
	high  float32
}

type ByDateAndTicket [][]string

func (a ByDateAndTicket) Len() int      { return len(a) }
func (a ByDateAndTicket) Swap(i, j int) { a[i], a[j] = a[j], a[i] }
func (a ByDateAndTicket) Less(i, j int) bool {
	if a[i][0] == a[j][0] {
		return a[i][1] < a[j][1]
	}
	return a[i][0] < a[j][0]
}

func dailyOHLC(timestamp []int, instrument []string, side []string, price []float32,
	size []int) [][]string {

	bids := make(map[Bid]*BidDetail)
	for i := 0; i < len(timestamp); i++ {
		bid := Bid{timestamp[i] / 86400, instrument[i]}
		det, ok := bids[bid]
		if !ok {
			det = &BidDetail{price[i], price[i], price[i], price[i]}
			bids[bid] = det
		}
		det.close = price[i]
		if det.high < price[i] {
			det.high = price[i]
		}
		if det.low > price[i] {
			det.low = price[i]
		}
	}
	res := make([][]string, 0)
	for k, v := range bids {
		row := make([]string, 6)
		row[0] = time.Unix(int64(k.time)*86400, 0).UTC().Format("2006-01-02")
		row[1] = k.ticket
		row[2] = fmt.Sprintf("%.2f", v.open)
		row[3] = fmt.Sprintf("%.2f", v.high)
		row[4] = fmt.Sprintf("%.2f", v.low)
		row[5] = fmt.Sprintf("%.2f", v.close)
		res = append(res, row)
	}
	sort.Sort(ByDateAndTicket(res))

	return res
}
