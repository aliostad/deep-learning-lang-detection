package pipline

type Manager struct {
	requestQueue chan InMessage
	responseQueue chan OutMessage

	executor *Executor

	DependenceProvider *DependenceProvider
	CommandProvider *CommandProvider

	Sender *Sender
}

func NewManager() *Manager {
	manager := new(Manager)
	manager.Init()
	return manager
}

func (manager *Manager) Init() {
	manager.requestQueue = make(chan InMessage)
	manager.responseQueue = make(chan OutMessage)

	manager.executor = &Executor{RequestQueue: manager.requestQueue, ResponseQueue: manager.responseQueue}

	manager.DependenceProvider = NewDependenceProvider()
	manager.CommandProvider = NewCommandProvider(manager.DependenceProvider)

	manager.Sender = NewSender(manager.responseQueue)
}

func (manager *Manager) Run() {
	go manager.Sender.Run()
	go manager.executor.Run()
}

func (manager *Manager) AddMessageChannel(channel MessageChannel) {
	channel.SetCommandProvider(manager.CommandProvider)
	channel.SetOutQueue(manager.requestQueue)
}