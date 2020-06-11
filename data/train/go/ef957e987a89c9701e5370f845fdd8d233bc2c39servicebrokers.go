package client

import (
	servicebrokerapi "github.com/openshift/origin/pkg/servicebroker/api"
	"k8s.io/kubernetes/pkg/watch"
	kapi "k8s.io/kubernetes/pkg/api"
)

// ServiceBrokersInterface has methods to work with ServiceBroker resources in a namespace
type ServiceBrokersInterface interface {
	ServiceBrokers() ServiceBrokerInterface
}

// ServiceBrokerInterface exposes methods on project resources.
type ServiceBrokerInterface interface {
	Create(p *servicebrokerapi.ServiceBroker) (*servicebrokerapi.ServiceBroker, error)
	Delete(name string) error
	Update(p *servicebrokerapi.ServiceBroker) (*servicebrokerapi.ServiceBroker, error)
	Get(name string) (*servicebrokerapi.ServiceBroker, error)
	List(opts kapi.ListOptions) (*servicebrokerapi.ServiceBrokerList, error)
	Watch(opts kapi.ListOptions) (watch.Interface, error)
}

type serviceBrokers struct {
	r *Client
}

// newUsers returns a project
func newServiceBrokers(c *Client) *serviceBrokers {
	return &serviceBrokers{
		r: c,
	}
}

// Get returns information about a particular project or an error
func (c *serviceBrokers) Get(name string) (result *servicebrokerapi.ServiceBroker, err error) {
	result = &servicebrokerapi.ServiceBroker{}
	err = c.r.Get().Resource("serviceBrokers").Name(name).Do().Into(result)
	return
}

// List returns all serviceBrokers matching the label selector
func (c *serviceBrokers) List(opts kapi.ListOptions) (result *servicebrokerapi.ServiceBrokerList, err error) {
	result = &servicebrokerapi.ServiceBrokerList{}
	err = c.r.Get().
		Resource("serviceBrokers").
		VersionedParams(&opts, kapi.ParameterCodec).
		Do().
		Into(result)
	return
}

// Create creates a new ServiceBroker
func (c *serviceBrokers) Create(p *servicebrokerapi.ServiceBroker) (result *servicebrokerapi.ServiceBroker, err error) {
	result = &servicebrokerapi.ServiceBroker{}
	err = c.r.Post().Resource("serviceBrokers").Body(p).Do().Into(result)
	return
}

// Update updates the project on server
func (c *serviceBrokers) Update(p *servicebrokerapi.ServiceBroker) (result *servicebrokerapi.ServiceBroker, err error) {
	result = &servicebrokerapi.ServiceBroker{}
	err = c.r.Put().Resource("serviceBrokers").Name(p.Name).Body(p).Do().Into(result)
	return
}

// Delete removes the project on server
func (c *serviceBrokers) Delete(name string) (err error) {
	err = c.r.Delete().Resource("serviceBrokers").Name(name).Do().Error()
	return
}

// Watch returns a watch.Interface that watches the requested serviceBrokers
func (c *serviceBrokers) Watch(opts kapi.ListOptions) (watch.Interface, error) {
	return c.r.Get().
		Prefix("watch").
		Resource("serviceBrokers").
		VersionedParams(&opts, kapi.ParameterCodec).
		Watch()
}
