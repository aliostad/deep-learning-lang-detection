package index_manager

import (
	"path"

	"github.com/golang/glog"
	"github.com/yanyiwu/settledb/doc_manager"
	"github.com/yanyiwu/settledb/util"
)

const DOC_MANAGER_ROOT_DIR_NAME = "docmanager"

type IndexManager struct {
	docmgr *doc_manager.DocManager
}

func NewIndexManager(indexdir string) (*IndexManager, error) {
	util.CreateDirIfNotExists(indexdir)
	docdir := path.Join(indexdir, DOC_MANAGER_ROOT_DIR_NAME)
	docmgr, err := doc_manager.NewDocManager(docdir)
	if err != nil {
		glog.Error(err)
		return nil, err
	}
	return &IndexManager{docmgr}, nil
}
