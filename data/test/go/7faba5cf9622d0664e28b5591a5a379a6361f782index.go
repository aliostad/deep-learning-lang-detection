package handlers

import (
	"net/http"

	"github.com/Ssawa/LinkLetter/web/auth/authentication"
	"github.com/gorilla/mux"
)

// IndexHandlerManager is responsible for, surprise surprise, handling the index of our webpage.
type IndexHandlerManager struct {
	BaseHandlerManager
}

func (manager IndexHandlerManager) indexFunc(w http.ResponseWriter, r *http.Request) {
	manager.templator.RenderTemplate(w, "index.tmpl", nil)
}

func (manager *IndexHandlerManager) InitRoutes(router *mux.Router) http.Handler {
	router.HandleFunc("/", manager.indexFunc)
	return authentication.ProtectedHandler(manager.login, router)
}
