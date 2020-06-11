package service

import (
	"encoding/json"
	"fmt"
	"encoding/binary"
    "github.com/arcpop/observerservice/service/processcache"
	"errors"
)

//ProcessCreationNotification is the go type of ProcessCreated notification
type ProcessCreationNotification struct {
    NotificationHeader
    NewProcessID uint64
    ParentProcessID uint64
    ParentProcess string
    CreatingThreadID uint64
    CreatingProcessID uint64
    CreatingProcess string
    ProcessName string
}

const (
    MinProcessCreationNotificationSize = NotificationHeaderSize + 36
)

var (
    ErrProcessNotFound = errors.New("Process entry not found")
)

func (n *ProcessCreationNotification) ParseFrom(b []byte) error {
    if len(b) < MinRegistryNotificationSize {
        return ErrParsingFailed
    }
    n.NotificationHeader.ParseFrom(b)
    n.NewProcessID = binary.LittleEndian.Uint64(b[24:])
    n.ParentProcessID = binary.LittleEndian.Uint64(b[32:])
    n.ParentProcess = processcache.ProcessNameByID(n.ParentProcessID)
    n.CreatingThreadID = binary.LittleEndian.Uint64(b[40:])
    n.CreatingProcessID = binary.LittleEndian.Uint64(b[48:])
    n.CreatingProcess = processcache.ProcessNameByID(n.CreatingProcessID)
    truncated := binary.LittleEndian.Uint16(b[56:])
    if truncated == 0 {
        n.ProcessName = decodeUnicodeByteBuffer(b[58:])
    } else {
        name := processcache.ProcessNameByID(n.NewProcessID)
        if name == "" {
            //Use truncated name anyway
            n.ProcessName = decodeUnicodeByteBuffer(b[58:])
        } else {
            n.ProcessName = name
        }
    }
    return nil
}

func (n *ProcessCreationNotification) Encode() ([]byte, error) {
    return json.Marshal(*n)
}

func (n *ProcessCreationNotification) Handle() {
    fmt.Println("Process " + n.ProcessName + " created by " + n.CreatingProcess + " Parent: " + n.ParentProcess)
}
