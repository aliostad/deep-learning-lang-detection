package main

func (t *TestMaster) testReplicaFailure() {
	t.ProcessCall("startnodes 3 1")
	t.ProcessCall("createfile")
	t.ProcessCall("wait 1000")
	t.ProcessCall("stopnode 2")
	t.ProcessCall("createfile")
	t.ProcessCall("resumenode 2")
	t.ProcessCall("createfile")
}

func (t *TestMaster) testTwoReplicaFailure() {
	t.ProcessCall("startnodes 5 1")
	t.ProcessCall("createfile")
	t.ProcessCall("wait 1000")
	t.ProcessCall("stopnode 2")
	t.ProcessCall("createfile")
	t.ProcessCall("createfile")
	t.ProcessCall("stopnode 0")
	t.ProcessCall("resumenode 2")
	t.ProcessCall("createfile")
	t.ProcessCall("resumenode 0")
}

func (t *TestMaster) testMasterFailure() {
	t.ProcessCall("startnodes 3 1")
	t.ProcessCall("createfile")
	t.ProcessCall("wait 1000")
	t.ProcessCall("stopnode 1")
	t.ProcessCall("createfile")
	t.ProcessCall("resumenode 1")
	t.ProcessCall("createfile")
}

func (t *TestMaster) testTwoMasterFailure() {
	t.ProcessCall("startnodes 5 1")
	t.ProcessCall("createfile")
	t.ProcessCall("wait 100")
	t.ProcessCall("stopnode 1")
	t.ProcessCall("wait 100")
	t.ProcessCall("createfile")
	t.ProcessCall("wait 300")
	t.ProcessCall("stopnode 2")
	t.ProcessCall("wait 100")
	t.ProcessCall("createfile")
	t.ProcessCall("createfile")
	t.ProcessCall("wait 300")
	t.ProcessCall("resumenode 2")
	t.ProcessCall("createfile")
	t.ProcessCall("wait 200")
}

func (t *TestMaster) testDoubleMasterFailure() {
	t.ProcessCall("startnodes 5 1")
	t.ProcessCall("createfile")
	t.ProcessCall("stopnode 1")
	t.ProcessCall("stopnode 2")
	t.ProcessCall("createfile")
	t.ProcessCall("wait 500")
	t.ProcessCall("createfile")
	t.ProcessCall("resumenode 2")
	t.ProcessCall("createfile")
	t.ProcessCall("wait 100")
	t.ProcessCall("resumenode 1")
	t.ProcessCall("createfile")
}

func (t *TestMaster) testCascadingMasterFailure() {
	t.ProcessCall("startnodes 5 1")
	t.ProcessCall("stopnode 1")
	t.ProcessCall("createfile")
	t.ProcessCall("wait 3000")
	t.ProcessCall("resumenode 1")
	t.ProcessCall("stopnode 2")
	t.ProcessCall("createfile")
	t.ProcessCall("wait 3000")
	t.ProcessCall("resumenode 2")
	t.ProcessCall("stopnode 3")
	t.ProcessCall("createfile")
	t.ProcessCall("wait 3000")
	t.ProcessCall("resumenode 3")
	t.ProcessCall("stopnode 4")
	t.ProcessCall("createfile")
	t.ProcessCall("wait 3000")
	t.ProcessCall("resumenode 4")
	t.ProcessCall("createfile")
}

func (t *TestMaster) testLotsofReplicas() {
	t.ProcessCall("startnodes 5 1")
	t.ProcessCall("createfile")
	t.ProcessCall("createfile")
	t.ProcessCall("createfile")
	t.ProcessCall("wait 4")
}
