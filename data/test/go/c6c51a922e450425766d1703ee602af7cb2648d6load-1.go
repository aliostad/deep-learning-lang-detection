package metrics

import psutil "github.com/shirou/gopsutil/load"

type LoadAVG1Result struct {
	v   float64
	err error
}

func (it *LoadAVG1Result) set(v float64) *LoadAVG1Result  { it.v = v; return it }
func (it *LoadAVG1Result) setErr(v error) *LoadAVG1Result { it.err = v; return it }

func (it *LoadAVG1Result) V() interface{} { return it.v }
func (it *LoadAVG1Result) Name() string   { return "" }
func (it *LoadAVG1Result) Kind() Kind     { return KIND_LOAD_AVG_1 }
func (it *LoadAVG1Result) OK() bool       { return it.err == nil }
func (it *LoadAVG1Result) Err() error     { return it.err }

func NewLoadAVG1Result() *LoadAVG1Result { return new(LoadAVG1Result) }

type loadAVG1 struct{}

func (it *loadAVG1) Collect(stat *psutil.AvgStat, e error) Result {
	result := NewLoadAVG1Result()
	if e != nil {
		return result.setErr(e)
	} else {
		result.set(stat.Load1)
	}
	return result
}

func LoadAVG1() *loadAVG1 { return new(loadAVG1) }
