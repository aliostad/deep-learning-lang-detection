package slb

import (
	. "aliyun-openapi-go-sdk/core"
)

type DeleteLoadBalancerListenerRequest struct {
	RpcRequest
	LoadBalancerId string
	ListenerPort   string
	HostId         string
	OwnerAccount   string
}

func (r *DeleteLoadBalancerListenerRequest) SetLoadBalancerId(value string) {
	r.LoadBalancerId = value
	r.QueryParams.Set("LoadBalancerId", value)
}
func (r *DeleteLoadBalancerListenerRequest) GetLoadBalancerId() string {
	return r.LoadBalancerId
}
func (r *DeleteLoadBalancerListenerRequest) SetListenerPort(value string) {
	r.ListenerPort = value
	r.QueryParams.Set("ListenerPort", value)
}
func (r *DeleteLoadBalancerListenerRequest) GetListenerPort() string {
	return r.ListenerPort
}
func (r *DeleteLoadBalancerListenerRequest) SetHostId(value string) {
	r.HostId = value
	r.QueryParams.Set("HostId", value)
}
func (r *DeleteLoadBalancerListenerRequest) GetHostId() string {
	return r.HostId
}
func (r *DeleteLoadBalancerListenerRequest) SetOwnerAccount(value string) {
	r.OwnerAccount = value
	r.QueryParams.Set("OwnerAccount", value)
}
func (r *DeleteLoadBalancerListenerRequest) GetOwnerAccount() string {
	return r.OwnerAccount
}

func (r *DeleteLoadBalancerListenerRequest) Init() {
	r.RpcRequest.Init()
	r.SetVersion(Version)
	r.SetAction("DeleteLoadBalancerListener")
	r.SetProduct(Product)
}

type DeleteLoadBalancerListenerResponse struct {
}

func DeleteLoadBalancerListener(req *DeleteLoadBalancerListenerRequest, accessId, accessSecret string) (*DeleteLoadBalancerListenerResponse, error) {
	var pResponse DeleteLoadBalancerListenerResponse
	body, err := ApiHttpRequest(accessId, accessSecret, req)
	if err != nil {
		return nil, err
	}
	ApiUnmarshalResponse(req.GetFormat(), body, &pResponse)
	return &pResponse, err
}
