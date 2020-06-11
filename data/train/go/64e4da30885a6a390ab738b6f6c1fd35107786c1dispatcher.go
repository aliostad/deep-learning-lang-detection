package dispatcher

import (
	"context"

	"github.com/whatedcgveg/v2ray-core/app"
	"github.com/whatedcgveg/v2ray-core/common/net"
	"github.com/whatedcgveg/v2ray-core/transport/ray"
)

// Interface dispatch a packet and possibly further network payload to its destination.
type Interface interface {
	Dispatch(ctx context.Context, dest net.Destination) (ray.InboundRay, error)
}

func FromSpace(space app.Space) Interface {
	if app := space.GetApplication((*Interface)(nil)); app != nil {
		return app.(Interface)
	}
	return nil
}
