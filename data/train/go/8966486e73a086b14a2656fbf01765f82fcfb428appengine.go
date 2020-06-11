// +build appengine

package main

import (
	"net/http"

	"github.com/gorilla/mux"
	"github.com/koffeinsource/kaffeebot/targets/cron"
	"github.com/koffeinsource/kaffeebot/targets/importer"
	"github.com/koffeinsource/kaffeebot/targets/startpage"
	"github.com/koffeinsource/kaffeebot/targets/task/goodbye"
	"github.com/koffeinsource/kaffeebot/targets/task/updater"
)

var router = mux.NewRouter()

func init() {
	router.HandleFunc("/", startpage.Dispatch)
	router.HandleFunc("/kb/import/post/", importer.DispatchPOST)
	router.HandleFunc("/task/updater/post/", updater.DispatchPOST)
	router.HandleFunc("/task/goodbye/post/", goodbye.DispatchPOST)
	router.HandleFunc("/cron/start_update/", cron.DispatchStartUpdate)
	router.HandleFunc("/cron/delete_failed/", cron.DispatchDeleteFailed)

	http.Handle("/", router)
}
