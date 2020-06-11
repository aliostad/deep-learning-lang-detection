package ib

import (
	"crypto/md5"
	"encoding/hex"
	"encoding/json"
	"strings"
	"time"

	agent "github.com/gofinance/ib"
	"github.com/quantPlatform/quant/core"
	log "github.com/sirupsen/logrus"
)

const lpName = "ib"

func Init() {
	ib := &IB{}
	ib.Register(core.Lps())
}

func Serialize(contract *core.Contract) (string, error) {
	contractJson, err := json.Marshal(contract)
	if err != nil {
		return "", err
	}

	md5Cxt := md5.New()
	md5Cxt.Write([]byte(contractJson))
	cipherStr := md5Cxt.Sum(nil)
	return hex.EncodeToString(cipherStr), nil
}

type IB struct {
	core.Lp
	core.Strategy
	*agent.Engine
	contracts      []core.Contract
	dataLevels     []core.HistDataBarSize
	instrumentMgrs map[string]*agent.InstrumentManager
	historicalMgrs map[string]*agent.HistoricalDataManager
}

func (ib *IB) Register(registry core.LpRegistry) {
	if registry == nil {
		return
	}

	registry.Register(ib)
}

func (ib *IB) Init(enginee *agent.Engine, strategy core.Strategy, contracts []core.Contract, dataLevels []core.HistDataBarSize) {
	if enginee == nil || strategy == nil {
		log.Fatalf("[ib->Init] invalid parameter")
		return
	}

	ib.Strategy = strategy
	ib.Engine = enginee
	ib.contracts = contracts
	ib.dataLevels = dataLevels

	ib.instrumentMgrs = make(map[string]*agent.InstrumentManager)
	ib.historicalMgrs = make(map[string]*agent.HistoricalDataManager)

	ib.activateContracts(contracts)
}

func (ib *IB) Name() string {
	return lpName
}

func (ib *IB) addInstrumentManager(contract *core.Contract) {
	log.Printf("[addInstrumentManager] contract: %v", contract)

	serializedContract, err := Serialize(contract)
	if err != nil {
		log.Printf("serialize fail for contract %v, err : %s", contract, err.Error())
		return
	}

	if _, ok := ib.instrumentMgrs[serializedContract]; ok {
		log.Printf("instrumentMgr exist for contract : ", contract)
		return
	}

	instrumentMgr, err := agent.NewInstrumentManager(ib.Engine, *contract)
	if err != nil {
		log.Printf("[NewInstrumentManager] fail : ", err.Error())
		return
	}

	ib.instrumentMgrs[serializedContract] = instrumentMgr
}

func (ib *IB) addHistoricalManager(contract *core.Contract, barSize core.HistDataBarSize) {
	log.Printf("[addHistoricalManager] contract: %v", contract)

	// serializedContract, err := Serialize(contract)
	// if err != nil {
	// 	log.Printf("serialize fail for contract %v, err : %s", contract, err.Error())
	// 	return
	// }

	serializedContract := contract.Symbol + "/" + string(barSize)
	log.WithFields(log.Fields{"func": "addHistoricalManager", "contract": serializedContract})

	if _, ok := ib.historicalMgrs[serializedContract]; ok {
		log.Printf("historicalMgr exist for contract : ", contract)
		return
	}

	request := agent.RequestHistoricalData{
		Contract:    *contract,
		EndDateTime: time.Now(),
		Duration:    "365 D",
		BarSize:     barSize,
		WhatToShow:  agent.HistAsk,
		UseRTH:      true,
	}

	historicalMgr, err := agent.NewHistoricalDataManager(ib.Engine, request)
	if err != nil {
		log.Printf("[NewHistoricalDataManager] fail : ", err.Error())
		return
	}

	ib.historicalMgrs[serializedContract] = historicalMgr
}

func (ib *IB) activateContracts(contracts []core.Contract) {
	for i := 0; i < len(contracts); i++ {
		contract := &contracts[i]
		//ib.addInstrumentManager(contract)
		for dataLevelIndex := 0; dataLevelIndex < len(ib.dataLevels); dataLevelIndex++ {
			ib.addHistoricalManager(contract, ib.dataLevels[dataLevelIndex])
		}
	}
}

func (ib *IB) Start(strategyName string, contracts []core.Contract) {
	log.Printf("IB start for strategy : %s", strategyName)

	strategy := core.Strategies().Find(strategyName)
	if strategy == nil {
		return
	}

	engine := newEngine(getGatewayURL())
	ib.Init(engine, strategy, contracts, strategy.GetDataLevels())

	//ib.onInstrumentEvents()
	ib.onHistoricalEvents()
	ib.Condition()
	ib.Order()
}

func (ib *IB) onInstrumentEvents() {
	for _, mgr := range ib.instrumentMgrs {
		if mgr == nil {
			log.Fatalf("Invalid instrument manager")
			return
		}

		go func(instrumentMgr *agent.InstrumentManager) {
			for {
				if ib.onEvent(instrumentMgr) {
					ib.OnTick(instrumentMgr.Ask(), instrumentMgr.Bid(), instrumentMgr.Last())
				}
			}
		}(mgr)
	}
}

func (ib *IB) onEvent(mgr agent.Manager) bool {
	const interval int = 5

	select {
	case <-time.After(time.Duration(interval) * time.Second):
		log.Printf("no event for %d seconds", interval)
		return false

	case _, ok := <-mgr.Refresh():
		if !ok {
			log.Printf("event error: %v", mgr.FatalError())
			time.Sleep(5 * time.Second)
			return false
		}

		return true
	}

}

func (ib *IB) onHistoricalEvents() {
	for serializedContract, mgr := range ib.historicalMgrs {
		if mgr == nil {
			log.Fatalf("Invalid instrument manager")
			return
		}

		func(contractStr string, mgr *agent.HistoricalDataManager) {
			for {
				if !ib.onEvent(mgr) {
					continue
				}

				log.Printf("historical data : ", mgr.Items())

				ret := strings.SplitAfter(contractStr, "/")
				barSize := ret[1]
				switch barSize {
				case core.HistBarSize30Min:
					ib.Strategy.OnHistBarSize30Min(mgr.Items())
				case core.HistBarSize1Day:
					ib.Strategy.OnHistBarSize1Day(mgr.Items())
				}
				return
			}
		}(serializedContract, mgr)
	}
}

/*
func TestInstrumentManager(t *testing.T) {
	engine := NewTestEngine(t)

	defer engine.ConditionalStop(t)

	contract := Contract{
		Symbol:       "USD",
		SecurityType: "CASH",
		Exchange:     "IDEALPRO",
		Currency:     "JPY",
	}

	i, err := NewInstrumentManager(engine, contract)
	if err != nil {
		t.Fatalf("error creating manager: %s", err)
	}

	defer i.Close()

	SinkManagerTest(t, i, 15*time.Second, 2)

	if i.Bid() == 0 {
		t.Fatal("No bid received")
	}

	if i.Ask() == 0 {
		t.Fatal("No bid received")
	}

	i.Last()
}
*/
