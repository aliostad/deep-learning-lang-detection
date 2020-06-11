package elasticfeed

import (
	"github.com/feedlabs/elasticfeed/elasticfeed/model"

	"github.com/feedlabs/elasticfeed/plugin"
	"github.com/feedlabs/elasticfeed/workflow"
	"github.com/feedlabs/elasticfeed/service"
	"github.com/feedlabs/elasticfeed/event"
	"github.com/feedlabs/elasticfeed/resource"
	"github.com/feedlabs/elasticfeed/population"

	"github.com/feedlabs/feedify"
)

type Elasticfeed struct {
	R model.ResourceManager
	E model.EventManager
	S model.ServiceManager
	P model.PluginManager
	W model.WorkflowManager
	PP model.PopulationManager
}

func (this *Elasticfeed) GetEventManager() model.EventManager {
	return this.E
}

func (this *Elasticfeed) GetResourceManager() model.ResourceManager {
	return this.R
}

func (this *Elasticfeed) GetServiceManager() model.ServiceManager {
	return this.S
}

func (this *Elasticfeed) GetPluginManager() model.PluginManager {
	return this.P
}

func (this *Elasticfeed) GetWorkflowManager() model.WorkflowManager {
	return this.W
}

func (this *Elasticfeed) GetPopulationManager() model.PopulationManager {
	return this.PP
}

func (this *Elasticfeed) GetConfig() map[string]interface {} {
	return make(map[string]interface {})
}

func (this *Elasticfeed) Run() {
	this.GetResourceManager().Init()
	this.GetServiceManager().Init()
	this.GetWorkflowManager().Init()
	this.GetEventManager().Init()
	this.GetPopulationManager().Init()

	feedify.SetStaticPath("/static", "public")
	feedify.Run()
}

func NewElasticfeed() model.Elasticfeed {

	engine := &Elasticfeed{}

	engine.R = resource.NewResourceManager(engine)
	engine.E = event.NewEventManager(engine)
	engine.P = plugin.NewPluginManager(engine)
	engine.W = workflow.NewWorkflowManager(engine)
	engine.S = service.NewServiceManager(engine)
	engine.PP = population.NewPopulationManager(engine)

	return engine
}
