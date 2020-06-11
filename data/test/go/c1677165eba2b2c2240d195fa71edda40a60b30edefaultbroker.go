package invt

import (
	"log"

	"google.golang.org/grpc"

	"fmt"

	"net"

	bc "github.com/apourchet/investment/lib/broadcaster"
	pb "github.com/apourchet/investment/protos"
	"golang.org/x/net/context"
)

type DefaultBroker struct {
	port       int
	quoteBc    *bc.Broadcaster
	candleBc   *bc.Broadcaster
	lastquote  *Quote
	lastCandle *Candle
	account    *Account
}

const (
	ONLY_INSTRUMENTID = "EURUSD"
)

func NewDefaultBroker(port int) *DefaultBroker {
	b := &DefaultBroker{port, bc.NewBroadcaster(), bc.NewBroadcaster(), nil, nil, NewAccount(10000)}
	return b
}

func (b *DefaultBroker) GetClient() pb.BrokerClient {
	conn, err := grpc.Dial(fmt.Sprintf(":%d", b.port), grpc.WithInsecure())
	if err != nil {
		return nil
	}
	return pb.NewBrokerClient(conn)
}

func (b *DefaultBroker) Start() error {
	log.Println("Starting defaultbroker")
	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", b.port))
	if err != nil {
		fmt.Println("ERROR: " + err.Error())
		return err
	}

	server := grpc.NewServer()
	pb.RegisterBrokerServer(server, b)
	err = server.Serve(lis)
	if err != nil {
		fmt.Println("ERROR: " + err.Error())
	}
	return err
}

func (b *DefaultBroker) StreamPrices(req *pb.StreamPricesReq, stream pb.Broker_StreamPricesServer) error {
	if req.InstrumentId != ONLY_INSTRUMENTID {
		return fmt.Errorf("Unsupported InstrumentID. Only support " + "EURUSD")
	}
	cb := make(chan interface{})
	rid := b.quoteBc.Register(cb)
	for qdata := range cb {
		if qdata == nil {
			stream.Send(nil)
			b.quoteBc.Deregister(rid)
			return nil
		} else {
			q := qdata.(*Quote)
			qp := q.Proto()
			err := stream.Send(qp)
			if err != nil {
				b.quoteBc.Deregister(rid)
				return err
			}
		}
	}
	return nil
}

func (b *DefaultBroker) StreamCandle(req *pb.StreamCandleReq, stream pb.Broker_StreamCandleServer) error {
	if req.InstrumentId != ONLY_INSTRUMENTID {
		return fmt.Errorf("Unsupported InstrumentID. Only support " + "EURUSD")
	}
	cb := make(chan interface{})
	rid := b.candleBc.Register(cb)
	for cdata := range cb {
		if cdata == nil {
			stream.Send(nil)
			b.candleBc.Deregister(rid)
			return nil
		} else {
			c := cdata.(*Candle)
			cp := c.Proto()
			err := stream.Send(cp)
			if err != nil {
				b.candleBc.Deregister(rid)
				return err
			}
		}
	}
	return nil
}

func (b *DefaultBroker) CreateOrder(ctx context.Context, req *pb.OrderCreationReq) (*pb.OrderCreationResp, error) {
	if req.Type == "market" {
		TradeQuote(b.account, b.lastquote, req.Units, ParseSide(req.Side))
	}
	resp := &pb.OrderCreationResp{}
	resp.InstrumentId = req.InstrumentId
	resp.Price = b.lastquote.Price(req.Side)
	// TODO
	return resp, nil
}

func (b *DefaultBroker) GetAccountInfo(context.Context, *pb.AccountInfoReq) (*pb.AccountInfoResp, error) {
	resp := &pb.AccountInfoResp{}
	resp.Info = &pb.AccountInfo{}
	resp.Info.Currency = b.account.Currency
	resp.Info.Balance = b.account.Balance
	resp.Info.MarginAvail = b.account.MarginAvailable(b.getQuoteContext())
	resp.Info.MarginUsed = b.account.MarginUsed(b.getQuoteContext())
	resp.Info.RealizedPl = b.account.RealizedPl
	// TODO more info
	return resp, nil
}

func (b *DefaultBroker) GetInstrumentList(context.Context, *pb.InstrumentListReq) (*pb.InstrumentListResp, error) {
	// TODO
	return nil, nil
}

func (b *DefaultBroker) GetPrices(context.Context, *pb.PriceListReq) (*pb.PriceListResp, error) {
	// TODO
	return nil, nil
}

func (b *DefaultBroker) GetLastCandle(ctx context.Context, in *pb.LastCandleReq) (*pb.LastCandleResp, error) {
	// TODO
	return nil, nil
}

func (b *DefaultBroker) GetAccounts(context.Context, *pb.AccountListReq) (*pb.AccountListResp, error) {
	// TODO
	return nil, nil
}

func (b *DefaultBroker) GetOrders(context.Context, *pb.OrderListReq) (*pb.OrderListResp, error) {
	// TODO
	return nil, nil
}

func (b *DefaultBroker) OnData(record []string, format DataFormat) {
	if format == DATAFORMAT_QUOTE {
		q := ParseQuoteFromRecord(ONLY_INSTRUMENTID, record)
		b.lastquote = q
		b.quoteBc.Emit(q)
	} else if format == DATAFORMAT_CANDLE {
		c := ParseCandleFromRecord(ONLY_INSTRUMENTID, record)
		b.lastCandle = c
		b.lastquote = &Quote{}
		b.lastquote.Bid = c.Close
		b.lastquote.Ask = c.Close + 0.00025
		b.lastquote.InstrumentId = c.InstrumentId
		b.lastquote.Timestamp = c.Timestamp
		b.candleBc.Emit(c)
	}
}

func (b *DefaultBroker) OnEnd() {
	log.Printf("Account: %+v\n", b.account.Stats)
	b.quoteBc.Emit(nil)
	b.candleBc.Emit(nil)
}

func (b *DefaultBroker) getQuoteContext() *QuoteContext {
	return &QuoteContext{ONLY_INSTRUMENTID: b.lastquote}
}
