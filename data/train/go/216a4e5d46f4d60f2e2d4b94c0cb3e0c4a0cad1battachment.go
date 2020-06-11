// Copyright (c) 2015 qianqiusoft.com
// Licensed to You under the GNU Affero GPL v3
// See the LICENSE file at git.qianqiusoft.com/qianqiusoft/light-vocation/LICENSE
// http://www.gnu.org/licenses/why-affero-gpl.en.html

package sysmodels

import (
	"git.qianqiusoft.com/qianqiusoft/light-vocation/sysdb"
	"git.qianqiusoft.com/qianqiusoft/light-vocation/sysentitys"
	"strings"
)

type AttachmentManager struct {
}

func (this *AttachmentManager) Add(obj *sysentitys.Attachment) error {
	var manager = &sysdb.AttachmentManager{}
	return manager.Add(obj)
}

func (this *AttachmentManager) Get(id interface{}) (*sysentitys.Attachment, error) {
	var manager = &sysdb.AttachmentManager{}
	return manager.Get(id)
}

func (this *AttachmentManager) GetList(ids string) ([]*sysentitys.Attachment, error) {
	idList := strings.Split(ids, ",")
	var manager = &sysdb.AttachmentManager{}
	return manager.GetList(idList)
}

func (this *AttachmentManager) Delete(obj *sysentitys.Attachment) error {
	var manager = &sysdb.AttachmentManager{}
	return manager.Delete(obj)
}
