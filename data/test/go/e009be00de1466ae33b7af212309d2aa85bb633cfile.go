package task

import (
	trans "./.."
	clog "github.com/cihub/seelog"
)

// 按照"file://"类型存储的下载任务分配器
type FileDownloadScheduler struct {
}

func NewFileDownloadScheduler() *FileDownloadScheduler {
	n := new(FileDownloadScheduler)
	return n
}

func (self *FileDownloadScheduler) DispatchDownload(req *DownloadReq) (n *trans.Node, err error) {
	clog.Trace("in file dispatch download")
	url := req.url
	if url == nil {
		clog.Error("url failed")
		return nil, err
	}
	clog.Tracef("%#v", url)
	nid := url.Host
	n = trans.NodeMgr.GetByNid(nid)
	return
}
