package apptools

import (
	"io"
	"net/http"
	"time"
)

type App interface {
	Init(Registry)
}

type Registry interface {
	Init()
	GetConfig() Config
	GetDispatchHandler() DispatchHandler
	GetAssetRegistry() AssetRegistry
	GetAssetTestRegistry() AssetRegistry
}

type DispatchHandler interface {
	Attach(func(func(w http.ResponseWriter, r *http.Request)) func(w http.ResponseWriter, r *http.Request))
	AddTeamObject(string, bool)
}

type AssetRegistry interface {
	Add(string, Asset)
	AddAssets(map[string][]Asset)
	AddTemplates(map[string]Asset, map[string]Asset)
}

type Asset struct {
	Url        string
	GetModTime func() time.Time
	GetReader  func() io.Reader
}

type Config interface {
	Get(key string) string
}
