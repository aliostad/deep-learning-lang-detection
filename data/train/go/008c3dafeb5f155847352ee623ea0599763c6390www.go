package show

import (
	"net/http"
	"text/template"

	"github.com/gorilla/mux"
	"github.com/koffeinsource/notreddit/targets/startpage"
)

type wwwTemplateValues struct {
	Namespace string
}

var templateWWW = template.Must(template.ParseFiles("template/base.html", "targets/show/template/html.html"))

//DispatchWWW returns the HTML view of a namespace
func DispatchWWW(w http.ResponseWriter, r *http.Request) {
	//c := appengine.NewContext(r)

	var value wwwTemplateValues
	value.Namespace = mux.Vars(r)["namespace"]

	if value.Namespace == "" {
		startpage.Dispatch(w, r)
		return
	}

	if err := templateWWW.Execute(w, value); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
