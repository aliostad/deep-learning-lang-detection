package isolate

import (
	"fmt"
	"sync/atomic"

	"github.com/tinylib/msgp/msgp"
	"github.com/noxiouz/stout/pkg/log"

	"golang.org/x/net/context"
)

const (
	spawnKill = 0

	replyKillOk    = 2
	replyKillError = 1
)

type spawnDispatch struct {
	ctx         context.Context
	cancelSpawn context.CancelFunc

	stream  ResponseStream
	killed  *uint32
	process <-chan Process
}

func newSpawnDispatch(ctx context.Context, cancelSpawn context.CancelFunc, prCh <-chan Process, flagKilled *uint32, stream ResponseStream) *spawnDispatch {
	return &spawnDispatch{
		ctx: ctx,

		stream:      stream,
		cancelSpawn: cancelSpawn,
		killed:      flagKilled,
		process:     prCh,
	}
}

func (d *spawnDispatch) Handle(id uint64, r *msgp.Reader) (Dispatcher, error) {
	switch id {
	case spawnKill:
		r.Skip()
		go d.asyncKill()
		// NOTE: do not return an err on purpose
		return nil, nil
	default:
		return nil, fmt.Errorf("unknown transition id: %d", id)
	}
}

func (d *spawnDispatch) asyncKill() {
	// There are 3 cases:
	// * If the process has been spawned - kill it
	// * if the process has not been spawned yet - cancel it
	//		It's not our repsonsibility to clean up resources and kill anything
	// * if ctx has been cancelled - exit
	select {
	case pr, ok := <-d.process:
		if !ok {
			// we will not receive the process
			// initialDispatch has closed the channel
			return
		}

		if atomic.CompareAndSwapUint32(d.killed, 0, 1) {
			killMeter.Mark(1)
			log.G(d.ctx).Info("Get kill request from channel in spawnDispatch module.")
			if err := pr.Kill(); err != nil {
				d.stream.Error(d.ctx, replyKillError, errKillError, err.Error())
				return
			}

			d.stream.Close(d.ctx, replyKillOk)
		}
	case <-d.ctx.Done():
		// NOTE: should we kill anything here?
	default:
		// cancel spawning process
		spawnCancelMeter.Mark(1)
		d.cancelSpawn()
	}
}
