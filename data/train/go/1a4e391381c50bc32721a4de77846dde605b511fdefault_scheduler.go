package task

import (
	trans "./.."
	"cydex/transfer"
	"fmt"
	clog "github.com/cihub/seelog"
	URL "net/url"
	"strings"
)

// 默认的任务调度器
type DefaultScheduler struct {
	u_restrict *RestrictUploadScheduler
	u_proxy    UploadScheduler
	d_file     *FileDownloadScheduler
	d_nas      *NasRoundRobinScheduler
}

func NewDefaultScheduler(restrict_mode int) *DefaultScheduler {
	n := new(DefaultScheduler)
	rr := NewRoundRobinUploadScheduler()
	n.u_proxy = rr
	n.u_restrict = NewRestrictUploadScheduler(restrict_mode)
	n.d_file = NewFileDownloadScheduler()
	n.d_nas = NewNasRoundRobinScheduler()

	trans.NodeMgr.AddObserver(rr)
	trans.NodeMgr.AddObserver(n.d_nas)
	TaskMgr.AddObserver(n.u_restrict)
	return n
}

func (self *DefaultScheduler) String() string {
	return "Default Scheduler"
}

func (self *DefaultScheduler) DispatchUpload(req *UploadReq) (n *trans.Node, err error) {
	// 首先使用约束调度器, 如果没有找到,则再使用具体的上传调度器进行分配
	clog.Tracef("%s: dispatch upload", self)
	n, err = self.u_restrict.DispatchUpload(req)
	if err != nil {
		// log
	}
	if n != nil {
		return
	}
	file_storage := req.UploadTaskReq.FileStorage
	// issue-31, 有文件存储路径,说明文件分片已经有上传过了
	if file_storage != "" {
		// 已有分片被上传过了,分片上传约束调度器没找到对应的node,要找到原有的node.
		clog.Warnf("segs of file(%s) were uploaded", req.Fid)
		req2 := new(DownloadReq)
		req2.DownloadTaskReq = &transfer.DownloadTaskReq{
			FileStorage: file_storage,
		}
		n, err = self.dispatchDownload(req2)

		if n != nil {
			return
		}
		return nil, fmt.Errorf("All segments of one file should be dispatched to the same node!!")
	}

	n, err = self.u_proxy.DispatchUpload(req)
	if err != nil {
		// log
	}
	return
}

func (self *DefaultScheduler) dispatchDownload(req *DownloadReq) (n *trans.Node, err error) {
	storage := req.FileStorage
	if storage == "" {
		err = fmt.Errorf("There is no storage, file are not uploaded yet!")
		return
	}
	clog.Trace(storage)
	var url *URL.URL
	if url, err = URL.Parse(storage); err != nil {
		return nil, err
	}
	scheme := strings.ToLower(url.Scheme)
	req.url = url
	clog.Tracef("dispatch url: %+v", url)

	clog.Trace(scheme)
	switch scheme {
	case "file":
		n, err = self.d_file.DispatchDownload(req)
	case "nas":
		n, err = self.d_nas.DispatchDownload(req)
	default:
		err = fmt.Errorf("Unsupport storage url %s", storage)
	}
	return
}

func (self *DefaultScheduler) DispatchDownload(req *DownloadReq) (n *trans.Node, err error) {
	clog.Trace("dispatch download")
	return self.dispatchDownload(req)
}
