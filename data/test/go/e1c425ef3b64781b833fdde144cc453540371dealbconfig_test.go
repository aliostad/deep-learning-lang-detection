package loadbalancer

import (
	"github.com/stretchr/testify/assert"
	"strings"
	"testing"
)

func TestRoundRobinAsKnownPolicy(t *testing.T) {
	assert.True(t, IsKnownLoadBalancerPolicy("round-robin"))
	assert.False(t, IsKnownLoadBalancerPolicy("buggy"))
}

func TestRegisterLoadBalancerGuardrails(t *testing.T) {
	err := RegisterLoadBalancer("", nil)
	assert.NotNil(t, err)

	err = RegisterLoadBalancer("name", nil)
	assert.NotNil(t, err)

	err = RegisterLoadBalancer("round-robin", new(RoundRobinLoadBalancerFactory))
	assert.NotNil(t, err)

}

func TestLoadBalancersList(t *testing.T) {
	err := RegisterLoadBalancer("round-robin2", new(RoundRobinLoadBalancerFactory))
	assert.Nil(t, err)

	loadBalancers := RegisteredLoadBalancers()

	assert.True(t, strings.Contains(loadBalancers, "round-robin"))
	assert.True(t, strings.Contains(loadBalancers, "round-robin2"))
	assert.True(t, strings.Contains(loadBalancers, ","))
	assert.False(t, strings.Contains(loadBalancers, "buggy"))
}

func TestObtainLoadBalancerFactory(t *testing.T) {
	preferredLocalFactory := ObtainFactoryForLoadBalancer("prefer-local")
	assert.NotNil(t, preferredLocalFactory)
}
