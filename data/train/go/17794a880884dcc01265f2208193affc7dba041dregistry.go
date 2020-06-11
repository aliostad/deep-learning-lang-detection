package app

import (
	"./wiki"
	// "github.com/teambo-org/app-wiki"
	"./apptools"
)

type Registry struct {
	Config            apptools.Config
	DispatchHandler   apptools.DispatchHandler
	AssetRegistry     apptools.AssetRegistry
	AssetTestRegistry apptools.AssetRegistry
}

func (r Registry) GetConfig() apptools.Config {
	return r.Config
}

func (r Registry) GetDispatchHandler() apptools.DispatchHandler {
	return r.DispatchHandler
}

func (r Registry) GetAssetRegistry() apptools.AssetRegistry {
	return r.AssetRegistry
}

func (r Registry) GetAssetTestRegistry() apptools.AssetRegistry {
	return r.AssetTestRegistry
}

func (r Registry) Init() {
	apps := []apptools.App{
		wiki.App{},
	}
	for _, app := range apps {
		app.Init(r)
	}
}
