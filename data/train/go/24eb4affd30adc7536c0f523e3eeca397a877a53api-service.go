package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/davidwalter0/k8s-bldr-api/dispatch"
	"github.com/go-kit/kit/endpoint"
	httptransport "github.com/go-kit/kit/transport/http"
	"golang.org/x/net/context"
	"log"
	"net/http"
	"strconv"
)

type Service interface {
	Request(string) (string, error)
}

type service struct{}

func (service) Request(request *dispatch.Request) (response string, err error) {
	if request == nil {
		return "", ErrorEmpty
	}
	log.Printf("%v\n", request)
	s := fmt.Sprintf("%v\n", request)
	return s, err
}

func main() {
	ctx := context.Background()
	svc := service{}

	handler := httptransport.NewServer(
		ctx,
		makeEndpoint(svc),
		decodeRequest,
		encodeResponse,
	)
	http.Handle("/api/v1/exec", handler)
	http.Handle("/api/v0.1/exec", handler)
	http.Handle("/", handler)
	port := strconv.Itoa(int(*flags.Port))
	log.Fatal(http.ListenAndServe(":"+port, nil))
}

var exitExecError int = 3
var exitNormal int = 0

func makeEndpoint(svc service) endpoint.Endpoint {
	var exit int
	return func(ctx context.Context, requestInterface interface{}) (interface{}, error) {
		request := requestInterface.(dispatch.Request)
		if *debug {
			dispatch.Info.Println(request)
			dispatch.Plain.Printf("\n------------------------------------------------------------------------\n")
			dispatch.Plain.Println(ctx)
			dispatch.Plain.Printf("\n------------------------------------------------------------------------\n")
			dispatch.Plain.Println(request)
			dispatch.Plain.Printf("\n------------------------------------------------------------------------\n")
			dispatch.Plain.Println("Service\n", svc)
			dispatch.Plain.Printf("\n------------------------------------------------------------------------\n")
			dispatch.MapRecursePrint(request)
			dispatch.Plain.Printf("------------------------------------------------------------------------\n")
		}
		v, err := svc.Request(&request)
		if err != nil {
			if *debug {
				dispatch.Info.Println(v)
				dispatch.Info.Printf("ctx %v\n", ctx)
			}
			response := dispatch.NewResponse("API Call from /api/v1/exec")
			response.Append(request.Spec[0].Name, err, exitExecError, "", "")
			return response, nil
		}
		if *debug {
			dispatch.Info.Println(v)
		}
		requestResponse := dispatch.Request(request)
		response := dispatch.NewResponse("API Call from /api/v1/exec")
		exit, err, response = dispatch.ApiDispatch(&requestResponse, response.Filename, *debug, *verbose)
		return response, err
	}
}

func decodeRequest(r *http.Request) (interface{}, error) {
	var request dispatch.Request

	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		dispatch.Info.Printf("encodeResponse %v\n%v\n", r, request)
		return nil, err
	}

	if *debug {
		dispatch.Info.Printf("%v\n", request)
	}
	dispatch.Info.Printf("encodeResponse %v\n%v\n", r, request)
	return request, nil
}

func encodeResponse(w http.ResponseWriter, response interface{}) error {
	dispatch.Info.Printf("encodeResponse %v\n%v\n", w, response)
	if *debug {
		dispatch.Info.Printf("encodeResponse %v\n%v\n", w, response)
	}
	return json.NewEncoder(w).Encode(response)
}

var ErrorEmpty = errors.New("empty string")
var ErrorInvalidRequest = errors.New("Invalid Request")
