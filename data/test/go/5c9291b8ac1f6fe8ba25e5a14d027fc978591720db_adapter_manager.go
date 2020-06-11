package cachestrategy

import ()

type DBAdapterManager struct {
	adapterMap map[string]DBAdapterInterface
}

// Initialize the adapterMap
func (dbAdapterManager *DBAdapterManager) Initialize() {
	dbAdapterManager.adapterMap = make(map[string]DBAdapterInterface)
}

// Returns the DBAdapter registered with the given adapterType
func (dbAdapterManager *DBAdapterManager) GetDBAdapter(adapterType string) (adapter DBAdapterInterface, err error) {
	return dbAdapterManager.adapterMap[adapterType], nil
}

// Registers the given DB adapter with its type
func (dbAdapterManager *DBAdapterManager) RegisterDBAdapter(adapterType string, adapter DBAdapterInterface) error {
	dbAdapterManager.adapterMap[adapterType] = adapter
	return nil
}

//Global DBAdapterManager Singleton
var DBAdapterMgr *DBAdapterManager = nil
