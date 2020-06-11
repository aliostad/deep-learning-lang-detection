package clinic

import (
	"fmt"
	"github.com/gorilla/mux"
	"github.com/shwoodard/jsonapi"
	"net/http"
	"strconv"
)

func GetAllPets(w http.ResponseWriter, r *http.Request) {
	jsonapiRuntime := jsonapi.NewRuntime().Instrument("/")
	w.WriteHeader(200)
	w.Header().Set("Content-Type", "application/vnd.api+json")
	pets := AllPets()
	if err := jsonapiRuntime.MarshalManyPayload(w, pets); err != nil {
		http.Error(w, err.Error(), 500)
	}
}

func GetOnePet(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		fmt.Println("Invalid pet id")
		return
	}
	jsonapiRuntime := jsonapi.NewRuntime().Instrument("/")
	w.WriteHeader(200)
	w.Header().Set("Content-Type", "application/vnd.api+json")
	pet := ReadPet(&Pet{Id: id})
	if err := jsonapiRuntime.MarshalOnePayload(w, pet); err != nil {
		http.Error(w, err.Error(), 500)
	}
}

func CreateNewPet(w http.ResponseWriter, r *http.Request) {
	jsonapiRuntime := jsonapi.NewRuntime().Instrument("/")
	pet := new(Pet)
	if err := jsonapiRuntime.UnmarshalPayload(r.Body, pet); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	NewPet(pet)
	w.WriteHeader(201)
	w.Header().Set("Content-Type", "application/vnd.api+json")
}

func UpdateExistingPet(w http.ResponseWriter, r *http.Request) {
	jsonapiRuntime := jsonapi.NewRuntime().Instrument("/")
	pet := new(Pet)
	if err := jsonapiRuntime.UnmarshalPayload(r.Body, pet); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	UpdatePet(pet)
	if err := jsonapiRuntime.MarshalOnePayload(w, pet); err != nil {
		http.Error(w, err.Error(), 500)
	}
	w.WriteHeader(201)
	w.Header().Set("Content-Type", "application/vnd.api+json")
}
