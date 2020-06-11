package dispatch

import (
	"encoding/json"
	"encoding/xml"
	"fmt"
	"net/http"
)

const (
	ContentTypeText = "text/plain"
	ContentTypeJson = "application/json"
	ContentTypeXml  = "application/xml"
)

type DispatchResponse struct{ Writer http.ResponseWriter }

// Response "upgrades" the standard http.ResponseWriter to a DispatchResponse.
func Response(w http.ResponseWriter) *DispatchResponse {
	return &DispatchResponse{Writer: w}
}

// Set a status code and halt
func (d *DispatchResponse) Abort(code int) {
	d.Writer.WriteHeader(code)
}

func writeHeaders(w http.ResponseWriter, code int, contentType string) {
	w.Header().Set("Content-Type", contentType)
	w.WriteHeader(code)
}

// Respond with a string with a given format. This also sets the content type
// to "text/plain".
func (d *DispatchResponse) String(code int, format string, data ...interface{}) error {
	writeHeaders(d.Writer, code, ContentTypeText)

	var err error
	if len(data) > 0 {
		_, err = d.Writer.Write([]byte(fmt.Sprintf(format, data...)))
	} else {
		_, err = d.Writer.Write([]byte(format))
	}
	return err
}

// Respond with a JSON object with the correct Content-Type
func (d *DispatchResponse) JSON(code int, data interface{}) error {
	writeHeaders(d.Writer, code, ContentTypeJson)
	encoder := json.NewEncoder(d.Writer)
	return encoder.Encode(data)
}

// Respond with a XML ofbject with the corrent Content-Type.
func (d *DispatchResponse) XML(code int, data interface{}) error {
	writeHeaders(d.Writer, code, ContentTypeXml)
	encoder := xml.NewEncoder(d.Writer)
	return encoder.Encode(data)
}

// Redirect to a given URL
func (d *DispatchResponse) Redirect(code int, location string) error {
	d.Writer.Header().Set("Location", location)
	d.Writer.WriteHeader(code)
	return nil
}

// Shortcut for returning a 404
func (d *DispatchResponse) NotFound() {
	d.Abort(http.StatusNotFound)
}
