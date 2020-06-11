package main

import (
	"fmt"
)

// post request
type UserPostRequest struct {
	Name               *string `json:"name" validate:"nonzero"` // required, but no defaults
	Age                *uint   `json:"age"`                     // optional
	Address            *string `json:"address"`                 // optional
	FavoriteInstrument string  `json:"favoriteInstrument"`      // required, uses defaults
	FavoriteColor      *string `json:"favoriteColor"`           // required, uses custom defaults
}

// model
type User struct {
	Name               string  `json:"name" validate:"nonzero"`            // required
	Age                *uint   `json:"age,omitempty" validate:"min=1"`     // optional
	Address            *string `json:"address,omitempty" validate:"min=1"` // optional
	FavoriteInstrument string  `json:"favoriteInstrument"`                 // required
	FavoriteColor      string  `json:"favoriteColor" validate:"nonzero"`   // required
}

func main() {
	// unmarshalling
	var postRequest UserPostRequest
	if err := json.NewDecoder(jsonByteSlice).Decode(&postRequest); err != nil {

	}

	if errs := validator.Validate(postRequest); errs != nil {

	}

	user.Name = *postRequest.Name
	user.Age = postRequest.Age
	user.Address = postRequest.Address
	user.FavoriteInstrument = postRequest.FavoriteInstrument
	user.FavoriteColor = "blue"

	if postRequest.FavoriteColor != nil {
		user.FavoriteColor = *postRequest.FavoriteColor
	}

	if errs := validator.Validate(user); errs != nil {

	}

	// marshalling
	if jsonByteSlice, err := marshal(object); err != nil {

	}

	// validation
	if errs := validator.Validate(user); errs != nil {

	}
}
