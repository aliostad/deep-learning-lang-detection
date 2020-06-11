
package instrument

import (
	"github.com/ikuo0/game/lib/fig"
	"github.com/ikuo0/game/lib/fontmap"
	"github.com/ikuo0/game/lib/log"
	"github.com/hajimehoshi/ebiten"
	"image/color"
	"os"
)

//########################################
//# Instrument
//########################################
type Instrument struct {
	Rect    fig.IntRect
	BgColor color.RGBA
	Font    *fontmap.FontMap
	Canvas  *ebiten.Image
}

func (me *Instrument) Len() (int) {
	return 1
}
func (me *Instrument) Src(i int) (x0, y0, x1, y1 int) {
	return 0, 0, me.Rect.Width(), me.Rect.Height()
}
func (me *Instrument) Dst(i int) (x0, y0, x1, y1 int) {
	r := me.Rect
	return r.Left, r.Top, r.Right, r.Bottom
}
func (me *Instrument) Image() (*ebiten.Image) {
	return me.Canvas
}
/*
func (me *Instrument) Text(text string) {
	me.Text = text
}
*/
func (me *Instrument) UpdateText(text string) {
	//me.Canvas.Fill(color.RGBA{0xb2, 0x9a, 0x8e, 0xff})
	me.Canvas.Fill(me.BgColor)
	me.Font.Draw(me.Canvas, 0, 0, text)
}
func (me *Instrument) Options() (*ebiten.DrawImageOptions) {
	return &ebiten.DrawImageOptions {
		ImageParts: me,
	}
}

func NewInstrument(rect fig.IntRect, fontSize int, bgColor color.RGBA) (*Instrument) {
	if font, e1 := fontmap.New(`./resource/font/ipa/ipag.ttf`, fontSize); e1 != nil {
		log.Log("フォント読み込みエラー: %s", e1.Error())
		os.Exit(1)
		return nil
	} else {
		canvas, _ := ebiten.NewImage(rect.Width(), rect.Height(), ebiten.FilterLinear)
		return &Instrument {
			Rect:    rect,
			BgColor: bgColor,
			Font:    font,
			Canvas:  canvas,
		}
	}
}
