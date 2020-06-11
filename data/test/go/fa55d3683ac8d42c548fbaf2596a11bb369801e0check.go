package check

import (
	"net/http"

	"github.com/gorilla/mux"
	"github.com/koffeinsource/kaffeeshare/data"
	"github.com/koffeinsource/kaffeeshare/targets/startpage"
)

// JSON understood by the front page
var (
	statusOk    = []byte("{\"status\":\"ok\"}")
	statusError = []byte("{\"status\":\"error\"}")
	statusInUse = []byte("{\"status\":\"use\"}")
)

// DispatchJSON is called when a json request with an url is posted
func DispatchJSON(w http.ResponseWriter, r *http.Request) {
	con := data.MakeContext(r)

	// get namespace
	namespace := mux.Vars(r)["namespace"]
	if namespace == "" {
		startpage.Dispatch(w, r)
		return
	}

	empty, err := data.NamespaceIsEmpty(con, namespace)

	if err == nil {

		if empty {
			w.Write(statusOk)
		} else {
			w.Write(statusInUse)
		}

	} else {
		w.Write(statusError)
	}
}
