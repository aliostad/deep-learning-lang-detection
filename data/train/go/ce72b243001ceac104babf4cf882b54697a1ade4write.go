package templates

import (
	"fmt"
	"text/template"
)

var writeTemplate = template.Must(
	template.New("write").Parse(writeTemplateText),
)

func CreateWrite(projectName, fullpath string) {
	path := fmt.Sprintf("%s/%s/server/api/write.go", fullpath, projectName)
	writeFile(writeTemplate, path, nil)
}

const writeTemplateText = `package api

import (
	"encoding/json"
	"log"
	"net/http"
)

func Write(w http.ResponseWriter, response Response) {
	w.Header().Set("Content-Type", "application/json")
	if response.Error != nil {
		w.WriteHeader(response.Error.Code)
	} else if response.IsEmpty() {
		w.WriteHeader(http.StatusNoContent)
		return
	}

	b, err := json.Marshal(response)
	if err != nil {
		log.Panicf("api: could not JSON encode response: %s", err)
	}
	w.Write(b)
}
`
