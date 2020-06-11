package db

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestLoadBalancer(t *testing.T) {
	t.Parallel()

	conn := New()

	var id int
	conn.Txn(LoadBalancerTable).Run(func(view Database) error {
		loadBalancer := view.InsertLoadBalancer()
		id = loadBalancer.ID
		loadBalancer.Name = "foo"
		view.Commit(loadBalancer)
		return nil
	})

	loadBalancers := LoadBalancerSlice(conn.SelectFromLoadBalancer(
		func(i LoadBalancer) bool { return true }))
	assert.Equal(t, 1, loadBalancers.Len())

	loadBalancer := loadBalancers[0]
	assert.Equal(t, "foo", loadBalancer.Name)
	assert.Equal(t, id, loadBalancer.getID())

	assert.Equal(t, "LoadBalancer-1{Name=foo, Hostnames=[]}", loadBalancer.String())

	assert.Equal(t, loadBalancer, loadBalancers.Get(0))

	assert.True(t, loadBalancer.less(LoadBalancer{Name: "z"}))
	assert.True(t, loadBalancer.less(LoadBalancer{Name: "foo", ID: id + 1}))
}
