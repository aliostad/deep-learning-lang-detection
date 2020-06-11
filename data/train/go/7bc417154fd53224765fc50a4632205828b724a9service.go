package service

import "fmt"

type Service interface {
	Init(serviceManager *ServiceManager)
	Start()
	Stop()
	Restart()
	DeInit()
	Get() interface{}
	/*	AddPlugin(plugin *PluginManager.Plugin)
		DelPlugin(plugin *PluginManager.Plugin)*/
}

type ServiceManager struct {
	services map[string]*Service
}

func (serviceManager *ServiceManager) Init() {
	serviceManager.services = make(map[string]*Service)
}

func (serviceManager *ServiceManager) Start() {
	serviceManager.InitServices()
	for _, service := range serviceManager.services {
		(*service).Start()
	}
}

func (serviceManager *ServiceManager) InitServices(){
	fmt.Println("===== INITIALIZE Services =====")
	for _, service := range serviceManager.services {
		(*service).Init(serviceManager)
	}

}

func (serviceManager *ServiceManager) Stop() {
	fmt.Println("===== STOPPING Services =====")
	for _, service := range serviceManager.services {
		(*service).Stop()
	}
}

func (serviceManager *ServiceManager) DeInit() {
	for _, service := range serviceManager.services {
		(*service).DeInit()
	}
}

func (serviceManager *ServiceManager) AddService(key string, service Service) (err bool) {
	err = serviceManager.services[key] != nil
	if !err {
		serviceManager.services[key] = &service
	} else {
		fmt.Println("Error key already exists, maybe you have already started this service")
	}

	return err
}

func (serviceManager *ServiceManager) Get(key string)(service *Service, err bool) {
	service = serviceManager.services[key]
	if service == nil {
		err=true;
	}
	return service, err;
}

/*func (serviceManager *ServiceManager) GetService(key string) (service*bool, Service, exist bool) {
	service = serviceManager.services[key]
	return service,exist
}*/
