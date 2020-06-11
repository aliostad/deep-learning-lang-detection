package moody

import (
	"context"
	"log"
)

// Serve serves Pub/Sub broker.
func Serve(ctx context.Context) {
	cfg := ConfigFromContext(ctx)

	var broker Broker
	log.Printf("Connecting redis server: %s", cfg.RedisURI)
	broker, err := NewRedisBroker(ctx)
	if err != nil {
		log.Fatal(err)
	}
	defer broker.Close()

	_, err = broker.InitializeTopics(ctx, cfg.Topics)
	if err != nil {
		log.Fatal(err)
	}

	errChan := make(chan error)
	go broker.SubscribeLocal(ctx, errChan)
	go broker.SubscribeCloud(ctx, errChan)
	for {
		select {
		case err := <-errChan:
			log.Fatal(err)
		}
	}
}
