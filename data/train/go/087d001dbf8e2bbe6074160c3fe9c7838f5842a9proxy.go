package main

import (
    "fmt"
    "time"
)

type SalesManager struct {}

func (p *SalesManager) work() { 
    fmt.Println("Sales Manager working...")
}

func (p *SalesManager) talk() { 
    fmt.Println("Sales Manager ready to talk")
}

type Proxy struct {
    Busy string
    Sales *SalesManager
}

func (p *Proxy) work() { 
    fmt.Println("Proxy checking for Sales Manager availability")
    if p.Busy == "No" {
        p.Sales = new(SalesManager)
        time.Sleep(1*time.Second)
        p.Sales.talk()
    } else {
        time.Sleep(1*time.Second)
        fmt.Println("Sales Manager is busy")
    }
}

func main() {
    p := Proxy{Busy:"No"}
    p.work()
    p.Busy = "Yes"
    p.work()
}
