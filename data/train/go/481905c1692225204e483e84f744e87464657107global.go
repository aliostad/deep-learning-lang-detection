package main

import (
	"fmt"
	"time"
)

var GEnvManager *EnvManager = NewEnvManager()
var GLogManager *LoggerManager = NewLogManager()
var GNetworkManager *NetworkManager = NewNetworkManager()

//var GDbManager *DBManager = GetDBManager()
var GDBJob *DBJob = GetDBJob()
var GEventDataManager *DnfEventDataManager = GetDnfEventDataManager()

var gGlobalScope GLOBAL_SCOPE = GLOBAL_SCOPE{}

//단위 second 5분
const DEFAULT_DB_GOROTUINE_MINUTE time.Duration = 300

type I_GLOBAL interface {
	Init()
}

type GLOBAL_ENV struct {
	Env map[string](map[string]string)
}

type GLOBAL_SCOPE struct {
}

func (g *GLOBAL_SCOPE) Init() {
	//환경설정 파일 로드
	GEnvManager.Init()

	//로그파일 생성
	GLogManager.Init()

	GetDBJob().Init()

	GNetworkManager.Init()

	GEventDataManager.Init()

}

func raisePanic(format string, argv ...interface{}) {
	panicMsg := fmt.Sprintf(format, argv...)
	panic(panicMsg)

}
