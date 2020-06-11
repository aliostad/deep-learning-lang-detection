package proxy

import (
	"fmt"
	"log"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"
)

func Run(serviceConfig *ServiceConfig, lifetime int) {

	var mutex sync.Mutex

	brokers := map[BrokerConfig]*AmqpConnection{}
	routes := map[BrokerConfig]map[RouteConfig]*Route{}

	var err error
	for _, routeConfig := range serviceConfig.Routes {

		brokerConfig := serviceConfig.Brokers[routeConfig.Broker]
		broker, hasBroker := brokers[brokerConfig]

		if !hasBroker {
			broker, err = NewAmqpConnection(&brokerConfig)
			if err != nil {
				break
			}
			brokers[brokerConfig] = broker
		}

		brokerRoutes, hasBrokerRoutes := routes[brokerConfig]

		if !hasBrokerRoutes {
			brokerRoutes = map[RouteConfig]*Route{}
			routes[brokerConfig] = brokerRoutes
		}

		brokerRoutes[routeConfig] = nil

	}

	// Note: "closing" here is unexpected termination (connection loss), "shutdown" is the result of graceful exit

	for brokerConfig, brokerRoutes := range routes {

		broker := brokers[brokerConfig]
		//log.Printf("Broker: %v", broker)

		// subscribe for broker connection open
		op := broker.NotifyOpen(make(chan *AmqpConnection))

		go func(broker *AmqpConnection, brokerRoutes map[RouteConfig]*Route) {
			
			inShutdown := broker.NotifyShutdown(make(chan struct{}, 1));
			
			for range op {
				
				// re-create routes every time when broker connection is opened

				mutex.Lock()

				for routeConfig := range brokerRoutes {

					// create route
					workerConfig := serviceConfig.Workers[routeConfig.Worker]
					route, err := CreateRoute(broker, &routeConfig, workerConfig)

					if err != nil {
						// TODO handle route creating errors
						log.Printf("%s", err)
					}

					// save new route to map
					brokerRoutes[routeConfig] = route

				}

				log.Printf("Broker routes created: %v", broker)

				mutex.Unlock()
				
				for routeConfig := range brokerRoutes {

					route := brokerRoutes[routeConfig]
					if route != nil {
						
						log.Printf("Wait for route: %v", route.config)
						route.WaitClosed()
						log.Printf("Wait for route: closed: %v", route.config)

					}

				}
				
				select {
				case <-inShutdown:
					// do nothing, exit when "op" channel closed 
				default:
					// all routes closed when disconnected, re-open connection
					broker.Open()
				}
				
			}

			log.Printf("Broker finished: %v", broker)
			// should finish when op channel closed on shutdown

		}(broker, brokerRoutes)

		broker.Open()

	}

	log.Printf("Brokers: %v", brokers)
	log.Printf("Routes: %v", routes)

	if err != nil {
		log.Fatalf("%s", err)
	}

	waitShutdown := make(chan error)

	// Shutdown on sigterm
	sysigs := make(chan os.Signal, 1)
	signal.Notify(sysigs, syscall.SIGINT, syscall.SIGTERM)

	go func(sigs chan os.Signal, done chan error) {
		sig := <-sigs
		log.Printf("Got shutdown signal %v", sig)
		done <- nil
	}(sysigs, waitShutdown)

	go func(done chan error) {
		lifetimeShutdown(lifetime)
		log.Printf("Shutdown on lifetime timeout: %v sec", lifetime)
		done <- nil
	}(waitShutdown)

	// wait for shutdown
	<-waitShutdown

	mutex.Lock()
	shutdown(routes, brokers)
	mutex.Unlock()

}

func shutdown(routes map[BrokerConfig]map[RouteConfig]*Route, brokers map[BrokerConfig]*AmqpConnection) {

	var err error

	err = shutdownRoutes(routes)

	if err != nil {
		log.Fatalf("%s", err)
	}

	err = shutdownBrokers(brokers)

	if err != nil {
		log.Fatalf("%s", err)
	}

	log.Println("Shutdown success")

	// TODO debug
	time.Sleep(time.Second * 100)
}

func shutdownRoutes(routes map[BrokerConfig]map[RouteConfig]*Route) (err error) {

	for _, brokerRoutes := range routes {

		for _, route := range brokerRoutes {

			if route != nil {

				route.Shutdown()

			}

		}

	}

	return err

}

func shutdownBrokers(brokers map[BrokerConfig]*AmqpConnection) (err error) {

	for _, broker := range brokers {

		if err = broker.Shutdown(); err != nil {
			err = fmt.Errorf("Shutdown error: %s", err)
			break
		}

	}

	return err

}

func lifetimeShutdown(lifetime int) {

	if lifetime > 0 {
		time.Sleep(time.Second * time.Duration(lifetime))
	} else {

		for {
			time.Sleep(time.Second)
		}

	}

}
