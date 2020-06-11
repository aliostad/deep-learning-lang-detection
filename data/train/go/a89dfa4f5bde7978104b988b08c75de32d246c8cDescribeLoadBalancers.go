package slb

import (
	. "aliyun-openapi-go-sdk/core"
)

type DescribeLoadBalancersRequest struct {
	RpcRequest
	ServerId       string
	LoadBalancerId string
	HostId         string
	OwnerAccount   string
}

func (r *DescribeLoadBalancersRequest) SetServerId(value string) {
	r.ServerId = value
	r.QueryParams.Set("ServerId", value)
}
func (r *DescribeLoadBalancersRequest) GetServerId() string {
	return r.ServerId
}
func (r *DescribeLoadBalancersRequest) SetLoadBalancerId(value string) {
	r.LoadBalancerId = value
	r.QueryParams.Set("LoadBalancerId", value)
}
func (r *DescribeLoadBalancersRequest) GetLoadBalancerId() string {
	return r.LoadBalancerId
}
func (r *DescribeLoadBalancersRequest) SetHostId(value string) {
	r.HostId = value
	r.QueryParams.Set("HostId", value)
}
func (r *DescribeLoadBalancersRequest) GetHostId() string {
	return r.HostId
}
func (r *DescribeLoadBalancersRequest) SetOwnerAccount(value string) {
	r.OwnerAccount = value
	r.QueryParams.Set("OwnerAccount", value)
}
func (r *DescribeLoadBalancersRequest) GetOwnerAccount() string {
	return r.OwnerAccount
}

func (r *DescribeLoadBalancersRequest) Init() {
	r.RpcRequest.Init()
	r.SetVersion(Version)
	r.SetAction("DescribeLoadBalancers")
	r.SetProduct(Product)
}

type DescribeLoadBalancersResponse struct {
	LoadBalancers struct {
		LoadBalancer []struct {
			LoadBalancerId     string `xml:"LoadBalancerId" json:"LoadBalancerId"`
			LoadBalancerName   string `xml:"LoadBalancerName" json:"LoadBalancerName"`
			LoadBalancerStatus string `xml:"LoadBalancerStatus" json:"LoadBalancerStatus"`
		} `xml:"LoadBalancer" json:"LoadBalancer"`
	} `xml:"LoadBalancers" json:"LoadBalancers"`
}

func DescribeLoadBalancers(req *DescribeLoadBalancersRequest, accessId, accessSecret string) (*DescribeLoadBalancersResponse, error) {
	var pResponse DescribeLoadBalancersResponse
	body, err := ApiHttpRequest(accessId, accessSecret, req)
	if err != nil {
		return nil, err
	}
	ApiUnmarshalResponse(req.GetFormat(), body, &pResponse)
	return &pResponse, err
}
