package exec

import (
	"context"
	"errors"
	"reflect"
	"sync"

	integrationkit "github.com/simonferquel/integration-kit"
)

// DispatchF is a callback that we want to dispatch on a node in the cluster
type DispatchF func(ctx context.Context, node *integrationkit.Node) error

// ErrNodeNotFound is returned when the dispatcher can't find a node satisfying the search predicate
var ErrNodeNotFound = errors.New("No node satisfies the predicate")

// Dispatcher dispatches tasks accross nodes in a cluster
type Dispatcher interface {
	Run(ctx context.Context, predicate integrationkit.NodePredicate, wholeClusterLock bool, f DispatchF) error
}

type dispatchOp struct {
	ctx              context.Context
	f                DispatchF
	res              chan error
	wholeClusterLock bool
}

type dispatcher struct {
	cluster           *integrationkit.Cluster
	workers           map[*integrationkit.Node]chan dispatchOp
	wholeClusterMutex sync.RWMutex
}

func (d *dispatcher) Run(ctx context.Context, predicate integrationkit.NodePredicate, wholeClusterLock bool, f DispatchF) error {
	nodes := d.cluster.FindNodes(predicate)
	if len(nodes) == 0 {
		return ErrNodeNotFound
	}
	res := make(chan error)
	cases := []reflect.SelectCase{reflect.SelectCase{
		Chan: reflect.ValueOf(ctx.Done()),
		Dir:  reflect.SelectRecv,
	}}
	op := dispatchOp{
		ctx:              ctx,
		f:                f,
		res:              res,
		wholeClusterLock: wholeClusterLock,
	}
	for _, n := range nodes {
		cases = append(cases, reflect.SelectCase{
			Chan: reflect.ValueOf(d.workers[n]),
			Dir:  reflect.SelectSend,
			Send: reflect.ValueOf(op),
		})
	}
	ix, _, _ := reflect.Select(cases)
	if ix == 0 { // context cancelled
		go func() {
			res <- errors.New("context cancelled")
		}()
	}

	return <-res
}

func handleOperation(d *dispatcher, node *integrationkit.Node, op dispatchOp) {
	if op.wholeClusterLock {
		d.wholeClusterMutex.Lock()
		defer d.wholeClusterMutex.Unlock()
	} else {
		d.wholeClusterMutex.RLock()
		defer d.wholeClusterMutex.RUnlock()
	}

	op.res <- op.f(op.ctx, node)
}

// NewDispatcher creates a dispatcher for running tasks to the cluster.
// To stop the scheduler, just cancel the given ctx
func NewDispatcher(ctx context.Context, cluster *integrationkit.Cluster) Dispatcher {
	d := &dispatcher{
		cluster: cluster,
		workers: make(map[*integrationkit.Node]chan dispatchOp),
	}
	for _, n := range cluster.Nodes {
		node := n
		c := make(chan dispatchOp)
		d.workers[node] = c
		go func() {
			for {
				select {
				case op := <-c:
					handleOperation(d, node, op)
				case <-ctx.Done():
					return
				}
			}
		}()
	}
	return d
}
