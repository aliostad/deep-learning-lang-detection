package network

import (
	"encoding/json"
	"fmt"
	"testing"

	"github.com/flexiant/concerto/api/types"
	"github.com/flexiant/concerto/utils"
	"github.com/stretchr/testify/assert"
)

// TODO exclude from release compile

// GetLoadBalancerListMocked test mocked function
func GetLoadBalancerListMocked(t *testing.T, loadBalancersIn *[]types.LoadBalancer) *[]types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// to json
	lbIn, err := json.Marshal(loadBalancersIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Get", "/v1/network/load_balancers").Return(lbIn, 200, nil)
	loadBalancersOut, err := lbs.GetLoadBalancerList()
	assert.Nil(err, "Error getting loadBalancer list")
	assert.Equal(*loadBalancersIn, loadBalancersOut, "GetLoadBalancerList returned different loadBalancers")

	return &loadBalancersOut
}

// GetLoadBalancerListFailErrMocked test mocked function
func GetLoadBalancerListFailErrMocked(t *testing.T, loadBalancersIn *[]types.LoadBalancer) *[]types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// to json
	lbIn, err := json.Marshal(loadBalancersIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Get", "/v1/network/load_balancers").Return(lbIn, 200, fmt.Errorf("Mocked error"))
	loadBalancersOut, err := lbs.GetLoadBalancerList()

	assert.NotNil(err, "We are expecting an error")
	assert.Nil(loadBalancersOut, "Expecting nil output")
	assert.Equal(err.Error(), "Mocked error", "Error should be 'Mocked error'")

	return &loadBalancersOut
}

// GetLoadBalancerListFailStatusMocked test mocked function
func GetLoadBalancerListFailStatusMocked(t *testing.T, loadBalancersIn *[]types.LoadBalancer) *[]types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// to json
	lbIn, err := json.Marshal(loadBalancersIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Get", "/v1/network/load_balancers").Return(lbIn, 499, nil)
	loadBalancersOut, err := lbs.GetLoadBalancerList()

	assert.NotNil(err, "We are expecting a status code error")
	assert.Nil(loadBalancersOut, "Expecting nil output")
	assert.Contains(err.Error(), "499", "Error should contain http code 499")

	return &loadBalancersOut
}

// GetLoadBalancerListFailJSONMocked test mocked function
func GetLoadBalancerListFailJSONMocked(t *testing.T, loadBalancersIn *[]types.LoadBalancer) *[]types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// wrong json
	lbIn := []byte{10, 20, 30}

	// call service
	cs.On("Get", "/v1/network/load_balancers").Return(lbIn, 200, nil)
	loadBalancersOut, err := lbs.GetLoadBalancerList()

	assert.NotNil(err, "We are expecting a marshalling error")
	assert.Nil(loadBalancersOut, "Expecting nil output")
	assert.Contains(err.Error(), "invalid character", "Error message should include the string 'invalid character'")

	return &loadBalancersOut
}

// GetLoadBalancerMocked test mocked function
func GetLoadBalancerMocked(t *testing.T, loadBalancer *types.LoadBalancer) *types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// to json
	lbIn, err := json.Marshal(loadBalancer)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Get", fmt.Sprintf("/v1/network/load_balancers/%s", loadBalancer.Id)).Return(lbIn, 200, nil)
	loadBalancerOut, err := lbs.GetLoadBalancer(loadBalancer.Id)
	assert.Nil(err, "Error getting loadBalancer")
	assert.Equal(*loadBalancer, *loadBalancerOut, "GetLoadBalancer returned different loadBalancers")

	return loadBalancerOut
}

// GetLoadBalancerFailErrMocked test mocked function
func GetLoadBalancerFailErrMocked(t *testing.T, loadBalancer *types.LoadBalancer) *types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// to json
	lbIn, err := json.Marshal(loadBalancer)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Get", fmt.Sprintf("/v1/network/load_balancers/%s", loadBalancer.Id)).Return(lbIn, 200, fmt.Errorf("Mocked error"))
	loadBalancerOut, err := lbs.GetLoadBalancer(loadBalancer.Id)

	assert.NotNil(err, "We are expecting an error")
	assert.Nil(loadBalancerOut, "Expecting nil output")
	assert.Equal(err.Error(), "Mocked error", "Error should be 'Mocked error'")

	return loadBalancerOut
}

// GetLoadBalancerFailStatusMocked test mocked function
func GetLoadBalancerFailStatusMocked(t *testing.T, loadBalancer *types.LoadBalancer) *types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// to json
	lbIn, err := json.Marshal(loadBalancer)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Get", fmt.Sprintf("/v1/network/load_balancers/%s", loadBalancer.Id)).Return(lbIn, 499, nil)
	loadBalancerOut, err := lbs.GetLoadBalancer(loadBalancer.Id)

	assert.NotNil(err, "We are expecting an status code error")
	assert.Nil(loadBalancerOut, "Expecting nil output")
	assert.Contains(err.Error(), "499", "Error should contain http code 499")

	return loadBalancerOut
}

// GetLoadBalancerFailJSONMocked test mocked function
func GetLoadBalancerFailJSONMocked(t *testing.T, loadBalancer *types.LoadBalancer) *types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// wrong json
	lbIn := []byte{10, 20, 30}

	// call service
	cs.On("Get", fmt.Sprintf("/v1/network/load_balancers/%s", loadBalancer.Id)).Return(lbIn, 200, nil)
	loadBalancerOut, err := lbs.GetLoadBalancer(loadBalancer.Id)

	assert.NotNil(err, "We are expecting a marshalling error")
	assert.Nil(loadBalancerOut, "Expecting nil output")
	assert.Contains(err.Error(), "invalid character", "Error message should include the string 'invalid character'")

	return loadBalancerOut
}

// CreateLoadBalancerMocked test mocked function
func CreateLoadBalancerMocked(t *testing.T, loadBalancerIn *types.LoadBalancer) *types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// convertMap
	mapIn, err := utils.ItemConvertParams(*loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// to json
	dOut, err := json.Marshal(loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Post", "/v1/network/load_balancers/", mapIn).Return(dOut, 200, nil)
	loadBalancerOut, err := lbs.CreateLoadBalancer(mapIn)
	assert.Nil(err, "Error creating loadBalancer list")
	assert.Equal(loadBalancerIn, loadBalancerOut, "CreateLoadBalancer returned different loadBalancers")

	return loadBalancerOut
}

// CreateLoadBalancerFailErrMocked test mocked function
func CreateLoadBalancerFailErrMocked(t *testing.T, loadBalancerIn *types.LoadBalancer) *types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// convertMap
	mapIn, err := utils.ItemConvertParams(*loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// to json
	dOut, err := json.Marshal(loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Post", "/v1/network/load_balancers/", mapIn).Return(dOut, 200, fmt.Errorf("Mocked error"))
	loadBalancerOut, err := lbs.CreateLoadBalancer(mapIn)

	assert.NotNil(err, "We are expecting an error")
	assert.Nil(loadBalancerOut, "Expecting nil output")
	assert.Equal(err.Error(), "Mocked error", "Error should be 'Mocked error'")

	return loadBalancerOut
}

// CreateLoadBalancerFailStatusMocked test mocked function
func CreateLoadBalancerFailStatusMocked(t *testing.T, loadBalancerIn *types.LoadBalancer) *types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// convertMap
	mapIn, err := utils.ItemConvertParams(*loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// to json
	dOut, err := json.Marshal(loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Post", "/v1/network/load_balancers/", mapIn).Return(dOut, 499, nil)
	loadBalancerOut, err := lbs.CreateLoadBalancer(mapIn)

	assert.NotNil(err, "We are expecting an status code error")
	assert.Nil(loadBalancerOut, "Expecting nil output")
	assert.Contains(err.Error(), "499", "Error should contain http code 499")

	return loadBalancerOut
}

// CreateLoadBalancerFailJSONMocked test mocked function
func CreateLoadBalancerFailJSONMocked(t *testing.T, loadBalancerIn *types.LoadBalancer) *types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// convertMap
	mapIn, err := utils.ItemConvertParams(*loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// wrong json
	lbIn := []byte{10, 20, 30}

	// call service
	cs.On("Post", "/v1/network/load_balancers/", mapIn).Return(lbIn, 200, nil)
	loadBalancerOut, err := lbs.CreateLoadBalancer(mapIn)

	assert.NotNil(err, "We are expecting a marshalling error")
	assert.Nil(loadBalancerOut, "Expecting nil output")
	assert.Contains(err.Error(), "invalid character", "Error message should include the string 'invalid character'")

	return loadBalancerOut
}

// UpdateLoadBalancerMocked test mocked function
func UpdateLoadBalancerMocked(t *testing.T, loadBalancerIn *types.LoadBalancer) *types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// convertMap
	mapIn, err := utils.ItemConvertParams(*loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// to json
	dOut, err := json.Marshal(loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Put", fmt.Sprintf("/v1/network/load_balancers/%s", loadBalancerIn.Id), mapIn).Return(dOut, 200, nil)
	loadBalancerOut, err := lbs.UpdateLoadBalancer(mapIn, loadBalancerIn.Id)
	assert.Nil(err, "Error updating loadBalancer list")
	assert.Equal(loadBalancerIn, loadBalancerOut, "UpdateLoadBalancer returned different loadBalancers")

	return loadBalancerOut
}

// UpdateLoadBalancerFailErrMocked test mocked function
func UpdateLoadBalancerFailErrMocked(t *testing.T, loadBalancerIn *types.LoadBalancer) *types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// convertMap
	mapIn, err := utils.ItemConvertParams(*loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// to json
	dOut, err := json.Marshal(loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Put", fmt.Sprintf("/v1/network/load_balancers/%s", loadBalancerIn.Id), mapIn).Return(dOut, 200, fmt.Errorf("Mocked error"))
	loadBalancerOut, err := lbs.UpdateLoadBalancer(mapIn, loadBalancerIn.Id)

	assert.NotNil(err, "We are expecting an error")
	assert.Nil(loadBalancerOut, "Expecting nil output")
	assert.Equal(err.Error(), "Mocked error", "Error should be 'Mocked error'")

	return loadBalancerOut
}

// UpdateLoadBalancerFailStatusMocked test mocked function
func UpdateLoadBalancerFailStatusMocked(t *testing.T, loadBalancerIn *types.LoadBalancer) *types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// convertMap
	mapIn, err := utils.ItemConvertParams(*loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// to json
	dOut, err := json.Marshal(loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Put", fmt.Sprintf("/v1/network/load_balancers/%s", loadBalancerIn.Id), mapIn).Return(dOut, 499, nil)
	loadBalancerOut, err := lbs.UpdateLoadBalancer(mapIn, loadBalancerIn.Id)

	assert.NotNil(err, "We are expecting an status code error")
	assert.Nil(loadBalancerOut, "Expecting nil output")
	assert.Contains(err.Error(), "499", "Error should contain http code 499")
	return loadBalancerOut
}

// UpdateLoadBalancerFailJSONMocked test mocked function
func UpdateLoadBalancerFailJSONMocked(t *testing.T, loadBalancerIn *types.LoadBalancer) *types.LoadBalancer {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// convertMap
	mapIn, err := utils.ItemConvertParams(*loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// wrong json
	lbIn := []byte{10, 20, 30}

	// call service
	cs.On("Put", fmt.Sprintf("/v1/network/load_balancers/%s", loadBalancerIn.Id), mapIn).Return(lbIn, 200, nil)
	loadBalancerOut, err := lbs.UpdateLoadBalancer(mapIn, loadBalancerIn.Id)

	assert.NotNil(err, "We are expecting a marshalling error")
	assert.Nil(loadBalancerOut, "Expecting nil output")
	assert.Contains(err.Error(), "invalid character", "Error message should include the string 'invalid character'")

	return loadBalancerOut
}

// DeleteLoadBalancerMocked test mocked function
func DeleteLoadBalancerMocked(t *testing.T, loadBalancerIn *types.LoadBalancer) {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// to json
	lbIn, err := json.Marshal(loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Delete", fmt.Sprintf("/v1/network/load_balancers/%s", loadBalancerIn.Id)).Return(lbIn, 200, nil)
	err = lbs.DeleteLoadBalancer(loadBalancerIn.Id)
	assert.Nil(err, "Error deleting loadBalancer")
}

// DeleteLoadBalancerFailErrMocked test mocked function
func DeleteLoadBalancerFailErrMocked(t *testing.T, loadBalancerIn *types.LoadBalancer) {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// to json
	lbIn, err := json.Marshal(loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Delete", fmt.Sprintf("/v1/network/load_balancers/%s", loadBalancerIn.Id)).Return(lbIn, 200, fmt.Errorf("Mocked error"))
	err = lbs.DeleteLoadBalancer(loadBalancerIn.Id)

	assert.NotNil(err, "We are expecting an error")
	assert.Equal(err.Error(), "Mocked error", "Error should be 'Mocked error'")
}

// DeleteLoadBalancerFailStatusMocked test mocked function
func DeleteLoadBalancerFailStatusMocked(t *testing.T, loadBalancerIn *types.LoadBalancer) {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// to json
	lbIn, err := json.Marshal(loadBalancerIn)
	assert.Nil(err, "LoadBalancer test data corrupted")

	// call service
	cs.On("Delete", fmt.Sprintf("/v1/network/load_balancers/%s", loadBalancerIn.Id)).Return(lbIn, 499, nil)
	err = lbs.DeleteLoadBalancer(loadBalancerIn.Id)

	assert.NotNil(err, "We are expecting an status code error")
	assert.Contains(err.Error(), "499", "Error should contain http code 499")
}

// GetLBNodeListMocked test mocked function
func GetLBNodeListMocked(t *testing.T, lbnodesIn *[]types.LBNode, lbId string) *[]types.LBNode {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// to json
	lbnsIn, err := json.Marshal(lbnodesIn)
	assert.Nil(err, "lbNode test data corrupted")

	// call service
	cs.On("Get", fmt.Sprintf("/v1/network/load_balancers/%s/nodes", lbId)).Return(lbnsIn, 200, nil)
	lbnsOut, err := lbs.GetLBNodeList(lbId)
	assert.Nil(err, "Error getting lbNode list")
	assert.Equal(*lbnodesIn, *lbnsOut, "GetLBNodeList returned different lbNodes")

	return lbnsOut
}

// GetLBNodeListFailErrMocked test mocked function
func GetLBNodeListFailErrMocked(t *testing.T, loadBalancerNodesIn *[]types.LBNode, loadBalancerId string) *[]types.LBNode {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	ds, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancerNode service")
	assert.NotNil(ds, "LBNode service not instanced")

	// to json
	dIn, err := json.Marshal(loadBalancerNodesIn)
	assert.Nil(err, "LBNode test data corrupted")

	// call service
	cs.On("Get", fmt.Sprintf("/v1/network/load_balancers/%s/nodes", loadBalancerId)).Return(dIn, 200, fmt.Errorf("Mocked error"))
	loadBalancerNodesOut, err := ds.GetLBNodeList(loadBalancerId)

	assert.NotNil(err, "We are expecting an error")
	assert.Nil(loadBalancerNodesOut, "Expecting nil output")
	assert.Equal(err.Error(), "Mocked error", "Error should be 'Mocked error'")

	return loadBalancerNodesOut
}

// GetLBNodeListFailStatusMocked test mocked function
func GetLBNodeListFailStatusMocked(t *testing.T, loadBalancerNodesIn *[]types.LBNode, loadBalancerId string) *[]types.LBNode {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	ds, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancerNode service")
	assert.NotNil(ds, "LBNode service not instanced")

	// to json
	dIn, err := json.Marshal(loadBalancerNodesIn)
	assert.Nil(err, "LBNode test data corrupted")

	// call service
	cs.On("Get", fmt.Sprintf("/v1/network/load_balancers/%s/nodes", loadBalancerId)).Return(dIn, 499, nil)
	loadBalancerNodesOut, err := ds.GetLBNodeList(loadBalancerId)

	assert.NotNil(err, "We are expecting an status code error")
	assert.Nil(loadBalancerNodesOut, "Expecting nil output")
	assert.Contains(err.Error(), "499", "Error should contain http code 499")

	return loadBalancerNodesOut
}

// GetLBNodeListFailJSONMocked test mocked function
func GetLBNodeListFailJSONMocked(t *testing.T, loadBalancerNodesIn *[]types.LBNode, loadBalancerId string) *[]types.LBNode {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	ds, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancerNode service")
	assert.NotNil(ds, "LBNode service not instanced")

	// wrong json
	dIn := []byte{10, 20, 30}

	// call service
	cs.On("Get", fmt.Sprintf("/v1/network/load_balancers/%s/nodes", loadBalancerId)).Return(dIn, 200, nil)
	loadBalancerNodesOut, err := ds.GetLBNodeList(loadBalancerId)

	assert.NotNil(err, "We are expecting a marshalling error")
	assert.Nil(loadBalancerNodesOut, "Expecting nil output")
	assert.Contains(err.Error(), "invalid character", "Error message should include the string 'invalid character'")

	return loadBalancerNodesOut
}

// CreateLBNodeMocked test mocked function
func CreateLBNodeMocked(t *testing.T, lbn *types.LBNode, lbId string) *types.LBNode {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// convertMap
	mapIn, err := utils.ItemConvertParams(*lbn)
	assert.Nil(err, "lbNode test data corrupted")

	// to json
	lbnIn, err := json.Marshal(lbn)
	assert.Nil(err, "lbNode test data corrupted")

	// call service
	cs.On("Post", fmt.Sprintf("/v1/network/load_balancers/%s/nodes", lbId), mapIn).Return(lbnIn, 200, nil)
	lbnOut, err := lbs.CreateLBNode(mapIn, lbId)
	assert.Nil(err, "Error getting lbNode")
	assert.Equal(*lbn, *lbnOut, "CreateLBNode returned different lbNodes")

	return lbnOut
}

// CreateLBNodeFailErrMocked test mocked function
func CreateLBNodeFailErrMocked(t *testing.T, loadBalancerNodeIn *types.LBNode, loadBalancerId string) *types.LBNode {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	ds, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancerNode service")
	assert.NotNil(ds, "LBNode service not instanced")

	// convertMap
	mapIn, err := utils.ItemConvertParams(*loadBalancerNodeIn)
	assert.Nil(err, "LBNode test data corrupted")

	// to json
	dOut, err := json.Marshal(loadBalancerNodeIn)
	assert.Nil(err, "LBNode test data corrupted")

	// call service
	cs.On("Post", fmt.Sprintf("/v1/network/load_balancers/%s/nodes", loadBalancerId), mapIn).Return(dOut, 200, fmt.Errorf("Mocked error"))
	loadBalancerNodeOut, err := ds.CreateLBNode(mapIn, loadBalancerId)

	assert.NotNil(err, "We are expecting an error")
	assert.Nil(loadBalancerNodeOut, "Expecting nil output")
	assert.Equal(err.Error(), "Mocked error", "Error should be 'Mocked error'")

	return loadBalancerNodeOut
}

// CreateLBNodeFailStatusMocked test mocked function
func CreateLBNodeFailStatusMocked(t *testing.T, loadBalancerNodeIn *types.LBNode, loadBalancerId string) *types.LBNode {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	ds, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancerNode service")
	assert.NotNil(ds, "LBNode service not instanced")

	// convertMap
	mapIn, err := utils.ItemConvertParams(*loadBalancerNodeIn)
	assert.Nil(err, "LBNode test data corrupted")

	// to json
	dOut, err := json.Marshal(loadBalancerNodeIn)
	assert.Nil(err, "LBNode test data corrupted")

	// call service
	cs.On("Post", fmt.Sprintf("/v1/network/load_balancers/%s/nodes", loadBalancerId), mapIn).Return(dOut, 499, nil)
	loadBalancerNodeOut, err := ds.CreateLBNode(mapIn, loadBalancerId)

	assert.NotNil(err, "We are expecting an status code error")
	assert.Nil(loadBalancerNodeOut, "Expecting nil output")
	assert.Contains(err.Error(), "499", "Error should contain http code 499")

	return loadBalancerNodeOut
}

// CreateLBNodeFailJSONMocked test mocked function
func CreateLBNodeFailJSONMocked(t *testing.T, loadBalancerNodeIn *types.LBNode, loadBalancerId string) *types.LBNode {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	ds, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancerNode service")
	assert.NotNil(ds, "LBNode service not instanced")

	// convertMap
	mapIn, err := utils.ItemConvertParams(*loadBalancerNodeIn)
	assert.Nil(err, "LBNode test data corrupted")

	// wrong json
	dIn := []byte{10, 20, 30}

	// call service
	cs.On("Post", fmt.Sprintf("/v1/network/load_balancers/%s/nodes", loadBalancerId), mapIn).Return(dIn, 200, nil)
	loadBalancerNodeOut, err := ds.CreateLBNode(mapIn, loadBalancerId)

	assert.NotNil(err, "We are expecting a marshalling error")
	assert.Nil(loadBalancerNodeOut, "Expecting nil output")
	assert.Contains(err.Error(), "invalid character", "Error message should include the string 'invalid character'")

	return loadBalancerNodeOut
}

// DeleteLBNodeMocked test mocked function
func DeleteLBNodeMocked(t *testing.T, lbn *types.LBNode, lbId string) {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	lbs, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancer service")
	assert.NotNil(lbs, "LoadBalancer service not instanced")

	// to json
	lbnIn, err := json.Marshal(lbn)
	assert.Nil(err, "lbNode test data corrupted")

	// call service
	cs.On("Delete", fmt.Sprintf("/v1/network/load_balancers/%s/nodes/%s", lbId, lbn.Id)).Return(lbnIn, 200, nil)
	err = lbs.DeleteLBNode(lbId, lbn.Id)
	assert.Nil(err, "Error deleting lbNode")
}

// DeleteLBNodeFailErrMocked test mocked function
func DeleteLBNodeFailErrMocked(t *testing.T, loadBalancerNodeIn *types.LBNode, loadBalancerId string) {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	ds, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancerNode service")
	assert.NotNil(ds, "LBNode service not instanced")

	// to json
	dIn, err := json.Marshal(loadBalancerNodeIn)
	assert.Nil(err, "LBNode test data corrupted")

	// call service
	cs.On("Delete", fmt.Sprintf("/v1/network/load_balancers/%s/nodes/%s", loadBalancerId, loadBalancerNodeIn.Id)).Return(dIn, 200, fmt.Errorf("Mocked error"))
	err = ds.DeleteLBNode(loadBalancerId, loadBalancerNodeIn.Id)

	assert.NotNil(err, "We are expecting an error")
	assert.Equal(err.Error(), "Mocked error", "Error should be 'Mocked error'")
}

// DeleteLBNodeFailStatusMocked test mocked function
func DeleteLBNodeFailStatusMocked(t *testing.T, loadBalancerNodeIn *types.LBNode, loadBalancerId string) {

	assert := assert.New(t)

	// wire up
	cs := &utils.MockConcertoService{}
	ds, err := NewLoadBalancerService(cs)
	assert.Nil(err, "Couldn't load loadBalancerNode service")
	assert.NotNil(ds, "LBNode service not instanced")

	// to json
	dIn, err := json.Marshal(loadBalancerNodeIn)
	assert.Nil(err, "LBNode test data corrupted")

	// call service
	cs.On("Delete", fmt.Sprintf("/v1/network/load_balancers/%s/nodes/%s", loadBalancerId, loadBalancerNodeIn.Id)).Return(dIn, 499, nil)
	err = ds.DeleteLBNode(loadBalancerId, loadBalancerNodeIn.Id)

	assert.NotNil(err, "We are expecting an status code error")
	assert.Contains(err.Error(), "499", "Error should contain http code 499")
}
