
package result

import (
	"github.com/ikuo0/game/ebiten_act/instrument"
	"github.com/ikuo0/game/lib/fig"
	"github.com/ikuo0/game/lib/strlib"
	"github.com/hajimehoshi/ebiten"
	"image/color"
	"strings"
)

//########################################
//# Result
//########################################
type Result struct {
	Src        *strlib.Queue
	Dst        *strlib.Queue
	Instrument *instrument.Instrument
	Text       string
}

func (me *Result) Next() {
	if !me.Src.Empty() {
		me.Dst.Push(me.Src.Shift())
	}
	me.Text = strings.Join(me.Dst.Ary(), "\n")
}

func (me *Result) Update(screen *ebiten.Image) {
	me.Instrument.UpdateText(me.Text)
	screen.DrawImage(me.Instrument.Image(), me.Instrument.Options())
}

func (me *Result) IsEnd() (bool) {
	return me.Src.Empty()
}


func New(ary []string) (*Result) {
	srcQ := strlib.NewQueue(ary)
	dstQ := strlib.NewQueue(nil)
	res := &Result {
		Src:        srcQ,
		Dst:        dstQ,
		Instrument: instrument.NewInstrument(fig.IntRect {100, 100, 400, 500}, 24, color.RGBA{0xb2, 0xfa, 0x8e, 0xdd}),
	}
	res.Next()
	return res
}
