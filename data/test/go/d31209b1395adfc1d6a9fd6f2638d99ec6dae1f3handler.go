package instrumenthandler

import (
	"time"

	"golang.org/x/net/context"
	"google.golang.org/grpc"
)

type Instrumentor func(context.Context, *grpc.UnaryServerInfo, time.Duration, error)

var instrumentor Instrumentor

func InstallInstrumentor(inst Instrumentor) {
	instrumentor = inst
}

var _ grpc.UnaryServerInterceptor = UnaryInstrumentHandler

func UnaryInstrumentHandler(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (resp interface{}, err error) {
	defer func(start time.Time) {
		instrumentor(ctx, info, time.Since(start), err)
	}(time.Now())
	return handler(ctx, req)
}
