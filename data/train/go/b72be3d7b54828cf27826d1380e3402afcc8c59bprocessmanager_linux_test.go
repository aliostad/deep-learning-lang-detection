package process

import (
	"testing"
	"github.com/stretchr/testify/assert"
	"os/user"
)

const TEST_PROC = "_testresource/proc"

type testProcFileManager struct {}

func (t *testProcFileManager) getProcDir() string {
	return TEST_PROC
}

func setupLinuxProcessManager(t *testing.T) *LinuxProcessManager{
	return &LinuxProcessManager{
		procManager: &testProcFileManager{},
	}
}

func Test_toProcess(t *testing.T) {
	linuxProcessManager := setupLinuxProcessManager(t)

	process := linuxProcessManager.toProcess("1312")

	assert.Equal(t, "1312", process.Id)
	assert.Equal(t, "0", process.Parent)

	currentUser, _ := user.Current()
	assert.Equal(t, currentUser.Username, process.User)
	assert.True(t, process.Running)
	assert.Equal(t, "/sbin/init", process.Commandline)
	assert.Equal(t, map[string]string{
		"ENV_1": "VALUE1", "ENV_2": "VALUE2",
	}, process.Environment)
	assert.Equal(t, -1, process.ReturnCode)
}

func Test_ListProcess(t *testing.T) {
	linuxProcessManager := setupLinuxProcessManager(t)

	process := linuxProcessManager.ListProcess()

	assert.Equal(t, 1, len(process))
	assert.Equal(t, "1312", process[0].Id)
	assert.Equal(t, "0", process[0].Parent)

	currentUser, _ := user.Current()
	assert.Equal(t, currentUser.Username, process[0].User)
	assert.True(t, process[0].Running)
	assert.Equal(t, "/sbin/init", process[0].Commandline)
	assert.Equal(t, map[string]string{
		"ENV_1": "VALUE1", "ENV_2": "VALUE2",
	}, process[0].Environment)
	assert.Equal(t, -1, process[0].ReturnCode)
}