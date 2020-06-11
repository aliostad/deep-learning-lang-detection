package providers

import (
	"database/sql"
	"github.com/Azure/azure-storage-go"
	"github.com/tonyhhyip/go-di-container"
	"github.com/ysitd-cloud/app-controller/core"
)

type managerServiceProvider struct {
	*container.AbstractServiceProvider
}

func NewEnvironmentManagerServiceProvider(app container.Container) container.ServiceProvider {
	sp := managerServiceProvider{
		AbstractServiceProvider: container.NewAbstractServiceProvider(true),
	}

	sp.SetContainer(app)

	return &sp
}

func (sp *managerServiceProvider) Provides() []string {
	return []string{
		"core.manager.env",
		"core.manager.meta",
	}
}

func (sp *managerServiceProvider) Register(app container.Container) {
	sp.RegisterEnv(app)
	sp.RegisterMeta(app)
	sp.RegisterEnv(app)
	sp.RegisterAutoScale(app)
	sp.RegisterManager(app)
}

func (*managerServiceProvider) RegisterEnv(app container.Container) {
	app.Bind("core.manager.env", func(app container.Container) interface{} {
		table := app.Make("azure.storage.table.app").(storage.Table)
		manager := core.NewEnvironmentManager(table)
		return manager
	})
}

func (*managerServiceProvider) RegisterMeta(app container.Container) {
	app.Bind("core.manager.meta", func(app container.Container) interface{} {
		db := app.Make("db").(*sql.DB)
		manager := core.NewMetaInformationManager(db)
		return manager
	})
}

func (*managerServiceProvider) RegisterNetwork(app container.Container) {
	app.Bind("core.manager.network", func(app container.Container) interface{} {
		db := app.Make("db").(*sql.DB)
		manager := core.NewNetworkManager(db)
		return manager
	})
}

func (*managerServiceProvider) RegisterAutoScale(app container.Container) {
	app.Bind("core.manager.autoScale", func(app container.Container) interface{} {
		manager := core.NewAutoScaleManager()
		return manager
	})
}

func (*managerServiceProvider) RegisterManager(app container.Container) {
	app.Bind("core.manager", func(app container.Container) interface{} {
		env := app.Make("core.manager.env").(core.EnvironmentManager)
		meta := app.Make("core.manager.meta").(core.MetaInformationManager)
		network := app.Make("core.manager.network").(core.NetworkManager)
		autoScale := app.Make("core.manager.autoScale").(core.AutoScaleManager)
		manager := core.NewManager(env, meta, autoScale, network)
		return manager
	})
}
