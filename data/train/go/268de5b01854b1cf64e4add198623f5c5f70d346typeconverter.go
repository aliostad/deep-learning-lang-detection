package typeconverter

import (
	"fmt"
	"time"

	"gopkg.in/metakeule/dispatch.v1"
)

type Converter interface {
	Convert(from interface{}, to interface{}) (err error)
}

type BasicConverter struct {
	Output *dispatch.Dispatcher
	Input  *dispatch.Dispatcher
}

func (ø *BasicConverter) Convert(from interface{}, to interface{}) (err error) {
	defer func() {
		if r := recover(); r != nil {
			err = fmt.Errorf("%s", r)
		}
	}()
	err = ø.Input.Dispatch(from, to)
	return
}

var intInstance = int(0)
var int32Instance = int32(0)
var int64Instance = int64(0)
var float64Instance = float64(0)
var float32Instance = float32(0)
var stringInstance = string("")
var jsonInstance = Json("")
var xmlInstance = Xml("")
var boolInstance = bool(true)
var timeInstance = time.Time{}
var mapInstance = map[string]interface{}{}
var arrInstance = []interface{}{}

var basicConvert = New()

func Convert(from interface{}, to interface{}) (err error) { return basicConvert.Convert(from, to) }

func New() (ø *BasicConverter) {
	ø = &BasicConverter{dispatch.New(), dispatch.New()}

	inSwitch := func(from interface{}, to interface{}) (err error) {
		switch t := from.(type) {
		case int:
			err = ø.Output.Dispatch(to, Int(t))
		case int32:
			err = ø.Output.Dispatch(to, Int(int(t)))
		case int64:
			err = ø.Output.Dispatch(to, Int64(t))
		case float64:
			err = ø.Output.Dispatch(to, Float(t))
		case float32:
			err = ø.Output.Dispatch(to, Float32(t))
		case string:
			err = ø.Output.Dispatch(to, String(t))
		case bool:
			err = ø.Output.Dispatch(to, Bool(t))
		case time.Time:
			err = ø.Output.Dispatch(to, Time(t))
		case map[string]interface{}:
			err = ø.Output.Dispatch(to, Map(t))
		case []interface{}:
			err = ø.Output.Dispatch(to, Array(t))
		default:
			err = ø.Output.Dispatch(to, t)
		}
		return
	}

	ø.Input.SetHandler(intInstance, inSwitch)
	ø.Input.SetHandler(int32Instance, inSwitch)
	ø.Input.SetHandler(int64Instance, inSwitch)
	ø.Input.SetHandler(float64Instance, inSwitch)
	ø.Input.SetHandler(float32Instance, inSwitch)
	ø.Input.SetHandler(stringInstance, inSwitch)
	ø.Input.SetHandler(boolInstance, inSwitch)
	ø.Input.SetHandler(timeInstance, inSwitch)
	ø.Input.SetHandler(mapInstance, inSwitch)
	ø.Input.SetHandler(arrInstance, inSwitch)
	ø.Input.SetHandler(xmlInstance, inSwitch)

	ø.Input.AddFallback(func(in interface{}, out interface{}) (didHandle bool, err error) {
		didHandle = true
		err = ø.Output.Dispatch(out, in)
		return
	})

	outSwitcher := func(out interface{}, in interface{}) (err error) {
		switch t := out.(type) {
		case *bool:
			*out.(*bool) = in.(Booler).Bool()
		case *int:
			*out.(*int) = in.(Inter).Int()
		case *int64:
			*out.(*int64) = int64(in.(Inter).Int())
		case *string:
			*out.(*string) = in.(Stringer).String()
		case *float64:
			*out.(*float64) = in.(Floater).Float()
		case *float32:
			*out.(*float32) = float32(in.(Floater).Float())
		case *time.Time:
			*out.(*time.Time) = in.(Timer).Time()
		case *JsonType:
			*out.(*JsonType) = Json(in.(Jsoner).Json())
		case *XmlType:
			*out.(*XmlType) = Xml(in.(Xmler).Xml())
		case *map[string]interface{}:
			*out.(*map[string]interface{}) = in.(Mapper).Map()
		case *[]interface{}:
			*out.(*[]interface{}) = in.(Arrayer).Array()
		default:
			return fmt.Errorf("can't convert to %#v: no converter found", t)
		}
		return
	}

	ø.Output.SetHandler(&boolInstance, outSwitcher)
	ø.Output.SetHandler(&intInstance, outSwitcher)
	ø.Output.SetHandler(&int32Instance, outSwitcher)
	ø.Output.SetHandler(&int64Instance, outSwitcher)
	ø.Output.SetHandler(&stringInstance, outSwitcher)
	ø.Output.SetHandler(&float64Instance, outSwitcher)
	ø.Output.SetHandler(&float32Instance, outSwitcher)
	ø.Output.SetHandler(&timeInstance, outSwitcher)
	ø.Output.SetHandler(&jsonInstance, outSwitcher)
	ø.Output.SetHandler(&mapInstance, outSwitcher)
	ø.Output.SetHandler(&arrInstance, outSwitcher)
	ø.Output.SetHandler(&xmlInstance, outSwitcher)
	return
}
