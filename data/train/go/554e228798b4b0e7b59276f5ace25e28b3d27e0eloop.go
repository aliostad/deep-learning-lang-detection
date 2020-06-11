package servicebroker

import (
	"context"
	"errors"

	"github.com/deis/steward-framework"
	"github.com/deis/steward-framework/k8s/data"
	"k8s.io/client-go/pkg/watch"
)

var (
	ErrCancelled         = errors.New("stopped")
	ErrNotAServiceBroker = errors.New("not a service broker")
	ErrWatchClosed       = errors.New("watch closed")
)

// RunLoop starts a blocking control loop that watches and takes action on service broker resources
func RunLoop(
	ctx context.Context,
	namespace string,
	fn WatchServiceBrokerFunc,
	updateFn UpdateServiceBrokerFunc,
	cataloger framework.Cataloger,
	createSvcClassFunc CreateServiceClassFunc) error {
	watcher, err := fn(namespace)
	if err != nil {
		return err
	}
	ch := watcher.ResultChan()
	defer watcher.Stop()
	for {
		select {
		case <-ctx.Done():
			return ErrCancelled
		case evt, open := <-ch:
			if !open {
				watcher, err = fn(namespace)
				if err != nil {
					logger.Errorf("service broker loop watch channel was closed")
					return ErrWatchClosed
				}
				ch = watcher.ResultChan()
			}
			logger.Debugf("service broker loop received event")
			switch evt.Type {
			case watch.Added:
				if err := handleAddServiceBroker(ctx, cataloger, updateFn, createSvcClassFunc, evt); err != nil {
					// TODO: try the handler again. See https://github.com/deis/steward-framework/issues/26
					logger.Errorf("add service broker event handler failed (%s)", err)
				}
			}
		}
	}
}

func handleAddServiceBroker(
	ctx context.Context,
	cataloger framework.Cataloger,
	updateFn UpdateServiceBrokerFunc,
	createServiceClass CreateServiceClassFunc,
	evt watch.Event) error {

	serviceBroker := new(data.ServiceBroker)
	if err := data.TranslateToTPR(evt.Object, serviceBroker, data.ServiceBrokerKind); err != nil {
		return ErrNotAServiceBroker
	}

	serviceBroker.Status.State = data.ServiceBrokerStatePending
	serviceBroker, err := updateFn(serviceBroker)
	if err != nil {
		return err
	}

	finalServiceBrokerState := data.ServiceBrokerStateFailed
	defer func() {
		serviceBroker.Status.State = finalServiceBrokerState
		if _, err := updateFn(serviceBroker); err != nil {
			logger.Errorf("failed to update service broker to state %s (%s)", finalServiceBrokerState, err)
		}
	}()

	svcs, err := cataloger.List(ctx, serviceBroker.Spec)
	if err != nil {
		return err
	}

	for _, svc := range svcs {
		sClass := translateServiceClass(serviceBroker, svc)
		if err := createServiceClass(sClass); err != nil {
			return err
		}
	}
	finalServiceBrokerState = data.ServiceBrokerStateAvailable
	return nil
}
