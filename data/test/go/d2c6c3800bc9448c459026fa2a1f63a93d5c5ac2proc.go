package loading

import (
	"fmt"
	"github.com/dradtke/allegory"
	"github.com/dradtke/allegory-example/main/game"
	"github.com/dradtke/allegory/cache"
	"os"
)

type load struct {
	Images  []string
	loading bool
}

var _ allegory.Process = (*load)(nil)

func (p *load) InitProcess() {
	p.loading = true
	go func() {
		errs := cache.LoadImages(p.Images)
		for _, err := range errs {
			fmt.Fprintf(os.Stderr, "%s\n", err.Error())
		}
		p.loading = false
	}()
}

func (p *load) HandleMessage(msg interface{}) error {
	return nil
}

func (p *load) Tick() (bool, error) {
	return p.loading, nil
}

func (p *load) CleanupProcess() {
	game.Play()
}
