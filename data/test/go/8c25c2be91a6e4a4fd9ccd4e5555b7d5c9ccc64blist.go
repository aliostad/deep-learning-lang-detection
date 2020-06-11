package main

import (
	"fmt"

	"strings"

	"github.com/mmm888/exchange-api-go"
)

type List struct{}

func (l *List) Help() string {
	return "Usage: otoi list"
}

func (l *List) Run(args []string) int {
	fields := []string{
		"instrument",
		"displayName",
	}

	d := new(exchange.OANDAPairList)
	d.SetData(nil, fields)
	data := d.GetData()

	list := make([]string, 0, 20)
	for _, v := range data.Instruments {
		list = append(list, v.Instrument)
	}
	fmt.Println(strings.Join(list, " "))

	return 0
}

func (l *List) Synopsis() string {
	return "Show exchange list"
}
