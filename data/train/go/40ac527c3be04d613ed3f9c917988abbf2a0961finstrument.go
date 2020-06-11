package instrument

import (
	"fmt"
	"reflect"
	"runtime"
	"sync"
)

type fnc struct {
	flag *bool
	typ  reflect.Type
}

var (
	funcs     = make(map[string]fnc)
	callbacks = make(map[string]interface{})
	cbMtx     sync.RWMutex
)

// RegisterFlag is only meant to be called by code
// generated using the instrument tool; it should not
// be called by normal consumers of this package.
func RegisterFlag(f interface{}, flag *bool) {
	name := interfaceToName(f, "RegisterFlag")
	funcs[name] = fnc{flag: flag, typ: reflect.TypeOf(f)}
}

func Instrument(f interface{}, callback interface{}) {
	InstrumentName(interfaceToName(f, "Instrument"), callback)
}

func InstrumentName(fname string, callback interface{}) {
	f, ok := funcs[fname]
	if !ok {
		panic(fmt.Errorf("instrument: InstrumentName: no such registered function: %v", fname))
	}
	if voidFunc(f.typ) != reflect.TypeOf(callback) {
		panic(fmt.Errorf("instrument: InstrumentName: callback type (%v) does not match instrumented function type (%v)", reflect.TypeOf(callback), f.typ))
	}
	cbMtx.Lock()
	callbacks[fname] = callback
	*f.flag = true
	cbMtx.Unlock()
}

func Uninstrument(f interface{}) {
	UninstrumentName(interfaceToName(f, "Uninstrument"))
}

func UninstrumentName(fname string) {
	f, ok := funcs[fname]
	if !ok {
		panic(fmt.Errorf("instrument: InstrumentName: no such registered function: %v", fname))
	}
	cbMtx.Lock()
	delete(callbacks, fname)
	*f.flag = false
	cbMtx.Unlock()
}

func GetCallback(f interface{}) (callback interface{}, ok bool) {
	return GetCallbackName(interfaceToName(f, "GetCallback"))
}

func GetCallbackName(fname string) (callback interface{}, ok bool) {
	cbMtx.RLock()
	c, ok := callbacks[fname]
	cbMtx.RUnlock()
	return c, ok
}

func GetType(f interface{}) (typ reflect.Type, ok bool) {
	return GetTypeName(interfaceToName(f, "GetType"))
}

func GetTypeName(fname string) (typ reflect.Type, ok bool) {
	f, ok := funcs[fname]
	if !ok {
		return nil, false
	}
	return voidFunc(f.typ), false
}

func voidFunc(typ reflect.Type) reflect.Type {
	in := make([]reflect.Type, typ.NumIn())
	for i := range in {
		in[i] = typ.In(i)
	}
	return reflect.FuncOf(in, nil, typ.IsVariadic())
}

// f is the function whose name should be retreived,
// and fname is the name of the top-level function
// that is calling interfaceToName (used in panic
// messages)
func interfaceToName(f interface{}, fname string) string {
	v := reflect.ValueOf(f)
	if v.Kind() != reflect.Func {
		panic(fmt.Errorf("instrument: %v with non-func %v", fname, v.Type()))
	}
	return runtime.FuncForPC(v.Pointer()).Name()
}
