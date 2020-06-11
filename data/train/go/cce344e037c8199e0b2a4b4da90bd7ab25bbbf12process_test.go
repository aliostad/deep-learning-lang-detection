// Copyright (c) 2012 VMware, Inc.

package gonit_test

import (
	. "github.com/cloudfoundry/gonit"
	"github.com/cloudfoundry/gonit/test/helper"
	. "launchpad.net/gocheck"
	"log"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"
)

type ProcessSuite struct{}

var _ = Suite(&ProcessSuite{})

// absolute path to the json encoded helper.ProcessInfo
// written by goprocess, read by the following Tests.
func processJsonFile(p *Process) string {
	return filepath.Join(p.Dir, p.Name+".json")
}

func processInfo(p *Process) *helper.ProcessInfo {
	file := processJsonFile(p)
	info := &helper.ProcessInfo{}
	helper.ReadData(info, file)
	return info
}

// these assertions apply to any daemon process
func assertProcessInfo(c *C, process *Process, info *helper.ProcessInfo) {
	selfInfo := helper.CurrentProcessInfo()

	c.Check(selfInfo.Pgrp, Not(Equals), info.Pgrp) // process group will change

	c.Check(selfInfo.Sid, Not(Equals), info.Sid) // session id will change

	c.Check(false, Equals, info.HasTty) // no controling terminal

	sort.Strings(selfInfo.Env)
	sort.Strings(info.Env)
	c.Check(selfInfo.Env, Not(DeepEquals), info.Env) // sanitized env will differ

	// check expected process working directory
	// (and follow symlinks, e.g. darwin)
	ddir, _ := filepath.EvalSymlinks(process.Dir)
	idir, _ := filepath.EvalSymlinks(info.Dir)
	c.Check(ddir, Equals, idir)

	// spawned process argv[] should be the same as the process.Start command
	c.Check(process.Start, Equals, strings.Join(info.Args, " "))

	// check when configured to run as different user and/or group
	if process.Uid == "" {
		c.Check(selfInfo.Uid, Equals, info.Uid)
		c.Check(selfInfo.Euid, Equals, info.Euid)
	} else {
		c.Check(selfInfo.Uid, Not(Equals), info.Uid)
		c.Check(selfInfo.Euid, Not(Equals), info.Euid)
	}

	if process.Gid == "" {
		if process.Uid == "" {
			c.Check(selfInfo.Gid, Equals, info.Gid)
			c.Check(selfInfo.Egid, Equals, info.Egid)
		} else {
			c.Check(selfInfo.Gid, Not(Equals), info.Gid)
			c.Check(selfInfo.Egid, Not(Equals), info.Egid)
		}
	} else {
		c.Check(selfInfo.Gid, Not(Equals), info.Gid)
		c.Check(selfInfo.Egid, Not(Equals), info.Egid)
	}
}

// lame, but need wait a few ticks for processes to start,
// files to write, etc.
func pause() {
	time.Sleep(100 * time.Millisecond)
}

// start + stop of gonit daemonized process
func (s *ProcessSuite) TestSimple(c *C) {
	process := helper.NewTestProcess("simple", nil, false)
	defer helper.Cleanup(process)

	pid, err := process.StartProcess()
	if err != nil {
		log.Panic(err)
	}

	pause()

	c.Check(true, Equals, process.IsRunning())

	info := processInfo(process)

	c.Check(pid, Equals, info.Pid)

	assertProcessInfo(c, process, info)

	err = process.StopProcess()
	c.Check(err, IsNil)

	pause()

	c.Check(false, Equals, process.IsRunning())
}

func skipUnlessRoot(c *C) bool {
	if os.Getuid() != 0 {
		c.Skip("test must be run as root")
		return true
	}
	return false
}

// start + stop of gonit daemonized process w/ setuid
func (s *ProcessSuite) TestSimpleSetuid(c *C) {
	if skipUnlessRoot(c) {
		return
	}

	process := helper.NewTestProcess("simple_setuid", nil, false)
	defer helper.Cleanup(process)

	helper.TouchFile(processJsonFile(process), 0666)

	process.Uid = "nobody"
	process.Gid = "nogroup"

	pid, err := process.StartProcess()
	if err != nil {
		c.Fatal(err)
	}

	pause()

	c.Check(true, Equals, process.IsRunning())

	info := processInfo(process)
	assertProcessInfo(c, process, info)
	c.Check(pid, Equals, info.Pid)

	err = process.StopProcess()
	c.Check(err, IsNil)

	pause()

	c.Check(false, Equals, process.IsRunning())
}

// check that -F flag has been rewritten to -G
// and reset args to -F so assertProcessInfo()
// can check the rest of argv[]
func grandArgs(args []string) bool {
	for i, arg := range args {
		if arg == "-G" {
			args[i] = "-F"
			return true
		}
	}
	return false
}

// start / restart / stop self-daemonized process
func (s *ProcessSuite) TestDetached(c *C) {
	// start process
	process := helper.NewTestProcess("detached", nil, true)
	defer helper.Cleanup(process)

	pid, err := process.StartProcess()
	if err != nil {
		log.Panic(err)
	}

	pause()

	c.Check(true, Equals, process.IsRunning())

	info := processInfo(process)

	c.Check(true, Equals, grandArgs(info.Args))
	assertProcessInfo(c, process, info)
	c.Check(pid, Not(Equals), info.Pid)
	pid, err = process.Pid()
	if err != nil {
		log.Panic(err)
	}
	c.Check(pid, Equals, info.Pid)

	// restart via SIGHUP
	prevPid := info.Pid

	c.Check(0, Equals, info.Restarts)

	for i := 1; i < 3; i++ {
		err = process.RestartProcess()

		pause()
		c.Check(true, Equals, process.IsRunning())

		pid, err = process.Pid()
		if err != nil {
			log.Panic(err)
		}

		c.Check(prevPid, Equals, pid)
		info = processInfo(process)
		c.Check(true, Equals, grandArgs(info.Args))
		assertProcessInfo(c, process, info)

		// SIGHUP increments restarts counter
		c.Check(i, Equals, info.Restarts)
	}

	// restart via full stop+start
	prevPid = info.Pid

	process.Restart = ""

	err = process.RestartProcess()

	pause()
	c.Check(true, Equals, process.IsRunning())

	pid, err = process.Pid()
	if err != nil {
		log.Panic(err)
	}

	c.Check(prevPid, Not(Equals), pid)
	info = processInfo(process)
	c.Check(true, Equals, grandArgs(info.Args))
	assertProcessInfo(c, process, info)

	err = process.StopProcess()
	c.Check(err, IsNil)

	pause()

	c.Check(false, Equals, process.IsRunning())
}

// test invalid uid
func (s *ProcessSuite) TestFailSetuid(c *C) {
	if skipUnlessRoot(c) {
		return
	}

	process := helper.NewTestProcess("fail_setuid", nil, false)
	defer helper.Cleanup(process)

	process.Uid = "aint_nobody"

	_, err := process.StartProcess()
	if err == nil {
		c.Fatalf("user.LookupId(%q) should have failed", process.Uid)
	}

	pause()

	c.Check(false, Equals, process.IsRunning())
}

// test invalid executable
func (s *ProcessSuite) TestFailExe(c *C) {
	process := helper.NewTestProcess("fail_exe", nil, false)
	defer helper.Cleanup(process)

	err := os.Chmod(helper.TestProcess, 0444)
	if err != nil {
		log.Panic(err)
	}

	_, err = process.StartProcess()
	c.Check(err, NotNil)

	pause()

	c.Check(false, Equals, process.IsRunning())
}
