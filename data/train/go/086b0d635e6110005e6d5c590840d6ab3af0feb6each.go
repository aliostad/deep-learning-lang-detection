package greenspun

import (
	"reflect"
	"unsafe"
)

//	TO DO:
//	Implement EachBy(step int, f interface{}) which wraps f:
//
//		func() {
//			i := 0
//			if i % step == 0 {
//				f()
//			}
//		}
//
//	Where the function signature matches that of f

type Iterable interface {
	Each(f interface{})
}

func Each(s interface{}, f interface{}) {
	switch s := s.(type) {
	case Iterable:
		s.Each(f)

	case complex64:
		switch f := f.(type) {
		case func(v complex64):
			f(s)
		case func(i int, v complex64):
			f(0, s)
		case func(i interface{}, v complex64):
			f(0, s)
		case func(m, v complex64) complex64:
			f(0, s)
		case func(i int, m, v complex64) complex64:
			f(0, 0, s)
		case func(i interface{}, m, v complex64) complex64:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case complex128:
		switch f := f.(type) {
		case func(v complex128):
			f(s)
		case func(i int, v complex128):
			f(0, s)
		case func(i interface{}, v complex128):
			f(0, s)
		case func(m, v complex128) complex128:
			f(0, s)
		case func(i int, m, v complex128) complex128:
			f(0, 0, s)
		case func(i interface{}, m, v complex128) complex128:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case error:
		switch f := f.(type) {
		case func(v error):
			f(s)
		case func(i int, v error):
			f(0, s)
		case func(i interface{}, v error):
			f(0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case float32:
		switch f := f.(type) {
		case func(v float32):
			f(s)
		case func(i int, v float32):
			f(0, s)
		case func(i interface{}, v float32):
			f(0, s)
		case func(m, v float32) float32:
			f(0, s)
		case func(i int, m, v float32) float32:
			f(0, 0, s)
		case func(i interface{}, m, v float32) float32:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case float64:
		switch f := f.(type) {
		case func(v float64):
			f(s)
		case func(i int, v float64):
			f(0, s)
		case func(i interface{}, v float64):
			f(0, s)
		case func(m, v float64) float64:
			f(0, s)
		case func(i int, m, v float64) float64:
			f(0, 0, s)
		case func(i interface{}, m, v float64) float64:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case int:
		switch f := f.(type) {
		case func(v int):
			f(s)
		case func(i, v int):
			f(0, s)
		case func(i interface{}, v int):
			f(0, s)
		case func(m, v int) int:
			f(0, s)
		case func(i, m, v int) int:
			f(0, 0, s)
		case func(i interface{}, m, v int) int:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case int8:
		switch f := f.(type) {
		case func(v int8):
			f(s)
		case func(i int, v int8):
			f(0, s)
		case func(i interface{}, v int8):
			f(0, s)
		case func(m, v int8) int8:
			f(0, s)
		case func(i int, m, v int8) int8:
			f(0, 0, s)
		case func(i interface{}, m, v int8) int8:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case int16:
		switch f := f.(type) {
		case func(v int16):
			f(s)
		case func(i int, v int16):
			f(0, s)
		case func(i interface{}, v int16):
			f(0, s)
		case func(m, v int16) int16:
			f(0, s)
		case func(i int, m, v int16) int16:
			f(0, 0, s)
		case func(i interface{}, m, v int16) int16:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case int32:
		switch f := f.(type) {
		case func(v int32):
			f(s)
		case func(i int, v int32):
			f(0, s)
		case func(i interface{}, v int32):
			f(0, s)
		case func(m, v int32) int32:
			f(0, s)
		case func(i int, m, v int32) int32:
			f(0, 0, s)
		case func(i interface{}, m, v int32) int32:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case int64:
		switch f := f.(type) {
		case func(v int64):
			f(s)
		case func(i int, v int64):
			f(0, s)
		case func(i interface{}, v int64):
			f(0, s)
		case func(m, v int64) int64:
			f(0, s)
		case func(i int, m, v int64) int64:
			f(0, 0, s)
		case func(i interface{}, m, v int64) int64:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case interface{}:
		switch f := f.(type) {
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case string:
		switch f := f.(type) {
		case func(v rune):
			for _, v := range s {
				f(v)
			}
		case func(i int, v rune):
			for i, v := range s {
				f(i, v)
			}
		case func(i interface{}, v rune):
			for i, v := range s {
				f(i, v)
			}
		case func(m, v rune) rune:
			var m rune
			for _, v := range s {
				f(m, v)
			}
		case func(i int, m, v rune) rune:
			var m rune
			for i, v := range s {
				f(i, m, v)
			}
		case func(i interface{}, m, v rune) rune:
			var m rune
			for i, v := range s {
				f(i, m, v)
			}
		case func(v interface{}):
			for _, v := range s {
				f(v)
			}
		case func(i int, v interface{}):
			for i, v := range s {
				f(i, v)
			}
		case func(i, v interface{}):
			for i, v := range s {
				f(i, v)
			}
		case func(m, v interface{}) interface{}:
			var m rune
			for _, v := range s {
				f(m, v)
			}
		case func(i int, m, v interface{}) interface{}:
			var m rune
			for i, v := range s {
				f(i, m, v)
			}
		case func(i interface{}, m, v interface{}) interface{}:
			var m rune
			for i, v := range s {
				f(i, m, v)
			}
		}

	case uint:
		switch f := f.(type) {
		case func(v uint):
			f(s)
		case func(i int, v uint):
			f(0, s)
		case func(i interface{}, v uint):
			f(0, s)
		case func(m, v uint) uint:
			f(0, s)
		case func(i int, m, v uint) uint:
			f(0, 0, s)
		case func(i interface{}, m, v uint) uint:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case uint8:
		switch f := f.(type) {
		case func(v uint8):
			f(s)
		case func(i int, v uint8):
			f(0, s)
		case func(i interface{}, v uint8):
			f(0, s)
		case func(m, v uint8) uint8:
			f(0, s)
		case func(i int, m, v uint8) uint8:
			f(0, 0, s)
		case func(i interface{}, m, v uint8) uint8:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case uint16:
		switch f := f.(type) {
		case func(v uint16):
			f(s)
		case func(i int, v uint16):
			f(0, s)
		case func(i interface{}, v uint16):
			f(0, s)
		case func(m, v uint16) uint16:
			f(0, s)
		case func(i int, m, v uint16) uint16:
			f(0, 0, s)
		case func(i interface{}, m, v uint16) uint16:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case uint32:
		switch f := f.(type) {
		case func(v uint32):
			f(s)
		case func(i int, v uint32):
			f(0, s)
		case func(i interface{}, v uint32):
			f(0, s)
		case func(m, v uint32) uint32:
			f(0, s)
		case func(i int, m, v uint32) uint32:
			f(0, 0, s)
		case func(i interface{}, m, v uint32) uint32:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case uint64:
		switch f := f.(type) {
		case func(v uint64):
			f(s)
		case func(i int, v uint64):
			f(0, s)
		case func(i interface{}, v uint64):
			f(0, s)
		case func(m, v uint64) uint64:
			f(0, s)
		case func(i int, m, v uint64) uint64:
			f(0, 0, s)
		case func(i interface{}, m, v uint64) uint64:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case uintptr:
		switch f := f.(type) {
		case func(v uintptr):
			f(s)
		case func(i int, v uintptr):
			f(0, s)
		case func(i interface{}, v uintptr):
			f(0, s)
		case func(m, v uintptr) uintptr:
			f(0, s)
		case func(i int, m, v uintptr) uintptr:
			f(0, 0, s)
		case func(i interface{}, m, v uintptr) uintptr:
			f(0, 0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case reflect.Value:
		switch s.Kind() {
		case reflect.Array, reflect.Slice, reflect.String:
			switch f := f.(type) {
			case func(reflect.Value):
				for i := 0; i < s.Len(); i++ {
					f(s.Index(i))
				}
			case func(int, reflect.Value):
				for i := 0; i < s.Len(); i++ {
					f(i, s.Index(i))
				}
			case func(interface{}, reflect.Value):
				for i := 0; i < s.Len(); i++ {
					f(i, s.Index(i))
				}
			case func(m, v reflect.Value) reflect.Value:
				var m reflect.Value
				for i := 0; i < s.Len(); i++ {
					m = f(m, s.Index(i))
				}
			case func(i int, m, v reflect.Value) reflect.Value:
				var m reflect.Value
				for i := 0; i < s.Len(); i++ {
					m = f(i, m, s.Index(i))
				}
			case func(i interface{}, m, v reflect.Value) reflect.Value:
				var m reflect.Value
				for i := 0; i < s.Len(); i++ {
					f(i, m, s.Index(i))
				}
			case func(interface{}):
				for i := 0; i < s.Len(); i++ {
					f(s.Index(i).Interface())
				}
			case func(int, interface{}):
				for i := 0; i < s.Len(); i++ {
					f(i, s.Index(i).Interface())
				}
			case func(interface{}, interface{}):
				for i := 0; i < s.Len(); i++ {
					f(i, s.Index(i).Interface())
				}
			case func(m, v interface{}) interface{}:
				var m interface{}
				for i := 0; i < s.Len(); i++ {
					m = f(m, s.Index(i).Interface())
				}
			case func(i int, m, v interface{}) interface{}:
				var m interface{}
				for i := 0; i < s.Len(); i++ {
					m = f(i, m, s.Index(i).Interface())
				}
			case func(i, m, v interface{}) interface{}:
				var m interface{}
				for i := 0; i < s.Len(); i++ {
					m = f(i, m, s.Index(i).Interface())
				}
			}
		case reflect.Chan:
			switch f := f.(type) {
			case func(reflect.Value):
				for v, ok := s.Recv(); ok; v, ok = s.Recv() {
					f(v)
				}
			case func(int, reflect.Value):
				var i int
				for v, ok := s.Recv(); ok; v, ok = s.Recv() {
					f(i, v)
					i++
				}
			case func(interface{}, reflect.Value):
				var i int
				for v, ok := s.Recv(); ok; v, ok = s.Recv() {
					f(i, v)
					i++
				}
			case func(m, v reflect.Value) reflect.Value:
				var m reflect.Value
				for v, ok := s.Recv(); ok; v, ok = s.Recv() {
					m = f(m, v)
				}
			case func(i int, m, v reflect.Value) reflect.Value:
				var m reflect.Value
				var i int
				for v, ok := s.Recv(); ok; v, ok = s.Recv() {
					m = f(i, m, v)
					i++
				}
			case func(i interface{}, m, v reflect.Value) reflect.Value:
				var m reflect.Value
				var i int
				for v, ok := s.Recv(); ok; v, ok = s.Recv() {
					m = f(i, m, v)
					i++
				}
			case func(interface{}):
				for v, ok := s.Recv(); ok; v, ok = s.Recv() {
					f(v.Interface())
				}
			case func(int, interface{}):
				var i int
				for v, ok := s.Recv(); ok; v, ok = s.Recv() {
					f(i, v.Interface())
					i++
				}
			case func(interface{}, interface{}):
				var i int
				for v, ok := s.Recv(); ok; v, ok = s.Recv() {
					f(i, v.Interface())
					i++
				}
			case func(m, v interface{}) interface{}:
				var m interface{}
				for v, ok := s.Recv(); ok; v, ok = s.Recv() {
					m = f(m, v.Interface())
				}
			case func(i int, m, v interface{}) interface{}:
				var m interface{}
				var i int
				for v, ok := s.Recv(); ok; v, ok = s.Recv() {
					m = f(i, m, v.Interface())
					i++
				}
			case func(i, m, v interface{}) interface{}:
				var m interface{}
				var i int
				for v, ok := s.Recv(); ok; v, ok = s.Recv() {
					m = f(i, m, v.Interface())
					i++
				}
			}
		case reflect.Map:
			switch f := f.(type) {
			case func(v reflect.Value):
				for _, k := range s.MapKeys() {
					f(s.MapIndex(k))
				}
			case func(k interface{}, v reflect.Value):
				for _, k := range s.MapKeys() {
					f(k.Interface(), s.MapIndex(k))
				}
			case func(k, v reflect.Value):
				for _, k := range s.MapKeys() {
					f(k, s.MapIndex(k))
				}
			case func(m, v reflect.Value) reflect.Value:
				var m reflect.Value
				for _, k := range s.MapKeys() {
					m = f(m, s.MapIndex(k))
				}
			case func(k interface{}, m, v reflect.Value) reflect.Value:
				var m reflect.Value
				for _, k := range s.MapKeys() {
					m = f(k.Interface(), m, s.MapIndex(k))
				}
			case func(k, m, v reflect.Value) reflect.Value:
				var m reflect.Value
				for _, k := range s.MapKeys() {
					m = f(k, m, s.MapIndex(k))
				}
			case func(interface{}):
				for _, k := range s.MapKeys() {
					f(s.MapIndex(k).Interface())
				}
			case func(interface{}, interface{}):
				for _, k := range s.MapKeys() {
					f(k.Interface(), s.MapIndex(k).Interface())
				}
			case func(m, v interface{}) interface{}:
				var m interface{}
				for _, k := range s.MapKeys() {
					m = f(m, s.MapIndex(k).Interface())
				}
			case func(k, m, v interface{}) interface{}:
				var m interface{}
				for _, k := range s.MapKeys() {
					f(k.Interface(), m, s.MapIndex(k).Interface())
				}
			}
		}

	case unsafe.Pointer:
		switch f := f.(type) {
		case func(v unsafe.Pointer):
			f(s)
		case func(i int, v unsafe.Pointer):
			f(0, s)
		case func(i interface{}, v unsafe.Pointer):
			f(0, s)
		case func(v interface{}):
			f(s)
		case func(i int, v interface{}):
			f(0, s)
		case func(i, v interface{}):
			f(0, s)
		case func(m, v interface{}) interface{}:
			f(0, s)
		case func(i int, m, v interface{}) interface{}:
			f(0, 0, s)
		case func(i interface{}, m, v interface{}) interface{}:
			f(0, 0, s)
		}

	case []complex64:
		switch f := f.(type) {
		case func(v complex64):
			for _, v := range s {
				f(v)
			}
		case func(i int, v complex64):
			for i, v := range s {
				f(i, v)
			}
		case func(i interface{}, v complex64):
			for i, v := range s {
				f(i, v)
			}
		case func(m, v complex64) complex64:
			var m complex64
			for _, v := range s {
				m = f(m, v)
			}
		case func(i int, m, v complex64) complex64:
			var m complex64
			for i, v := range s {
				m = f(i, m, v)
			}
		case func(i interface{}, m, v complex64) complex64:
			var m complex64
			for i, v := range s {
				m = f(i, m, v)
			}
		case func(m, v interface{}) interface{}:
			var m interface{}
			for _, v := range s {
				m = f(m, v)
			}
		case func(i int, m, v interface{}) interface{}:
			var m interface{}
			for i, v := range s {
				f(i, m, v)
			}
		case func(i, m, v interface{}) interface{}:
			var m interface{}
			for i, v := range s {
				m = f(i, m, v)
			}
		}

	case []complex128:
		switch f := f.(type) {
		case func(v complex128):
			for _, v := range s {
				f(v)
			}
		case func(i int, v complex128):
			for i, v := range s {
				f(i, v)
			}
		case func(i interface{}, v complex128):
			for i, v := range s {
				f(i, v)
			}
		case func(m, v complex128) complex128:
			var m complex128
			for _, v := range s {
				m = f(m, v)
			}
		case func(i int, m, v complex128) complex128:
			var m complex128
			for i, v := range s {
				m = f(i, m, v)
			}
		case func(i interface{}, m, v complex128) complex128:
			var m complex128
			for i, v := range s {
				m = f(i, m, v)
			}
		case func(m, v interface{}) interface{}:
			var m interface{}
			for _, v := range s {
				m = f(m, v)
			}
		case func(i int, m, v interface{}) interface{}:
			var m interface{}
			for i, v := range s {
				m = f(i, m, v)
			}
		case func(i, m, v interface{}) interface{}:
			var m interface{}
			for i, v := range s {
				m = f(i, m, v)
			}
		}
	case []error:
	case []float32:
	case []float64:
	case []int:
	case []int8:
	case []int16:
	case []int32:
	case []int64:
	case []interface{}:
	case []string:
	case []uint:
	case []uint8:
	case []uint16:
	case []uint32:
	case []uint64:
	case []uintptr:

	case []reflect.Value:
		switch f := f.(type) {
		case func(reflect.Value):
			for _, v := range s {
				f(v)
			}
		case func(int, reflect.Value):
			for i, v := range s {
				f(i, v)
			}
		case func(interface{}, reflect.Value):
			for i, v := range s {
				f(i, v)
			}
		case func(interface{}):
			for _, v := range s {
				f(v)
			}
		case func(int, interface{}):
			for i, v := range s {
				f(i, v)
			}
		case func(interface{}, interface{}):
			for i, v := range s {
				f(i, v)
			}
		}

	case []unsafe.Pointer:

	default:
	}
}
