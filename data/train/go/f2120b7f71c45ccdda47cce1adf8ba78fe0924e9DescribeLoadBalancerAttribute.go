package slb

import (
	. "aliyun-openapi-go-sdk/core"
)

type DescribeLoadBalancerAttributeRequest struct {
	RpcRequest
	LoadBalancerId string
	HostId         string
	OwnerAccount   string
}

func (r *DescribeLoadBalancerAttributeRequest) SetLoadBalancerId(value string) {
	r.LoadBalancerId = value
	r.QueryParams.Set("LoadBalancerId", value)
}
func (r *DescribeLoadBalancerAttributeRequest) GetLoadBalancerId() string {
	return r.LoadBalancerId
}
func (r *DescribeLoadBalancerAttributeRequest) SetHostId(value string) {
	r.HostId = value
	r.QueryParams.Set("HostId", value)
}
func (r *DescribeLoadBalancerAttributeRequest) GetHostId() string {
	return r.HostId
}
func (r *DescribeLoadBalancerAttributeRequest) SetOwnerAccount(value string) {
	r.OwnerAccount = value
	r.QueryParams.Set("OwnerAccount", value)
}
func (r *DescribeLoadBalancerAttributeRequest) GetOwnerAccount() string {
	return r.OwnerAccount
}

func (r *DescribeLoadBalancerAttributeRequest) Init() {
	r.RpcRequest.Init()
	r.SetVersion(Version)
	r.SetAction("DescribeLoadBalancerAttribute")
	r.SetProduct(Product)
}

type DescribeLoadBalancerAttributeResponse struct {
	LoadBalancerId     string `xml:"LoadBalancerId" json:"LoadBalancerId"`
	LoadBalancerName   string `xml:"LoadBalancerName" json:"LoadBalancerName"`
	LoadBalancerStatus string `xml:"LoadBalancerStatus" json:"LoadBalancerStatus"`
	RegionId           string `xml:"RegionId" json:"RegionId"`
	Address            string `xml:"Address" json:"Address"`
	IsPublicAddress    string `xml:"IsPublicAddress" json:"IsPublicAddress"`
	ListenerPorts      struct {
		ListenerPort []string `xml:"ListenerPort" json:"ListenerPort"`
	} `xml:"ListenerPorts" json:"ListenerPorts"`
	BackendServers struct {
		BackendServer []struct {
			ServerId string `xml:"ServerId" json:"ServerId"`
			Weight   int    `xml:"Weight" json:"Weight"`
		} `xml:"BackendServer" json:"BackendServer"`
	} `xml:"BackendServers" json:"BackendServers"`
}

func DescribeLoadBalancerAttribute(req *DescribeLoadBalancerAttributeRequest, accessId, accessSecret string) (*DescribeLoadBalancerAttributeResponse, error) {
	var pResponse DescribeLoadBalancerAttributeResponse
	body, err := ApiHttpRequest(accessId, accessSecret, req)
	if err != nil {
		return nil, err
	}
	ApiUnmarshalResponse(req.GetFormat(), body, &pResponse)
	return &pResponse, err
}
