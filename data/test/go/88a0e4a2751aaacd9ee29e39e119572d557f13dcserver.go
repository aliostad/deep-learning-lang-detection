package agent

import (
	"github.com/Shopify/Sarama"
	"github.com/dvsekhvalnov/sync4kafka/utils"
)

type PartitionInfo struct {
	Topic string
	ID    int32
}

type KafkaPartition struct {
	Topic    string
	Metadata *sarama.PartitionMetadata
}

type Server struct {
	broker *sarama.Broker

	//list of (topic, parition metadata), filtered for given broker host
	partitions []KafkaPartition
}

func (server *Server) Partitions() []KafkaPartition {
	return server.partitions
}

func FetchOffsets(ctx *globals, partition *PartitionInfo) int64 {
	if broker, err := ctx.openBroker(); err == nil || err == sarama.ErrAlreadyConnected {

		req := &sarama.OffsetFetchRequest{
			Version:       1,
			ConsumerGroup: ctx.cfg.ConsumerGroup,
		}

		req.AddPartition(partition.Topic, partition.ID)

		resp, err := broker.FetchOffset(req)

		if err != nil {
			Log.Printf("[ERROR] Unable to fetch offsets from Kafka, err=%v\n", err)
			return -1
		} else {
			block := resp.Blocks[partition.Topic][partition.ID]

			if block != nil && block.Err == sarama.ErrNoError {
				return block.Offset
			} else {
				return -1
			}
		}
	} else {
		Log.Printf("[ERROR] Unable to open broker connection to: %v. Err=%v", broker.Addr(), err)
	}

	return -1
}

func MarkOffsets(ctx *globals, offset int64, topic string, partition int32) {
	if broker, err := ctx.openBroker(); err == nil || err == sarama.ErrAlreadyConnected {

		req := &sarama.OffsetCommitRequest{
			Version:                 2,
			ConsumerGroup:           ctx.cfg.ConsumerGroup,
			ConsumerGroupGeneration: -1,
			ConsumerID:              "",
			RetentionTime:           -1,
		}

		req.AddBlock(topic, partition, offset, 0, "127.0.0.1") //meta can be json {"broker", "agent-ip", "commit-time"}

		_, err := broker.CommitOffset(req)

		//TODO: examine resp.Errors map for specific topic/partition errors
		if err != nil {
			Log.Printf("[ERROR] Unable to commit offsets to Kafka, err=%v\n", err)
		} else {
			Log.Println("Successully committed offsets")
		}
	} else {
		Log.Printf("[ERROR] Unable to open broker connection to: %v. Err=%v", broker.Addr(), err)
	}
}

func RefreshMetadata(ctx *globals) *Server {

	if broker, err := ctx.openBroker(); err == nil || err == sarama.ErrAlreadyConnected {
		response, err := broker.GetMetadata(&sarama.MetadataRequest{})

		if err != nil {
			//TODO: copy some code from Sarama client
			panic(err)
		}

		result := &Server{
			broker:     broker,
			partitions: make([]KafkaPartition, 0),
		}

		for _, topic := range response.Topics {
			//TODO: handle topic.Err here, copy some code from Sarama client
			// fmt.Printf("  - %v\n", topic.Name)

			for _, partition := range topic.Partitions {

				//filter only partitions managed by local broker
				if partition.Leader == broker.ID() {
					result.partitions = append(result.partitions, KafkaPartition{Topic: topic.Name, Metadata: partition})
				}
			}
		}

		return result
	} else {
		Log.Printf("[ERROR] Unable to refresh broker metadata at: %v. Err=%v", broker.Addr(), err)
		//TODO: panic(err)
		return nil
	}
}

func DiscoverServer(url string, cfg *Config) *Server {

	_, port := utils.SplitUrl(url, "9092")

	var localBrokerUrls []string

	server := &Server{}

	if cfg.BrokerAdvertisedUrl == "" {

		//discover network interfaces
		nodeIps, err := utils.FindIPs()

		if err != nil {
			panic(err)
		}

		localBrokerUrls = utils.AddPort(nodeIps, port)

		Log.Printf("Possible local broker urls: %v\n", localBrokerUrls)
	} else {
		localBrokerUrls = make([]string, 1)
		localBrokerUrls[0] = cfg.BrokerAdvertisedUrl
		Log.Printf("Using advertised local broker url: %v\n", localBrokerUrls)
	}

	broker := sarama.NewBroker(url)

	err := broker.Open(cfg.Config)

	if err != nil {
		panic(err)
	}

	defer broker.Close()

	request := sarama.MetadataRequest{}
	response, err := broker.GetMetadata(&request)

	if err != nil {
		//TODO: copy some code from Sarama client
		panic(err)
	}

	for _, broker := range response.Brokers {
		addr := broker.Addr()

		Log.Println("possible broker:", addr)
		if utils.Contains(localBrokerUrls, addr) {
			server.broker = broker

			Log.Println("Discovered local broker with ID=", server.broker.ID(), ", url=", server.broker.Addr())

			return server
		}
	}

	panic("Unable to discover broker.")
}
