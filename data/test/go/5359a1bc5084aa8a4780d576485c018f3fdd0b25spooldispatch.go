package isolate

import (
	"fmt"

	"github.com/tinylib/msgp/msgp"

	"github.com/noxiouz/stout/pkg/log"
	"golang.org/x/net/context"
)

const (
	spoolCancel = 0

	replyCancelOk    = 0
	replyCancelError = 1
)

type spoolCancelationDispatch struct {
	ctx context.Context

	cancel context.CancelFunc

	stream ResponseStream
}

func newSpoolCancelationDispatch(ctx context.Context, cancel context.CancelFunc, stream ResponseStream) *spoolCancelationDispatch {
	return &spoolCancelationDispatch{
		ctx:    ctx,
		cancel: cancel,
		stream: stream,
	}
}

func (s *spoolCancelationDispatch) Handle(id uint64, r *msgp.Reader) (Dispatcher, error) {
	switch id {
	case spoolCancel:
		// Skip empty array
		log.G(s.ctx).Debug("Spool.Cancel()")
		r.Skip()
		// TODO: cancel only if I'm spooling
		s.cancel()
		// NOTE: do not return an err on purpose
		s.stream.Close(s.ctx, replySpoolOk)
		return nil, nil
	default:
		return nil, fmt.Errorf("unknown transition id: %d", id)
	}
}
