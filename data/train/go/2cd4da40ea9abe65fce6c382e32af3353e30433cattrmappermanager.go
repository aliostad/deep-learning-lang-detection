// Attribute mapper manager for dependency injection

package FlatFS

import (
	"log"
)

type AttrMapperManager struct {
	attrMappers map[string]AttrMapper
}

func NewAttrMapperManager() *AttrMapperManager {
	return &AttrMapperManager{
		attrMappers: make(map[string]AttrMapper, 0),
	}
}

func (attrMapperManager *AttrMapperManager) Map() map[string]AttrMapper {
	return attrMapperManager.attrMappers
}

func (attrMapperManager *AttrMapperManager) Has(id string) bool {
	_, ok := attrMapperManager.attrMappers[id]
	return ok
}

func (attrMapperManager *AttrMapperManager) Get(id string) AttrMapper {
	if attrMapper, ok := attrMapperManager.attrMappers[id]; ok {
		return attrMapper
	}
	log.Fatalf("Implementation %v not found in %v \n", id, attrMapperManager.attrMappers)
	return nil
}

func (attrMapperManager *AttrMapperManager) Set(id string, attrMapper AttrMapper) AttrMapper {
	attrMapperManager.attrMappers[id] = attrMapper
	return attrMapperManager.attrMappers[id]
}
