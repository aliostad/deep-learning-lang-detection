package slb

import (
	"errors"
	"github.com/hdksky/ksyungo/common"
	"github.com/hdksky/ksyungo/util"
)

const (
	LoadBalancerType_Public   = "public"
	LoadBalancerType_Internal = "internal"
)

type CreateLoadBalancerArgs struct {
	VpcId            string
	LoadBalancerName string
	Type             string
	SubnetId         string
}

func (a CreateLoadBalancerArgs) validate() error {
	if len(a.VpcId) == 0 {
		return util.ParamNotFoundErr("VpcId")
	}

	if len(a.Type) != 0 && a.Type != LoadBalancerType_Internal && a.Type != LoadBalancerType_Public {
		return util.ParamInvalid("Type")
	}

	if a.Type == LoadBalancerType_Internal && len(a.SubnetId) == 0 {
		return util.ParamNotFoundErr("SubnetId")
	}

	return nil
}

type LoadBalancerDescription struct {
	CreateTime        string
	LoadBalancerName  string
	VpcId             string
	LoadBalancerId    string
	Type              string
	SubnetId          string
	PublicIp          string
	State             string
	LoadBalancerState string
}

type CreateLoadBalancerResponse struct {
	common.Response
	LoadBalancerDescription
}

// CreateLoadBalancer create load balancer
// You can read doc at https://docs.ksyun.com/read/latest/55/_book/Action/CreateLoadBalancer.html
func (c *Client) CreateLoadBalancer(args *CreateLoadBalancerArgs) ([]LoadBalancerDescription, error) {
	if args == nil {
		return nil, errors.New("create loadBalancer args nil")
	}

	if err := args.validate(); err != nil {
		return nil, err
	}

	response := CreateLoadBalancerResponse{}
	err := c.Invoke("CreateLoadBalancer", args, &response)
	if err == nil {
		return []LoadBalancerDescription{{
			CreateTime:        response.CreateTime,
			LoadBalancerName:  response.LoadBalancerName,
			VpcId:             response.VpcId,
			LoadBalancerId:    response.LoadBalancerId,
			Type:              response.Type,
			SubnetId:          response.SubnetId,
			PublicIp:          response.PublicIp,
			State:             response.State,
			LoadBalancerState: response.LoadBalancerState,
		}}, nil
	}
	return nil, err
}

type DeleteLoadBalancerArgs struct {
	LoadBalancerId string
}

type DeleteLoadBalancerResponse struct {
	common.Response
	Return bool
}

// DeleteLoadBalancer delete load balancer
// You can read doc at https://docs.ksyun.com/read/latest/55/_book/Action/CreateLoadBalancer.html
func (c *Client) DeleteLoadBalancer(args *DeleteLoadBalancerArgs) (bool, error) {
	if len(args.LoadBalancerId) == 0 {
		return false, util.ParamNotFoundErr("LoadBalancerId")
	}

	response := DeleteLoadBalancerResponse{}
	err := c.Invoke("DeleteLoadBalancer", args, &response)
	if err == nil {
		return response.Return, nil
	}
	return false, err
}

const (
	LoadBalancerState_Stop  = "stop"
	LoadBalancerState_Start = "start"
)

type ModifyLoadBalancerArgs struct {
	LoadBalancerId    string
	LoadBalancerName  string
	LoadBalancerState string
}

type ModifyLoadBalancerResponse struct {
	common.Response
	LoadBalancerDescription
}

// ModifyLoadBalancer modify load balancer
// You can read doc at https://docs.ksyun.com/read/latest/55/_book/Action/ModifyLoadBalancer.html
func (c *Client) ModifyLoadBalancer(args *ModifyLoadBalancerArgs) (*ModifyLoadBalancerResponse, error) {
	response := ModifyLoadBalancerResponse{}
	err := c.Invoke("ModifyLoadBalancer", args, &response)
	if err == nil {
		return &response, nil
	}
	return nil, err
}

type KV struct {
	Name  string
	Value []string
}

type DescribeLoadBalancersArgs struct {
	LoadBalancerId []string
	State          string
	Filter         []KV
}

type LoadBalancerDescriptionResponse struct {
	common.Response
	LoadBalancerDescriptions struct {
		Item []LoadBalancerDescription
	}
}

const (
	State_Associate    = "associate"
	State_Disassociate = "disassociate"
)

// DescribeLoadBalancers describe load balancer
// You can read doc at https://docs.ksyun.com/read/latest/55/_book/Action/DescribeLoadBalancers.html
func (c *Client) DescribeLoadBalancers(args *DescribeLoadBalancersArgs) ([]LoadBalancerDescription, error) {
	response := LoadBalancerDescriptionResponse{}
	err := c.Invoke("DescribeLoadBalancers", args, &response)
	if err == nil {
		return response.LoadBalancerDescriptions.Item, nil
	}
	return nil, err
}
