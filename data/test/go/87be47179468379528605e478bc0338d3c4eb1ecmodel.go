package database

type RepositoryManager struct {
	repositories map[string]interface{}
}

func NewRepositoryManager() (repositoryManager *RepositoryManager) {
	repositories := make(map[string]interface{})
	repositoryManager = &RepositoryManager{repositories}

	return
}

func (self *RepositoryManager) AddRepository(name string, repository interface{}) {
	self.repositories[name] = repository
}

func (self *RepositoryManager) GetRepository(name string) (repository interface{}) {
	repository = self.repositories[name]

	return
}
