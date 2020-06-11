package flog

import (
	"testing"
	"time"
)

func TestConsoleLog(t *testing.T) {
	logManager := NewLogManagerConsole()
	loggerA := logManager.NewLogger("testLoggerA", LEVEL_DEBUG)
	loggerB := logManager.NewLogger("testLoggerB", LEVEL_ERR)

	loggerA.Info("Some text 1 !")
	loggerB.Err("Some text 2 !")
	loggerB.Debug("Debug some msg")

	time.Sleep(500 * time.Millisecond)
	logManager.DestroyLogManager()

}

func TestFileLog(t *testing.T) {
	logManager := NewLogManagerFile("/home/tjoma/test", 1024*1024*5)
	loggerA := logManager.NewLogger("testLoggerA", LEVEL_DEBUG)
	loggerB := logManager.NewLogger("testLoggerB", LEVEL_ERR)

	loggerA.Info("loggerA Some text 1 !")
	loggerB.Info("loggerB Some text 2 !")

	time.Sleep(100 * time.Millisecond)
	logManager.DestroyLogManager()
}

