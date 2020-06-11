package monitor

import (
	"os/exec"
	"bytes"
	"strings"
	"../data"
	"./notice_manager"
)

type MonitorProcess struct {

}

func (self *MonitorProcess) Run()  {
	processData := new(data.Process);
	processList,_ := processData.GetAll();
	for _, item := range processList {
		self.handle( item );
	}
}

func (self *MonitorProcess) handle( processItem data.ProcessDataItem )  {
	exists,_ := self.existsProcess( processItem.ProcessName );
	noticeItem := notice_manager.NoticeItem{};
	if !exists {
		noticeItem.Message = "进程不存在";
		noticeItem.Notice = true;
	} else {
		noticeItem.Notice = false;
	}
	noticeItem.Target = &processItem;
	notice_manager.AddNotice( noticeItem );
}


func ( self *MonitorProcess ) existsProcess( processName string ) ( bool,error ) {
	cmd := exec.Command("ps", "aux")
	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()
	if err != nil {
		return false,err;
	}
	for {
		line, err := out.ReadString('\n')
		if strings.Index(strings.ToLower(line), strings.ToLower(processName)) != -1 {
			return true,nil;
		}
		if err != nil {
			break;
		}
	}
	return false,nil;
}
