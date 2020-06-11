package kaffeeshare

import (
	"net/http"

	"github.com/koffeinsource/kaffeeshare/targets/check"
	"github.com/koffeinsource/kaffeeshare/targets/cron"
	"github.com/koffeinsource/kaffeeshare/targets/email"
	"github.com/koffeinsource/kaffeeshare/targets/search"
	"github.com/koffeinsource/kaffeeshare/targets/share"
	"github.com/koffeinsource/kaffeeshare/targets/show"
	"github.com/koffeinsource/kaffeeshare/targets/startpage"
	"github.com/koffeinsource/kaffeeshare/targets/update"

	"github.com/gorilla/mux"
)

var router = mux.NewRouter()

//<domain>/k/twitter/connect/<namespace>
//<domain>/k/twitter/disconnect/<namespace>
//<domain>/k/email/connect/<namespace>
//<domain>/k/share/<namespace> <- extension url

func init() {
	router.StrictSlash(true)

	router.HandleFunc("/", startpage.Dispatch)
	router.HandleFunc("/k/check/json/{namespace}", check.DispatchJSON)

	// should actually be share/get as we don't do json here
	router.HandleFunc("/k/share/json/{namespace}", share.DispatchJSON)
	router.HandleFunc("/k/share/firefox/{namespace}", share.DispatchFirefox)

	router.HandleFunc("/k/update/json/{namespace}", update.DispatchJSON)

	router.HandleFunc("/k/show/json/{namespace}", show.DispatchJSON)
	router.HandleFunc("/k/show/www/{namespace}", show.DispatchWWW)
	router.HandleFunc("/k/show/rss/{namespace}", show.DispatchRSS)

	router.HandleFunc("/c/clear_test/", cron.ClearTest)
	router.HandleFunc("/c/clear_test", cron.ClearTest)

	router.HandleFunc("/t/search/add_to_index", search.DispatchAddToIndex)

	// TODO move to router
	http.HandleFunc("/_ah/mail/", email.DispatchEmail)
	http.Handle("/", router)
}
