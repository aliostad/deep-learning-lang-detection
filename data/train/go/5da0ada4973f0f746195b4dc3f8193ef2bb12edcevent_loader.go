package loader

import "github.com/ymohl-cl/gomoku/conf"

/*
** Endpoint action from objects click
 */

func (l *Load) addLoadingBar() {
	x, _ := l.loadBlock.GetPosition()
	w, h := l.loadBlock.GetSize()
	// check next width [padding x + blockWidt] + [width current] + [width next block]
	if x+conf.LoadBlockWidth+w+conf.LoadBlockWidth > conf.WindowWidth-conf.LoadBlockWidth {
		l.resetLoadingBlock()
	} else {
		l.loadBlock.UpdateSize(w+conf.LoadBlockWidth, h)
	}
}

func (l *Load) resetLoadingBlock() {
	_, h := l.loadBlock.GetSize()
	l.loadBlock.UpdateSize(conf.LoadBlockWidth, h)
}
