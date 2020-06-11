package clb

import (
	"terraform-provider-qcloud/api/common"
	"fmt"
)


type CreateLoadBalancerArgs struct {
	LoadBalancerType int
	Forward          int
	LoadBalancerName string
	DomainPrefix     string
	VpcId            string
	SubnetId         string
	ProjectId        int
}
type CreateLoadBalancerResponse struct {
	common.CommonResponse
	DealIds           []string          `json:"dealIds"`
	UnLoadBalancerIds UnLoadBalancerIds `json:"unLoadBalancerIds"`
}

type UnLoadBalancerIds map[string][]string


func (client *Client) CreateLoadBalancer(args *CreateLoadBalancerArgs, argList []string) (response *CreateLoadBalancerResponse, err error) {
	response = &CreateLoadBalancerResponse{}

	params := map[string]interface{}{
		"Action":           "CreateLoadBalancer",
		"Region":           client.Region,
		"loadBalancerType": args.LoadBalancerType,
		"forward":          args.Forward,
		"loadBalancerName": args.LoadBalancerName,
		"domainPrefix":     args.DomainPrefix,
		"vpcId":            args.VpcId,
		"subnetId":         args.SubnetId,
		"projectId":        args.ProjectId,
		"number":           1,
	}
	argList = append(argList, "number")
	err = client.Invoke(params, response, argList)
	if err != nil {
		return nil,err
	}



	if response.Code != 0 {
		err := fmt.Errorf("CLB Error: %d %s", response.Code, response.Message)
		return nil, err
	}

	return response,nil

}


type DescribeLoadBalancerResponse struct {
	common.CommonResponse
	TotalCount      int                `json:"totalCount"`
	LoadBalancerSet []*LoadBalancerSet `json:"loadBalancerSet"`
}

type LoadBalancerSet struct {
	LoadBalancerId   string   `json:"loadBalancerId"`
	UnLoadBalancerId string   `json:"unLoadBalancerId"`
	LoadBalancerName string   `json:"loadBalancerName"`
	LoadBalancerType int      `json:"loadBalancerType"`
	Domain           string   `json:"domain"`
	LoadBalancerVips []string `json:"loadBalancerVips"`
	Status           int      `json:"status"`
	CreateTime       string   `json:"createTime"`
	StatusTime       string   `json:"statusTime"`
	ProjectId        int      `json:"projectId"`
	VpcId            int      `json:"vpcId"`
	SubnetId         int      `json:"subnetId"`
}


func (client *Client) DescribeLoadBalancer(loadBalancerId string, argList []string) (response *DescribeLoadBalancerResponse, err error) {
	response = &DescribeLoadBalancerResponse{}

	params := map[string]interface{}{
		"Action":            "DescribeLoadBalancers",
		"Region":            client.Region,
		"loadBalancerIds.1": loadBalancerId,
	}


	err = client.Invoke(params, response, argList)
	if err != nil {
		return nil, err
	}

	if response.Code != 0 {
		err = fmt.Errorf("CLB: %d %s", response.Code, response.Message)
		return nil, err
	}
	return response, nil

}


type ModifyLoadBalancerAttributesArgs struct {
	LoadBalancerId   string
	LoadBalancerName string
	DomainPrefix     string
}

type ModifyLoadBalancerAttributesResponse struct {
	common.CommonResponse
	RequestId int `json:"requestId"`
}

func (client *Client) ModifyLoadBalancerAttributes(args *ModifyLoadBalancerAttributesArgs, argList []string) (response *ModifyLoadBalancerAttributesResponse, err error) {
	response = &ModifyLoadBalancerAttributesResponse{}

	params := map[string]interface{}{
		"Action":           "ModifyLoadBalancerAttributes",
		"Region":           client.Region,
		"loadBalancerId":   args.LoadBalancerId,
		"loadBalancerName": args.LoadBalancerName,
		"domainPrefix":     args.DomainPrefix,
	}
	err = client.Invoke(params, response, argList)
	if err != nil {
		return nil, err
	}
	return response, nil
}


type DeleteLoadBalancerResponse struct {
	common.CommonResponse
	RequestId int `json:"requestId"`
}



func (client *Client) DeleteLoadBalancer(loadBalancerId string, argList []string) (response *DeleteLoadBalancerResponse, err error) {
	response = &DeleteLoadBalancerResponse{}

	params := map[string]interface{}{
		"Action":            "DeleteLoadBalancers",
		"Region":            client.Region,
		"loadBalancerIds.1": loadBalancerId,
	}
	err = client.Invoke(params, response, argList)

	if err != nil {
		return nil, err
	}
	return response, nil
}



