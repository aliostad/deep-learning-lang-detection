package relation

import (
	//"fmt"
	//"time"
	//"net/http"
	//"errors"
	//"context"
	//"google.golang.org/appengine"
	//"google.golang.org/appengine/datastore"
	//"strconv"
)

/* RelationManager
 * DataStoreとMemoManagerを仲介する *
 * ドライバとして利用               */
/* == Struct ======================================================== */
type RelationManager struct{
	DataList []Relation
}

func NewRelationManager() *RelationManager {
	s := new(RelationManager)

	s.init()

	return s
}

func (s *RelationManager) init() {
}

func (s *RelationManager) deinit() {
	//deinit
	//sync datastore
	//delete datastore connection
}

func (s *RelationManager) Sync() {
	//Sync With Datastore
}

func (s *RelationManager) Pull() {
	//Pull from Datastore
}

//delete
//add



