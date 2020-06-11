package util

import (
	"net/http"
)

const (
	_NOT_FOUND    = "The requested resource does not exist"
	_SERVER_ERROR = "Oops, there was a server error"
)

// Write success sends the client the specified response with a 200 status
func WriteSuccess(w http.ResponseWriter, response []byte) {
	w.WriteHeader(http.StatusOK)
	w.Write(response)
}

// WriteNoFound sends the client an error message with a status of 404
func WriteNotFound(w http.ResponseWriter) {
	w.WriteHeader(http.StatusNotFound)
	w.Write([]byte(_NOT_FOUND))
}

// WriteServerError sends the client an error message with a status of 500
func WriteServerError(w http.ResponseWriter) {
	w.WriteHeader(http.StatusInternalServerError)
	w.Write([]byte(_SERVER_ERROR))
}
