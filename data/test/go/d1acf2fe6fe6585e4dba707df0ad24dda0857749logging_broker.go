package marketutil

import (
	"fmt"
	"github.com/oguzbilgic/fpd"
	"github.com/oguzbilgic/market"
)

type LoggingBroker struct {
	b market.Broker
}

func NewLoggingBroker(b market.Broker) *LoggingBroker {
	return &LoggingBroker{b}
}

func (l *LoggingBroker) Account() (*market.Account, error) {
	return l.b.Account()
}

func (l *LoggingBroker) SendOrder(vol *fpd.Decimal, price *market.Money, orderType market.OrderType) (string, error) {
	fmt.Printf("%s %s @ %s\n", orderType, vol.FormattedString(), price)
	return l.b.SendOrder(vol, price, orderType)
}

func (l *LoggingBroker) CancelOrder(ID string) error {
	fmt.Println("CANCEL ORDER", ID)
	return l.b.CancelOrder(ID)
}

func (l *LoggingBroker) Orders() ([]*market.Order, error) {
	return l.b.Orders()
}
