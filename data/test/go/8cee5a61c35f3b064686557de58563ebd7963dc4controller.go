package main

import (
	"encoding/json"
	"fmt"
	"github.com/go-martini/martini"
	"net/http"
)

type Manifest struct {
	Type    string `json:"type"`
	Id      string `json:"id"`
	Name    string `json:"name"`
	Version string `json:"version"`
	// Todo: make a basic capabilities type.
	Capabilities []map[string]interface{} `json:"capabilities"`
}

type ManifestAcknoledgement struct {
	Type string `json:"type"`
	Id   string `json:"id"`
	// Todo: Change this to use UUIDs.
	Capabilities []string `json:"capabilities"`
}

type ManifestListRequest struct {
	Type string `json:"type"`
	Id   string `json:"id"`
}

type ManifestListing struct {
	Type      string     `json:"type"`
	Id        string     `json:"id"`
	Manifests []Manifest `json:"manifests"`
}

type Dispatch struct {
	Type       string        `json:"type"`
	Id         string        `json:"id"`
	Dispatches []interface{} `json:"dispatches"`
}

type DispatchAcknowledgement struct {
	Success bool `json:"success"`
}

type OutputByteStreamDispatch struct {
	Id      string `json:"id"`
	Message string `json:"message"`
}

type DispatchPoll struct {
	Type         string   `json:"type"`
	Id           string   `json:"id"`
	Capabilities []string `json:"capabilities"`
}

var registeredManifests map[string]Manifest = make(map[string]Manifest)
var dispatches map[string][]Dispatch = make(map[string][]Dispatch)

func main() {
	m := martini.Classic()
	m.Get("/", func() string {
		return "Whiskers server here! Nice to meet you. (Please connect with a client using the HTTP REST method.)"
	})
	m.Post("/manifest/declaration", declareNewManifest)
	m.Post("/manifest/list/request", listManifests)
	m.Post("/dispatch", dispatch)
	m.Post("/dispatch/poll", pollDispatches)
	m.Run()
}

func declareNewManifest(res http.ResponseWriter, req *http.Request) {
	var manifest Manifest
	err := json.NewDecoder(req.Body).Decode(&manifest)
	if err != nil {
		panic(err)
	}
	fmt.Printf("Got a manifest for %s\n", manifest.Name)
	registeredManifests[manifest.Id] = manifest
	ack := ManifestAcknoledgement{"manifest/acknowledgement", manifest.Id, make([]string, 0)}
	res.WriteHeader(http.StatusOK)
	err = json.NewEncoder(res).Encode(ack)
	if err != nil {
		panic(err)
	}
}

func listManifests(res http.ResponseWriter, req *http.Request) {
	var listReq ManifestListRequest
	err := json.NewDecoder(req.Body).Decode(&listReq)
	if err != nil {
		panic(err)
	}
	fmt.Printf("Manifest list requested by %s\n", listReq.Id)
	res.WriteHeader(http.StatusOK)
	listing := ManifestListing{"manifest/list", listReq.Id, []Manifest{}}
	for _, manifest := range registeredManifests {
		listing.Manifests = append(listing.Manifests, manifest)
	}
	err = json.NewEncoder(res).Encode(listing)
	if err != nil {
		panic(err)
	}
}

func dispatch(res http.ResponseWriter, req *http.Request) {
	var dispatch Dispatch
	err := json.NewDecoder(req.Body).Decode(&dispatch)
	if err != nil {
		panic(err)
	}
	fmt.Printf("Got a dispatch for %s\n", dispatch.Id)
	if _, ok := dispatches[dispatch.Id]; !ok {
		dispatches[dispatch.Id] = []Dispatch{}
	}
	dispatches[dispatch.Id] = append(dispatches[dispatch.Id], dispatch)
	err = json.NewEncoder(res).Encode(DispatchAcknowledgement{true})
	if err != nil {
		panic(err)
	}
}

func pollDispatches(res http.ResponseWriter, req *http.Request) {
	var poll DispatchPoll
	err := json.NewDecoder(req.Body).Decode(&poll)
	if err != nil {
		panic(err)
	}
	if _, ok := dispatches[poll.Id]; !ok {
		err = json.NewEncoder(res).Encode(Dispatch{"dispatch", poll.Id, make([]interface{}, 0)})
		return
	}
	providerDispatches := make([]interface{}, 0)
	for _, providerDispatch := range dispatches[poll.Id] {
		for _, dispatch := range providerDispatch.Dispatches {
			providerDispatches = append(providerDispatches, dispatch)
		}
	}
	dispatches[poll.Id] = []Dispatch{}
	err = json.NewEncoder(res).Encode(Dispatch{"dispatch", poll.Id, providerDispatches})
	if err != nil {
		panic(err)
	}
}

func notImplemented() (int, string) {
	return http.StatusNotImplemented, "Not implemented"
}
