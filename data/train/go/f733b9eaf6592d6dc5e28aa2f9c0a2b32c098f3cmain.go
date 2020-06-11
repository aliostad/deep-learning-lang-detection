package main

import (
	"fmt"
	consistent "stathat.com/c/consistent"
	"strconv"
	"strings"
	"github.com/quexer/utee"
	"sync"
)
const(
	HASH_BASE_SIZE = 100
	HASH_KEY_SEPARATOR = ","
)

type Connector struct {
	Id   string
	Data []string
	Weight int
}

func (p *Connector) Append(val string) {
	p.Data = append(p.Data, val)
}



func (p *Connector) checkAndReHash(c *consistent.Consistent ) {
	DataNew:=make([]string, 0)
	for _,dvId := range p.Data {
		k, err := c.Get(dvId)
		if err != nil {
			fmt.Println(err)
		}
		id := strings.Split(k, HASH_KEY_SEPARATOR)[0]
		if p.Id != id {
			RouteAndDispatch(dvId)
		}else{
			DataNew = append(DataNew,dvId)
		}
	}
	p.Data = DataNew
}

var (
	m = map[string]*Connector{}
	c = consistent.New()
)

func main() {
	AddConnector("127.0.0.1:6000",1)
	AddConnector("127.0.0.2:6000",1)
	AddConnector("127.0.0.3:6000",1)
	fmt.Println(c.Members())
	fmt.Println(m)
	PrintMap()
	for i := 0; i < 10; i++ {
		uuid := strconv.Itoa(i)
		RouteAndDispatch(uuid)
	}
	PrintMap()

	for i := 10; i < 100; i++ {
		uuid := strconv.Itoa(i)
		RouteAndDispatch(uuid)
	}
	PrintMap()
	for i := 100; i < 1000; i++ {
		uuid := strconv.Itoa(i)
		RouteAndDispatch(uuid)
	}
	PrintMap()
	for i := 1000; i < 10000; i++ {
		uuid := strconv.Itoa(i)
		RouteAndDispatch(uuid)
	}
	PrintMap()
	for i := 10000; i < 100000; i++ {
		uuid := strconv.Itoa(i)
		RouteAndDispatch(uuid)
	}
	PrintMap()
	RemoveReDispatch("127.0.0.1:6000",1)
	PrintMap()
	AddReDispatch("127.0.0.1:6000",1)
	PrintMap()
	t :=utee.Tick()
	for i := 100000; i < 200000; i++ {
		uuid := strconv.Itoa(i)
		RouteAndDispatch(uuid)
	}
	fmt.Println("route ",100000," spend ",utee.Tick()-t," msec")
	t =utee.Tick()



	var wg sync.WaitGroup

	route := func(id string){
		defer wg.Done()
		RouteAndDispatch(id )
	}

	for i := 0; i < 10000000; i++ {
		uuid := strconv.Itoa(i)
		wg.Add(1)
		go route(fmt.Sprint("hello",uuid) )
	}
	wg.Wait()
	fmt.Println("route ",10000000," spend ",utee.Tick()-t," msec")
}

func AddConnector(id string,weight int) {
	if(weight<0){
		weight=0
	}
	m[id] = &Connector{
		Id:   id,
		Data: make([]string, 0),
		Weight:weight,
	}
	for i:=0;i<weight*HASH_BASE_SIZE;i++{
		idHash := fmt.Sprint(id, HASH_KEY_SEPARATOR,i)
		c.Add(idHash)
	}
}

func RouteAndDispatch(dvId string) {
	k, err := c.Get(dvId)
	if err != nil {
		fmt.Println(err)
	}
	id := strings.Split(k, HASH_KEY_SEPARATOR)[0]
	c := m[id]
	c.Append(dvId)
}


func RemoveReDispatch(id string,weight int){
	fmt.Println("remove and Dispatch")
	data :=m[id].Data
	delete(m,id)
	for i:=0;i<weight*HASH_BASE_SIZE;i++{
		idHash := fmt.Sprint(id, HASH_KEY_SEPARATOR,i)
		c.Remove(idHash)
	}
	for _,v := range data {
		RouteAndDispatch(v)
	}
}

func AddReDispatch(id string,weight int){
	fmt.Println("add and Dispatch")
	AddConnector(id ,weight )
	for _, v := range m {
		v.checkAndReHash(c)
	}
}



func PrintMap() {
	fmt.Println("==============================")
	total :=0
	for k, v := range m {
		fmt.Println("@k:", k, "@v:", len(v.Data) )
		total +=len(v.Data)
	}
	fmt.Println("current total:",total)
	fmt.Println("==============================")
}

