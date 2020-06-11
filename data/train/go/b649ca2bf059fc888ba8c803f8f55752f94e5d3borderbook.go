package orderbook

import (
	"errors"
	"math"
	"sort"

	"github.com/mdebrouwer/exchange/log"
)

type Orderbook interface {
	InsertOrder(order Order) ([]Trade, error)
	DeleteOrder(order Order) error
	GetTopLevels() (PriceLevel, PriceLevel)
	GetBestBid() PriceLevel
	GetBestAsk() PriceLevel
	GetPriceLevels() []PriceLevel
}

type orderbook struct {
	logger     log.Logger
	instrument Instrument
	orderbook  map[Price]*priceLevel
}

func NewOrderbook(logger log.Logger, instrument Instrument) Orderbook {
	ob := new(orderbook)
	ob.logger = logger
	ob.instrument = instrument
	ob.orderbook = make(map[Price]*priceLevel)
	return ob
}

func (ob *orderbook) InsertOrder(order Order) ([]Trade, error) {
	ob.logger.Printf("Inserting order: %s\n", order)

	if math.Mod(order.GetPrice().Value(), ob.instrument.GetTickSize().Value()) != 0 {
		return nil, errors.New("Cannot insert order: Invalid Price!")
	}

	if order.GetSide() == BUY {
		if pl, ok := ob.orderbook[order.GetPrice()]; !ok {
			pl := NewPriceLevel(order.GetPrice())
			ob.orderbook[order.GetPrice()] = pl
			return nil, pl.InsertOrder(order)
		} else {
			return nil, pl.InsertOrder(order)
		}
	}

	if order.GetSide() == SELL {
		if pl, ok := ob.orderbook[order.GetPrice()]; !ok {
			pl := NewPriceLevel(order.GetPrice())
			ob.orderbook[order.GetPrice()] = pl
			return nil, pl.InsertOrder(order)
		} else {
			return nil, pl.InsertOrder(order)
		}
	}

	return make([]Trade, 0), nil
}

func (ob *orderbook) DeleteOrder(order Order) error {
	ob.logger.Printf("Deleting order: %s\n", order)

	if pricelevel, ok := ob.orderbook[order.GetPrice()]; ok {
		return pricelevel.DeleteOrder(order.GetOrderId())
	}
	return errors.New("Cannot delete order: PriceLevel does not exist!")
}

func (ob *orderbook) GetTopLevels() (PriceLevel, PriceLevel) {
	return ob.GetBestBid(), ob.GetBestAsk()
}

func (ob *orderbook) GetBestBid() PriceLevel {
	prices := ob.getSortedPrices()
	for i := len(prices) - 1; i >= 0; i-- {
		if len(ob.orderbook[prices[i]].GetBids()) > 0 {
			return ob.orderbook[prices[i]]
		}
	}
	return nil
}

func (ob *orderbook) GetBestAsk() PriceLevel {
	prices := ob.getSortedPrices()
	for i := 0; i < len(prices); i++ {
		if len(ob.orderbook[prices[i]].GetAsks()) > 0 {
			return ob.orderbook[prices[i]]
		}
	}
	return nil
}

func (ob *orderbook) GetPriceLevels() []PriceLevel {
	prices := ob.getSortedPrices()
	pricelevels := make([]PriceLevel, 0)
	for _, price := range prices {
		pricelevels = append(pricelevels, ob.orderbook[price])
	}
	return pricelevels
}

func (ob *orderbook) getSortedPrices() []Price {
	var prices Prices
	for price := range ob.orderbook {
		prices = append(prices, price)
	}
	sort.Sort(prices)
	return prices
}
