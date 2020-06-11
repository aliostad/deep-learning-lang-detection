package trace

import (
	"fmt"
	"reflect"
	"runtime"

	"golang.org/x/net/context"

	"github.com/brownsys/tracing-framework-go/trace/internal/instrument"
)

func GetType(f interface{}) (typ reflect.Type, ok bool) {
	return instrument.GetType(f)
}

func GetTypeName(fname string) (typ reflect.Type, ok bool) {
	return instrument.GetTypeName(fname)
}

func Instrument(f interface{}, callback func(ctx context.Context, args []reflect.Value)) {
	InstrumentName(interfaceToName(f, "Instrument"), callback)
}

func InstrumentName(fname string, callback func(ctx context.Context, args []reflect.Value)) {
	typ, _ := instrument.GetTypeName(fname)
	f := func(args []reflect.Value) []reflect.Value {
		var ctx context.Context
		if c := runtime.GetLocal(); c != nil {
			ctx = c.(context.Context)
		}
		callback(ctx, args)
		return nil
	}
	instrument.InstrumentName(fname, reflect.MakeFunc(typ, f).Interface())
}

func Uninstrument(f interface{}) {
	instrument.Uninstrument(f)
}

func UninstrumentName(fname string) {
	instrument.UninstrumentName(fname)
}

// f is the function whose name should be retreived,
// and fname is the name of the top-level function
// that is calling interfaceToName (used in panic
// messages)
func interfaceToName(f interface{}, fname string) string {
	v := reflect.ValueOf(f)
	if v.Kind() != reflect.Func {
		panic(fmt.Errorf("trace: %v with non-func %v", fname, v.Type()))
	}
	return runtime.FuncForPC(v.Pointer()).Name()
}
