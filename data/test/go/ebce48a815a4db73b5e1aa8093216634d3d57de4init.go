package rest

import (
	"net/http"
	"sort"

	"github.com/ottemo/foundation/api"
	"github.com/ottemo/foundation/env"

	"github.com/julienschmidt/httprouter"
)

// init performs the package self-initialization routine
func init() {
	var _ api.InterfaceApplicationContext = new(DefaultRestApplicationContext)

	instance := new(DefaultRestService)

	if err := api.RegisterRestService(instance); err != nil {
		_ = env.ErrorDispatch(err)
	}
	env.RegisterOnConfigIniStart(instance.startup)
}

// service pre-initialization stuff
func (it *DefaultRestService) startup() error {

	it.ListenOn = ":3000"
	if iniConfig := env.GetIniConfig(); iniConfig != nil {
		if iniValue := iniConfig.GetValue("rest.listenOn", it.ListenOn); iniValue != "" {
			it.ListenOn = iniValue
		}
	}

	it.Router = httprouter.New()

	it.Router.PanicHandler = func(w http.ResponseWriter, r *http.Request, params interface{}) {
		w.WriteHeader(http.StatusNotFound)
		if _, err := w.Write([]byte("page not found")); err != nil {
			_ = env.ErrorDispatch(err)
		}
	}

	it.Router.GET("/", it.rootPageHandler)

	if err := api.OnRestServiceStart(); err != nil {
		_ = env.ErrorDispatch(err)
	}

	return nil
}

// rootPageHandler Display a list of the registered endpoints
func (it *DefaultRestService) rootPageHandler(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
	newline := []byte("\n")

	w.Header().Add("Content-Type", "text/plain")
	w.WriteHeader(http.StatusOK)

	if _, err := w.Write([]byte("Ottemo REST API:")); err != nil {
		_ = env.ErrorDispatch(err)
	}
	if _, err := w.Write(newline); err != nil {
		_ = env.ErrorDispatch(err)
	}
	if _, err := w.Write([]byte("----")); err != nil {
		_ = env.ErrorDispatch(err)
	}
	if _, err := w.Write(newline); err != nil {
		_ = env.ErrorDispatch(err)
	}

	// sorting handlers before output
	sort.Strings(it.Handlers)

	for _, handlerPath := range it.Handlers {
		if _, err := w.Write([]byte(handlerPath)); err != nil {
			_ = env.ErrorDispatch(err)
		}
		if _, err := w.Write(newline); err != nil {
			_ = env.ErrorDispatch(err)
		}
	}
}
