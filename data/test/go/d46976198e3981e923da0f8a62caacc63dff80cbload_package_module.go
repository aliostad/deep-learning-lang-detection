package protocol

import (
	"gdcl/fsm"
)

const (
	LOAD_PACKAGE_IDLE = iota
	LOAD_PACKAGE_UP
)

type LoadPackageModule struct {
	DockModule
	packageData  []byte
}

func loadPackage(state int, input interface{}, output interface{}, data interface{}) {
	module := data.(*LoadPackageModule)
	packet := DantePacketNew(LOAD_PACKAGE, module.packageData)
	module.ToDockLink <- *packet
}

func disconnect(state int, input interface{}, output interface{}, data interface{}) {
	module := data.(*LoadPackageModule)
	packet := DantePacketNew(DISCONNECT, []byte{})
	module.ToDockLink <- *packet
}

func LoadPackageModuleNew(toDockLink chan DantePacket, packageData []byte) *LoadPackageModule {
	var module LoadPackageModule
	module.DockModule.DockModuleInit(toDockLink, &module)
	module.packageData = packageData
	module.stateTable = map[int][]fsm.State{
		LOAD_PACKAGE_IDLE: {{Input: DantePacketCommand{RESULT}, NewState: LOAD_PACKAGE_UP, Action: loadPackage}},
		LOAD_PACKAGE_UP:   {{Input: DantePacketCommand{RESULT}, NewState: LOAD_PACKAGE_IDLE, Action: disconnect}},
	}
	module.reader()
	return &module
}
