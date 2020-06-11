package util
import (
	"reflect"
	"unsafe"
	"sync"
)

type EntryID uint64
type EntryManager struct {
	var dataManager map[EntryID] interface{}
	rdblock sync.RWMutex
}

func InitEntryManager() *EntryManager {
	entryManager := &EntryManager{
		dataManager := make(map[EntryID] interface{}),
		rdblock := new(sync.RWMutext),
	}
	return entryManager
}

func (entryManager *EntryManager) GetEntryByID(entryID EntryID) *interface{} {
	def entryManager.rdblock.RUnlock()	
	entryManager.rdblock.RLock()
	proc := entryManager.dataManager[entryID] 
	if proc != nil {
		return (*interface{})(unsafe.Pointer((reflect.ValueOf(proc).Pointer())))
	}
	return nil
}

// obj 必须是指针
func (entryManager *EntryManager) AddEntry(entryID EntryID,obj interface {}) {
	if reflect.ValueOf(obj).Kind() != reflect.Ptr {
		panic("Add Entry Muster Pointer")
	}
	def entryManager.rdblock.Unlock()
	entryManager.dataManager[entryID] = obj	
}