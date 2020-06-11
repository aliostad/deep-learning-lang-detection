package errors

import (
	"net/http"
	"strings"
)

type BrokerError struct {
	Status      int
	Description string
}

func NewServiceInstanceAlreadyExists(UUID string) BrokerError {
	return BrokerError{
		Status:      http.StatusConflict,
		Description: "Service instance " + UUID + " already exists",
	}
}

func NewServiceInstanceGone(UUID string) BrokerError {
	return BrokerError{
		Status:      http.StatusGone,
		Description: "Service instance " + UUID + " is gone",
	}
}

func NewBadRequest(Description string) BrokerError {
	return BrokerError{
		Status:      http.StatusBadRequest,
		Description: Description,
	}
}

func NewBrokerError(statusCode int, Description string) BrokerError {
	return BrokerError{
		Status:      statusCode,
		Description: Description,
	}
}

func (e BrokerError) Error() string {
	return e.Description
}

type Errors []error

func (es Errors) Error() string {
	s := make([]string, len(es))
	for i, e := range es {
		s[i] = e.Error()
	}
	return strings.Join(s, "\n")
}
