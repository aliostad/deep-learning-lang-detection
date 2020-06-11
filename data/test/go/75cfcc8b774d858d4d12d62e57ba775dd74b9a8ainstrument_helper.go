// +build instrument

package main

import "local/research/instrument"

var (
	__instrument_func_main          bool
	__instrument_func_processDir    bool
	__instrument_func_funcToEntry   bool
	__instrument_func_parseStmt     bool
	__instrument_func_zeroPos       bool
	__instrument_func_zeroPosHelper bool
	__instrument_func_nodeString    bool
)

func init() {
	instrument.RegisterFlag(main, &__instrument_func_main)
	instrument.RegisterFlag(processDir, &__instrument_func_processDir)
	instrument.RegisterFlag(funcToEntry, &__instrument_func_funcToEntry)
	instrument.RegisterFlag(parseStmt, &__instrument_func_parseStmt)
	instrument.RegisterFlag(zeroPos, &__instrument_func_zeroPos)
	instrument.RegisterFlag(zeroPosHelper, &__instrument_func_zeroPosHelper)
	instrument.RegisterFlag(nodeString, &__instrument_func_nodeString)
}
