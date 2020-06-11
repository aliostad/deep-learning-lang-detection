package slb

import (
	. "aliyun-openapi-go-sdk/core"
)

type SetLoadBalancerStatusRequest struct {
	RpcRequest
	LoadBalancerId     string
	LoadBalancerStatus string
	HostId             string
	OwnerAccount       string
}

func (r *SetLoadBalancerStatusRequest) SetLoadBalancerId(value string) {
	r.LoadBalancerId = value
	r.QueryParams.Set("LoadBalancerId", value)
}
func (r *SetLoadBalancerStatusRequest) GetLoadBalancerId() string {
	return r.LoadBalancerId
}
func (r *SetLoadBalancerStatusRequest) SetLoadBalancerStatus(value string) {
	r.LoadBalancerStatus = value
	r.QueryParams.Set("LoadBalancerStatus", value)
}
func (r *SetLoadBalancerStatusRequest) GetLoadBalancerStatus() string {
	return r.LoadBalancerStatus
}
func (r *SetLoadBalancerStatusRequest) SetHostId(value string) {
	r.HostId = value
	r.QueryParams.Set("HostId", value)
}
func (r *SetLoadBalancerStatusRequest) GetHostId() string {
	return r.HostId
}
func (r *SetLoadBalancerStatusRequest) SetOwnerAccount(value string) {
	r.OwnerAccount = value
	r.QueryParams.Set("OwnerAccount", value)
}
func (r *SetLoadBalancerStatusRequest) GetOwnerAccount() string {
	return r.OwnerAccount
}

func (r *SetLoadBalancerStatusRequest) Init() {
	r.RpcRequest.Init()
	r.SetVersion(Version)
	r.SetAction("SetLoadBalancerStatus")
	r.SetProduct(Product)
}

type SetLoadBalancerStatusResponse struct {
}

func SetLoadBalancerStatus(req *SetLoadBalancerStatusRequest, accessId, accessSecret string) (*SetLoadBalancerStatusResponse, error) {
	var pResponse SetLoadBalancerStatusResponse
	body, err := ApiHttpRequest(accessId, accessSecret, req)
	if err != nil {
		return nil, err
	}
	ApiUnmarshalResponse(req.GetFormat(), body, &pResponse)
	return &pResponse, err
}
