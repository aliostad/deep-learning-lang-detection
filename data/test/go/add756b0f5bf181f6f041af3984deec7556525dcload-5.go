package metrics

import psutil "github.com/shirou/gopsutil/load"

type LoadAVG5Result struct {
	v   float64
	err error
}

func (it *LoadAVG5Result) set(v float64) *LoadAVG5Result  { it.v = v; return it }
func (it *LoadAVG5Result) setErr(v error) *LoadAVG5Result { it.err = v; return it }

func (it *LoadAVG5Result) V() interface{} { return it.v }
func (it *LoadAVG5Result) Name() string   { return "" }
func (it *LoadAVG5Result) Kind() Kind     { return KIND_LOAD_AVG_5 }
func (it *LoadAVG5Result) OK() bool       { return it.err == nil }
func (it *LoadAVG5Result) Err() error     { return it.err }

func NewLoadAVG5Result() *LoadAVG5Result { return new(LoadAVG5Result) }

type loadAVG5 struct{}

func (it *loadAVG5) Collect(stat *psutil.AvgStat, e error) Result {
	result := NewLoadAVG5Result()
	if e != nil {
		return result.setErr(e)
	} else {
		result.set(stat.Load5)
	}
	return result
}

func LoadAVG5() *loadAVG5 { return new(loadAVG5) }
