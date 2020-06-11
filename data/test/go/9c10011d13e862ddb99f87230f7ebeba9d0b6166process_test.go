package gouv

import (
	"fmt"
	"os"
	"testing"
	"time"
)

func TestSpawnChildProcess(t *testing.T) {
	doTest(t, testSpawnChildProcess, 2)
}

func testSpawnChildProcess(t *testing.T, loop *UvLoop) {
	// spawn new process
	process, err := sampleProcessInit(loop)
	if err != nil {
		t.Fatal(err)
	}

	time.Sleep(1 * time.Second)

	// Unref this process
	process.Unref()

	// kill this process
	process.Freemem()
}

func TestKillProcess(t *testing.T) {
	doTest(t, testKillProcess, 3)
}

func fileExists(name string) bool {
	if _, err := os.Stat(name); err != nil {
		if os.IsNotExist(err) {
			return false
		}
	}
	return true
}

func testKillProcess(t *testing.T, loop *UvLoop) {
	// spawn new process
	process, err := UvSpawnProcess(loop, &UvProcessOptions{
		Args:  []string{"sleep", "10000"},
		Cwd:   "/tmp",
		Flags: UV_PROCESS_DETACHED,
		File:  "sleep",
		Env:   []string{"PATH"},
		ExitCb: func(h *Handle, status, sigNum int) {
			fmt.Printf("Process exited with status %d and signal %d\n", status, sigNum)
			fmt.Printf("%p\n", h.Ptr.(*UvProcess))
		},
	}, nil)
	if err != nil {
		t.Fatal(err)
	}

	time.Sleep(2 * time.Second)

	// Unref this process
	process.Unref()

	// Try to kill this process
	process.Kill(2)

	// Try to freemem
	process.Freemem()
}
