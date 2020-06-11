package startpage

import (
	"html/template"
	"net/http"

	"github.com/koffeinsource/kaffeebot/config"
)

var templateWWW = template.Must(template.ParseFiles("template/base.html", "targets/startpage/template/startpage.html"))

type startpageTemplateValues struct {
	URL string
}

// Dispatch just provides the start page template
func Dispatch(w http.ResponseWriter, r *http.Request) {
	var value startpageTemplateValues
	value.URL = config.KaffeeshareURL
	if err := templateWWW.Execute(w, value); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
