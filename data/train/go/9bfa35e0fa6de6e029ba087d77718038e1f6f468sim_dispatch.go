package handlers

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/golang/protobuf/proto"
	"github.com/golang/protobuf/ptypes"
	"github.com/utilitywarehouse/json-rpc-proxy/extpoints"
	"github.com/utilitywarehouse/sim-dispatch-api/contracts"
)

const (
	simDispatchRoute  = "simdispatch"
	kafkaProducerHost = "http-kafka-producer:80"
	kafkaTopic        = "OutboundBillSimRequestEvents"
)

type IncomingSimDispatchRequest struct {
	CorrelationToken          string `json:"correlationToken"`
	AccountId                 string `json:"accountId"`
	DestinationAddress        string `json:"destinationAddress"`
	Cli                       string `json:"cli"`
	OldSimNumber              string `json:"oldSimNumber"`
	BankAccountLastFourDigits string `json:"bankAccountLastFourDigits"`
	MobSecurity               string `json:"mobSecurity"`
	DateOfBirth1              string `json:"dateOfBirth1"`
	DateOfBirth2              string `json:"dateOfBirth2"`
}

func init() {
	log.Print("registering sim dispatch handler")
	ok := endpoints.Register(extpoints.Endpoint(func() http.HandlerFunc { return handleSimDispatchRequest }), simDispatchRoute)
	if !ok {
		log.Panicf("handler name: %s failed to register", route)
	}
}

func handleSimDispatchRequest(wr http.ResponseWriter, req *http.Request) {
	requestBody, err := ioutil.ReadAll(req.Body)
	if err != nil {
		http.Error(wr, fmt.Sprintf("error reading request body %v", err), http.StatusBadRequest)
		return
	}

	log.Printf("Processing sim dispatch request: %s", requestBody)

	event, err := getSimDispatchRequested(requestBody)
	if err != nil {
		http.Error(wr, fmt.Sprintf("error generating SimDispatchRequestedEvent %v", err), http.StatusBadRequest)
		return
	}

	buf, err := proto.Marshal(event)
	if err != nil {
		http.Error(wr, fmt.Sprintf("error encoding SimDispatchRequestedEvent %+v", err), http.StatusInternalServerError)
		return
	}

	err = produceSimDispatchRequestedEvent(buf)
	if err != nil {
		http.Error(wr, err.Error(), http.StatusBadGateway)
		return
	}
}

func getSimDispatchRequested(requestBody []byte) (*contracts.Event, error) {
	incomingSimDispatchRequest := &IncomingSimDispatchRequest{}
	err := json.Unmarshal(requestBody, incomingSimDispatchRequest)
	if err != nil {
		return nil, fmt.Errorf("error unmarshaling IncomingSimDispatchRequest %v", err)
	}

	ivrData := &contracts.IvrData{
		BankAccountLastFourDigits: incomingSimDispatchRequest.BankAccountLastFourDigits,
		MobSecurity:               incomingSimDispatchRequest.MobSecurity,
		DateOfBirth1:              incomingSimDispatchRequest.DateOfBirth1,
		DateOfBirth2:              incomingSimDispatchRequest.DateOfBirth2,
	}

	dr := &contracts.SimDispatchRequested{
		AccountId:          incomingSimDispatchRequest.AccountId,
		DestinationAddress: incomingSimDispatchRequest.DestinationAddress,
		Cli:                incomingSimDispatchRequest.Cli,
		OldSimNumber:       incomingSimDispatchRequest.OldSimNumber,
		IvrFields:          ivrData,
	}

	payload, err := ptypes.MarshalAny(dr)
	if err != nil {
		return nil, err
	}
	ev := &contracts.Event{
		CorrelationToken: incomingSimDispatchRequest.CorrelationToken,
		Payload:          payload,
		Version:          "1", // will need to move into contracts
	}
	return ev, nil
}

func produceSimDispatchRequestedEvent(payload []byte) error {
	httpClient := http.Client{}
	producerResponse, err := httpClient.Post(
		fmt.Sprintf("http://%s/produce/%s", kafkaProducerHost, kafkaTopic),
		"application/octet-stream",
		bytes.NewReader(payload),
	)
	if err != nil {
		return fmt.Errorf("error getting response from kafka producer %v", err)
	}
	if producerResponse.StatusCode != 200 {
		return fmt.Errorf(fmt.Sprintf("received non 200 response from kafka producer: %v, %v", producerResponse.StatusCode, producerResponse.Status))
	}
	return nil
}
