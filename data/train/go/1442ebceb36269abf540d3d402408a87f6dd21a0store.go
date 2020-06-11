package store

import (
	"container/list"
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"github.com/wayoos/crane/api/domain"
	"github.com/wayoos/crane/config"
	"io/ioutil"
	"os"
	"strings"
)

const (
	LoadNotFound     = 404
	LoadAlreadyExist = 403
)

func Path(loadData domain.LoadData) string {
	return pathById(loadData.ID)
}

func pathById(loadId string) string {
	return config.DataPath + "/" + loadId
}

func Create(loadName, loadTag string) (loadData domain.LoadData, errApp *domain.AppError) {

	// check if already exist
	_, appErr := findByNameTag(loadName, loadTag)
	if appErr == nil || appErr.Code != LoadNotFound {
		return domain.LoadData{}, &domain.AppError{nil, "Load with this tag already exist.", LoadAlreadyExist}
	}

	var loadId string
	var loadDataPath string

	// create id and folder
	for {
		c := 6
		b := make([]byte, c)
		_, err := rand.Read(b)
		if err != nil {
			return domain.LoadData{}, &domain.AppError{nil, "Error when create dockloadId", 500}
		}
		loadId = hex.EncodeToString(b)

		loadDataPath = pathById(loadId)

		if _, err := os.Stat(loadDataPath); os.IsNotExist(err) {
			// path/to/whatever does not exist
			break
		}

	}

	err := os.MkdirAll(loadDataPath, config.DataPathMode)
	if err != nil {
		return domain.LoadData{}, &domain.AppError{err, "Error creating dockload folder", 500}
	}

	loadData = domain.LoadData{
		ID:   loadId,
		Name: loadName,
		Tag:  loadTag,
	}

	appErr = Save(loadData)
	if appErr != nil {
		return domain.LoadData{}, appErr
	}

	return loadData, nil
}

func Save(loadData domain.LoadData) *domain.AppError {

	if loadData.ID == "" {
		return &domain.AppError{nil, "Invalid dockloadId", 400}
	}

	loadDataJson := config.DataPath + "/" + loadData.ID + ".json"

	outJson, err := os.Create(loadDataJson)
	if err != nil {
		return &domain.AppError{err, "Failed to create data file", 500}
	}
	defer outJson.Close()

	enc := json.NewEncoder(outJson)

	enc.Encode(loadData)

	return nil
}

func List() ([]domain.LoadData, *domain.AppError) {
	l := list.New()

	files, _ := ioutil.ReadDir(config.DataPath)
	for _, f := range files {
		if f.IsDir() {
			l.PushBack(f.Name())
		}
	}

	var loadRecords = make([]domain.LoadData, l.Len())

	idx := 0
	for e := l.Front(); e != nil; e = e.Next() {

		loadId := e.Value.(string)

		inJson, err := os.Open(config.DataPath + "/" + loadId + ".json")
		if err != nil {
			return []domain.LoadData{}, &domain.AppError{err, "Error opening data store", 500}
		}
		defer inJson.Close()

		decode := json.NewDecoder(inJson)
		var loadData domain.LoadData
		err = decode.Decode(&loadData)
		if err != nil {
			return []domain.LoadData{}, &domain.AppError{err, "Error opening data store", 500}
		}

		loadRecords[idx] = loadData
		idx += 1
	}

	return loadRecords, nil
}

// find docloadId by dockloadId, name and version
// tag can be in the form:
//    123456789012
//    test
//    test:1
//    test:*
func Find(query string) (domain.LoadData, *domain.AppError) {
	nameOrId := query
	tag := ""
	querySplit := strings.Split(query, ":")
	if len(querySplit) > 1 {
		nameOrId = querySplit[0]
		tag = querySplit[1]
	}
	return findByNameTag(nameOrId, tag)
}

func findByNameTag(nameOrId, tag string) (domain.LoadData, *domain.AppError) {
	loadRecords, appErr := List()
	if appErr != nil {
		return domain.LoadData{}, appErr
	}

	for _, loadRecord := range loadRecords {
		if loadRecord.ID == nameOrId {
			return loadRecord, nil
		} else if loadRecord.Name == nameOrId {
			// TODO add support to remove all load with same name, we should return a list of matching loaddata
			//if tag == "*" {
			//	return loadRecord, nil
			if loadRecord.Tag == tag {
				return loadRecord, nil
			}
		}
	}

	return domain.LoadData{}, &domain.AppError{nil, "Load not found.", LoadNotFound}
}
