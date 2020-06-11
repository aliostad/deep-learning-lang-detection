package slb

import (
	. "aliyun-openapi-go-sdk/core"
)

type SetLoadBalancerNameRequest struct {
	RpcRequest
	LoadBalancerId   string
	LoadBalancerName string
	HostId           string
	OwnerAccount     string
}

func (r *SetLoadBalancerNameRequest) SetLoadBalancerId(value string) {
	r.LoadBalancerId = value
	r.QueryParams.Set("LoadBalancerId", value)
}
func (r *SetLoadBalancerNameRequest) GetLoadBalancerId() string {
	return r.LoadBalancerId
}
func (r *SetLoadBalancerNameRequest) SetLoadBalancerName(value string) {
	r.LoadBalancerName = value
	r.QueryParams.Set("LoadBalancerName", value)
}
func (r *SetLoadBalancerNameRequest) GetLoadBalancerName() string {
	return r.LoadBalancerName
}
func (r *SetLoadBalancerNameRequest) SetHostId(value string) {
	r.HostId = value
	r.QueryParams.Set("HostId", value)
}
func (r *SetLoadBalancerNameRequest) GetHostId() string {
	return r.HostId
}
func (r *SetLoadBalancerNameRequest) SetOwnerAccount(value string) {
	r.OwnerAccount = value
	r.QueryParams.Set("OwnerAccount", value)
}
func (r *SetLoadBalancerNameRequest) GetOwnerAccount() string {
	return r.OwnerAccount
}

func (r *SetLoadBalancerNameRequest) Init() {
	r.RpcRequest.Init()
	r.SetVersion(Version)
	r.SetAction("SetLoadBalancerName")
	r.SetProduct(Product)
}

type SetLoadBalancerNameResponse struct {
}

func SetLoadBalancerName(req *SetLoadBalancerNameRequest, accessId, accessSecret string) (*SetLoadBalancerNameResponse, error) {
	var pResponse SetLoadBalancerNameResponse
	body, err := ApiHttpRequest(accessId, accessSecret, req)
	if err != nil {
		return nil, err
	}
	ApiUnmarshalResponse(req.GetFormat(), body, &pResponse)
	return &pResponse, err
}
