package share

import (
	"net/http"

	"github.com/gorilla/mux"
	"github.com/koffeinsource/kaffeeshare/data"
	"github.com/koffeinsource/kaffeeshare/share"
	"github.com/koffeinsource/kaffeeshare/targets/startpage"
)

// JSON understood by the extensions
var (
	statusOk    = []byte("{\"status\":\"ok\"}")
	statusError = []byte("{\"status\":\"error\"}")
)

// DispatchJSON receives an extension json request
func DispatchJSON(w http.ResponseWriter, r *http.Request) {
	con := data.MakeContext(r)

	// get namespace
	namespace := mux.Vars(r)["namespace"]
	if namespace == "" {
		startpage.Dispatch(w, r)
		return
	}

	shareURL := r.URL.Query().Get("url")

	if err := share.URL(shareURL, namespace, con); err != nil {
		con.Log.Errorf("Error while sharing an URL. URL: %v. Error: %v", shareURL, err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.Write(statusOk)
}
