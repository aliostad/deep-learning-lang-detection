// Package main provides ...
package aesf

import (
	"fmt"
	//	. "github.com/vitas/artemis/aesf/utils"
)

type World interface {
	GetName() string
	Initialize()
	GetEntityManager() *EntityManager
	GetSystemManager() *SystemManager
	GetGroupManager() *GroupManager
	GetTagManager() *TagManager
	GetManagers() []Manager
	CreateEntity() *Entity
	GetEntity(id int) *Entity
	RefreshEntity(e *Entity)
	DeleteEntity(e *Entity)
	GetDelta() int64
	SetDelta(delta int64)
	LoopStart()
}

const ENTITY_BAG_CAP = 32

// The primary instance for the framework. It contains all the managers.
// You must use this to create, delete and retrieve entities.
// It is also important to set the delta each game loop iteration.
type EntityWorld struct {
	name          string
	entityManager *EntityManager
	systemManager *SystemManager
	tagManager    *TagManager
	groupManager  *GroupManager
	delta         int64
	refreshed     *EntityBag
	deleted       *EntityBag
	managers      []Manager
}

//Use this func to create a new entity world
func NewEntityWorld() EntityWorld {
	w := EntityWorld{name: "EntityWorld"}
	w.refreshed = NewEntityBag(ENTITY_BAG_CAP)
	w.deleted = NewEntityBag(ENTITY_BAG_CAP)
	w.entityManager = NewEntityManager(&w)
	w.systemManager = NewSystemManager(&w)
	w.tagManager = NewTagManager(&w)
	w.groupManager = NewGroupManager(&w)
	w.managers = append(w.managers, w.entityManager, w.tagManager, w.groupManager)
	return w
}

func (w *EntityWorld) Initialize()                     {}
func (w EntityWorld) String() string                   { return fmt.Sprintf("[%s]", w.name) }
func (w EntityWorld) GetEntityManager() *EntityManager { return w.entityManager }
func (w EntityWorld) GetSystemManager() *SystemManager { return w.systemManager }
func (w EntityWorld) GetGroupManager() *GroupManager   { return w.groupManager }
func (w EntityWorld) GetTagManager() *TagManager       { return w.tagManager }
func (w EntityWorld) GetManagers() []Manager           { return w.managers }

//Ensure all systems are notified of changes to this entity.
func (w EntityWorld) RefreshEntity(e *Entity) { w.refreshed.Add(e) }

//Create and return a new or reused entity instance.
func (w EntityWorld) CreateEntity() *Entity { return w.entityManager.Create() }

//Get a entity having the specified id.
func (w EntityWorld) GetEntity(id int) *Entity { return w.entityManager.GetEntity(id) }
func (w EntityWorld) GetName() string          { return w.name }

// Time since last game loop.
// delta in milliseconds.
func (w EntityWorld) GetDelta() int64 { return w.delta }

// You must specify the delta for the game here.
//delta time since last game loop.
func (w *EntityWorld) SetDelta(delta int64) { w.delta = delta }

//Delete the provided entity from the world.
func (w EntityWorld) DeleteEntity(e *Entity) {
	if !w.deleted.Contains(e) {
		w.deleted.Add(e)
	}
}

// Let framework take care of internal business.
func (w *EntityWorld) LoopStart() {
	if !w.refreshed.IsEmpty() {
		for i := 0; w.refreshed.Size() > i; i++ {
			e := w.refreshed.Get(i)
			for _, manager := range w.managers {
				manager.Refresh(e)
			}
		}
		w.refreshed.Clear()
	}
	if !w.deleted.IsEmpty() {
		for i := 0; w.deleted.Size() > i; i++ {
			e := w.deleted.Get(i)
			for _, manager := range w.managers {
				manager.Remove(e)
			}
		}
		w.deleted.Clear()
	}
}
