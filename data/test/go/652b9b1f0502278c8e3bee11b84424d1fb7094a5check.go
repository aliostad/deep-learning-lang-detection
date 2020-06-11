package check

import (
	"net/http"

	"github.com/gorilla/mux"
	"github.com/koffeinsource/notreddit/data"
	"github.com/koffeinsource/notreddit/targets/startpage"

	"appengine"
)

// JSON understood by the front page
var (
	statusOk    = []byte("{\"status\":\"ok\"}")
	statusError = []byte("{\"status\":\"error\"}")
	statusInUse = []byte("{\"status\":\"use\"}")
)

// DispatchJSON executes all commands for the www target
func DispatchJSON(w http.ResponseWriter, r *http.Request) {
	c := appengine.NewContext(r)

	// get namespace
	namespace := mux.Vars(r)["namespace"]
	if namespace == "" {
		startpage.Dispatch(w, r)
		return
	}

	empty, err := data.NamespaceIsEmpty(c, namespace)

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
