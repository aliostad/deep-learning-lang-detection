/*
    The MIT License (MIT)
    
	Copyright (c) 2015 myhug.cn and zhouwench (zhouwench@gmail.com)
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
*/
package kmonitor

import (
		"github.com/dzch/go-utils/logger"
		"github.com/Shopify/sarama"
		"time"
		"fmt"
		"errors"
	   )

var (
		gUpdateBrokerOffsetInterval = 10*time.Second
	)

type BrokerOffset struct {
	topic string
	partition int32
	offset int64
}

type Broker struct {
	cc *ClusterConfig
	fatalErrorChan chan error
	brokerIdValChan chan *BrokerIdVal
	brokerOffsetChan chan *BrokerOffset
	brokerConfig *sarama.Config
	client sarama.Client
}

func newBroker(c *Cluster) (*Broker, error) {
    b := &Broker{
		cc: c.cc,
		brokerIdValChan: c.brokerIdValChan,
		fatalErrorChan: c.fatalErrorChan,
		brokerOffsetChan: c.brokerOffsetChan,
	}
	err := b.init()
	if err != nil {
		return nil, err
	}
	return b, nil
}

func (b *Broker) init() error {
    err := b.initBrokerConfig()
	if err != nil {
		return err
	}
	return nil
}

func (b *Broker) initBrokerConfig() error {
	b.brokerConfig = sarama.NewConfig()
	b.brokerConfig.Metadata.RefreshFrequency = 10*time.Second
	b.brokerConfig.Consumer.Return.Errors = true
	return nil
}

func (b *Broker) run() {
	for {
		select {
			case brokerIdVal := <-b.brokerIdValChan:
				b.updateBrokerClient(brokerIdVal)
			case <-time.After(gUpdateBrokerOffsetInterval):
				b.updateBrokerOffset()
		}
	}
}

func (b *Broker) updateBrokerClient(brokerIdVal *BrokerIdVal) {
	if b.client != nil && b.client.Closed() == false {
		b.client.Close()
	}
	b.client = nil
	var err error
	b.client, err = sarama.NewClient([]string{fmt.Sprintf("%s:%d", brokerIdVal.Host, brokerIdVal.Port)}, b.brokerConfig)
	if err != nil {
		err = errors.New(fmt.Sprintf("fail to sarama.NewClient: %s", err.Error()))
		logger.Fatal(err.Error())
		b.fatalErrorChan <-err
		return
	}
	logger.Debug("success update broker client: %s:%d", brokerIdVal.Host, brokerIdVal.Port)
}

func (b *Broker) updateBrokerOffset() {
	if b.client == nil || b.client.Closed() {
		logger.Notice("broker.client not ready yet")
		return
	}
	topics, err := b.client.Topics()
	if err != nil {
		logger.Warning("fail to b.client.Topics(): %s", err.Error())
		return
	}
	for _, topic := range topics {
		partitions, err := b.client.Partitions(topic)
		if err != nil {
			logger.Warning("fail to b.client.Partitions(): %s", err.Error())
			continue
		}
		for _, partition := range partitions {
			offset, err := b.client.GetOffset(topic, partition, sarama.OffsetNewest)
			if err != nil {
				logger.Warning("fail to b.client.GetOffset topic=%s, partition=%d, err=%s", topic, partition, err.Error())
				continue
			}
			// TODO: use pool
			b.brokerOffsetChan <-&BrokerOffset {
                topic: topic,
				partition: partition,
				offset: offset,
			}
			logger.Debug("offset: topic=%s, partition=%d, offset=%d", topic, partition, offset)
		}
	}
}

