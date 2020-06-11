package metrics

import psutil "github.com/shirou/gopsutil/load"

type LoadAVG15Result struct {
	v   float64
	err error
}

func (it *LoadAVG15Result) set(v float64) *LoadAVG15Result  { it.v = v; return it }
func (it *LoadAVG15Result) setErr(v error) *LoadAVG15Result { it.err = v; return it }

func (it *LoadAVG15Result) V() interface{} { return it.v }
func (it *LoadAVG15Result) Name() string   { return "" }
func (it *LoadAVG15Result) Kind() Kind     { return KIND_LOAD_AVG_15 }
func (it *LoadAVG15Result) OK() bool       { return it.err == nil }
func (it *LoadAVG15Result) Err() error     { return it.err }

func NewLoadAVG15Result() *LoadAVG15Result { return new(LoadAVG15Result) }

type loadAVG15 struct{}

func (it *loadAVG15) Collect(stat *psutil.AvgStat, e error) Result {
	result := NewLoadAVG15Result()
	if e != nil {
		return result.setErr(e)
	} else {
		result.set(stat.Load15)
	}
	return result
}

func LoadAVG15() *loadAVG15 { return new(loadAVG15) }
