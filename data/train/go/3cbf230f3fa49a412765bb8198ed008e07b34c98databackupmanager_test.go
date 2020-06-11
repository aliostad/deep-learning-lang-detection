package databackupmanager

import (
	"testing"
)

func TestDataBackup(t *testing.T) {
	databackupManager := GetInstance()
	buffer := databackupManager.MakeBuffer(1000)
	buffer1 := databackupManager.MakeBuffer(1000)
	buffer2 := databackupManager.MakeBuffer(1000)
	buffer3 := databackupManager.MakeBuffer(1000)
	databackupManager.Insert(1, 0, buffer)
	databackupManager.Insert(1, 1, buffer1)
	databackupManager.Insert(1, 2, buffer2)
	databackupManager.Insert(1, 3, buffer3)

	databackupManager.FindAndRemove(1, 1)

	list := databackupManager.GetDataList(1)
	t.Log("seq:", list[0].Seq)
	if list[0].Seq != 2 {
		t.Log("order expection")
		t.Fatal()
	}

	t.Log("seq:", list[1].Seq)
	if list[1].Seq != 3 {
		t.Log("order expection")
		t.Fatal()
	}

	databackupManager.Remove(1)
	databackupManager.Clear()
}
