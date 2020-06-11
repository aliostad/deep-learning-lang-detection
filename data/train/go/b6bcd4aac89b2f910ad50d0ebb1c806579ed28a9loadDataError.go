package errors

import (
	"fmt"
)

// LoadDataError is for errors during loading data
type LoadDataError struct {
	URL        string
	Message    string
	InnerError error
}

func (e LoadDataError) Error() string {
	if e.Message == "" {
		return fmt.Sprintf("Could load data for URL: %s", e.URL)
	}
	return fmt.Sprintf("%s: %s", e.Message, e.URL)

}

// NewLoadDataError creates LoadDataError
func NewLoadDataError(url string, message string, inner error) LoadDataError {
	return LoadDataError{URL: url, InnerError: inner}
}
