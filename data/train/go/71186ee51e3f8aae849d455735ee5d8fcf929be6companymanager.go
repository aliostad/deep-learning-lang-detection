package stmanager

import(
    "util"
    //"time"
)

type CompanyManager struct{
    logger *util.StockLog
}

func (m *CompanyManager) Init() {
    m.logger = util.NewLog()
}

func (m *CompanyManager) Process() {
    var c chan int
    c = make(chan int)
    shm := NewSHSECompanyManager()
    go func(){
        shm.Process()
        c <- 1
    }()

    szm := NewSZSECompanyManager()
    go func() {
        szm.Process()
        c <- 2
    }()

    <-c
    <-c
}

func NewCompanyManager() *CompanyManager{
    m := new(CompanyManager)
    m.Init()

    return m
}
