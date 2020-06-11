package main

import (
	"fmt"
	"testing"
)

func BenchmarkMutexConfigManager(b *testing.B) {
	buffer := "           "
	conf := &Config{"Hello World"}
	manager := NewMutexConfigManager(conf)
	for n := 0; n < b.N; n++ {
		local := manager.Get()
		fmt.Sprintf(buffer, "%s", local.Message)
	}
}

func BenchmarkChannelConfigManager(b *testing.B) {
	buffer := "           "
	conf := &Config{"Hello World"}
	manager := NewChannelConfigManager(conf)
	for n := 0; n < b.N; n++ {
		local := manager.Get()
		fmt.Sprintf(buffer, "%s", local.Message)
	}
}
