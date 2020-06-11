/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package slb

import (
	"aliyun-go-sdk-core"

	"aliyun-go-sdk-slb/20130221/SetLoadBanancerListenerStatusResponse"

	"aliyun-go-sdk-slb/20130221/SetLoadBalancerTCPListenerAttributeResponse"

	"aliyun-go-sdk-slb/20130221/SetLoadBalancerStatusResponse"

	"aliyun-go-sdk-slb/20130221/SetLoadBalancerNameResponse"

	"aliyun-go-sdk-slb/20130221/SetLoadBalancerListenerStatusResponse"

	"aliyun-go-sdk-slb/20130221/SetLoadBalancerHTTPListenerAttributeResponse"

	"aliyun-go-sdk-slb/20130221/RemoveBackendServersResponse"

	"aliyun-go-sdk-slb/20130221/DescribeRegionsResponse"

	"aliyun-go-sdk-slb/20130221/DescribeLoadBalancerTCPListenerAttributeResponse"

	"aliyun-go-sdk-slb/20130221/DescribeLoadBalancersResponse"

	"aliyun-go-sdk-slb/20130221/DescribeLoadBalancerHTTPListenerAttributeResponse"

	"aliyun-go-sdk-slb/20130221/DescribeLoadBalancerAttributeResponse"

	"aliyun-go-sdk-slb/20130221/DescribeBackendServersResponse"

	"aliyun-go-sdk-slb/20130221/DeleteLoadBalancerListenerResponse"

	"aliyun-go-sdk-slb/20130221/DeleteLoadBalancerResponse"

	"aliyun-go-sdk-slb/20130221/CreateLoadBalancerTCPListenerResponse"

	"aliyun-go-sdk-slb/20130221/CreateLoadBalancerHTTPListenerResponse"

	"aliyun-go-sdk-slb/20130221/CreateLoadBalancerResponse"

	"aliyun-go-sdk-slb/20130221/AddBackendServersResponse"
)

type SlbClient struct {
	core.BaseClient
}

func New(profile *core.AccessProfile) *SlbClient {
	p := &SlbClient{}
	p.Version = "2013-02-21"
	p.ProductName = "Slb"
	p.Profile = profile
	p.ApiStyle = "RPC"
	p.HttpRequestBuilder = &core.RpcHttpRequestBuilder{}
	return p
}

func (c *SlbClient) SetLoadBanancerListenerStatus(setLoadBanancerListenerStatusRequest *SetLoadBanancerListenerStatusRequest) (slb_SetLoadBanancerListenerStatusResponse.SetLoadBanancerListenerStatusResponse, error) {
	var resObj slb_SetLoadBanancerListenerStatusResponse.SetLoadBanancerListenerStatusResponse

	if setLoadBanancerListenerStatusRequest == nil {
		setLoadBanancerListenerStatusRequest = new(SetLoadBanancerListenerStatusRequest)
	}
	err := c.DoAction(setLoadBanancerListenerStatusRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) SetLoadBalancerTCPListenerAttribute(setLoadBalancerTCPListenerAttributeRequest *SetLoadBalancerTCPListenerAttributeRequest) (slb_SetLoadBalancerTCPListenerAttributeResponse.SetLoadBalancerTCPListenerAttributeResponse, error) {
	var resObj slb_SetLoadBalancerTCPListenerAttributeResponse.SetLoadBalancerTCPListenerAttributeResponse

	if setLoadBalancerTCPListenerAttributeRequest == nil {
		setLoadBalancerTCPListenerAttributeRequest = new(SetLoadBalancerTCPListenerAttributeRequest)
	}
	err := c.DoAction(setLoadBalancerTCPListenerAttributeRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) SetLoadBalancerStatus(setLoadBalancerStatusRequest *SetLoadBalancerStatusRequest) (slb_SetLoadBalancerStatusResponse.SetLoadBalancerStatusResponse, error) {
	var resObj slb_SetLoadBalancerStatusResponse.SetLoadBalancerStatusResponse

	if setLoadBalancerStatusRequest == nil {
		setLoadBalancerStatusRequest = new(SetLoadBalancerStatusRequest)
	}
	err := c.DoAction(setLoadBalancerStatusRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) SetLoadBalancerName(setLoadBalancerNameRequest *SetLoadBalancerNameRequest) (slb_SetLoadBalancerNameResponse.SetLoadBalancerNameResponse, error) {
	var resObj slb_SetLoadBalancerNameResponse.SetLoadBalancerNameResponse

	if setLoadBalancerNameRequest == nil {
		setLoadBalancerNameRequest = new(SetLoadBalancerNameRequest)
	}
	err := c.DoAction(setLoadBalancerNameRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) SetLoadBalancerListenerStatus(setLoadBalancerListenerStatusRequest *SetLoadBalancerListenerStatusRequest) (slb_SetLoadBalancerListenerStatusResponse.SetLoadBalancerListenerStatusResponse, error) {
	var resObj slb_SetLoadBalancerListenerStatusResponse.SetLoadBalancerListenerStatusResponse

	if setLoadBalancerListenerStatusRequest == nil {
		setLoadBalancerListenerStatusRequest = new(SetLoadBalancerListenerStatusRequest)
	}
	err := c.DoAction(setLoadBalancerListenerStatusRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) SetLoadBalancerHTTPListenerAttribute(setLoadBalancerHTTPListenerAttributeRequest *SetLoadBalancerHTTPListenerAttributeRequest) (slb_SetLoadBalancerHTTPListenerAttributeResponse.SetLoadBalancerHTTPListenerAttributeResponse, error) {
	var resObj slb_SetLoadBalancerHTTPListenerAttributeResponse.SetLoadBalancerHTTPListenerAttributeResponse

	if setLoadBalancerHTTPListenerAttributeRequest == nil {
		setLoadBalancerHTTPListenerAttributeRequest = new(SetLoadBalancerHTTPListenerAttributeRequest)
	}
	err := c.DoAction(setLoadBalancerHTTPListenerAttributeRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) RemoveBackendServers(removeBackendServersRequest *RemoveBackendServersRequest) (slb_RemoveBackendServersResponse.RemoveBackendServersResponse, error) {
	var resObj slb_RemoveBackendServersResponse.RemoveBackendServersResponse

	if removeBackendServersRequest == nil {
		removeBackendServersRequest = new(RemoveBackendServersRequest)
	}
	err := c.DoAction(removeBackendServersRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) DescribeRegions(describeRegionsRequest *DescribeRegionsRequest) (slb_DescribeRegionsResponse.DescribeRegionsResponse, error) {
	var resObj slb_DescribeRegionsResponse.DescribeRegionsResponse

	if describeRegionsRequest == nil {
		describeRegionsRequest = new(DescribeRegionsRequest)
	}
	err := c.DoAction(describeRegionsRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) DescribeLoadBalancerTCPListenerAttribute(describeLoadBalancerTCPListenerAttributeRequest *DescribeLoadBalancerTCPListenerAttributeRequest) (slb_DescribeLoadBalancerTCPListenerAttributeResponse.DescribeLoadBalancerTCPListenerAttributeResponse, error) {
	var resObj slb_DescribeLoadBalancerTCPListenerAttributeResponse.DescribeLoadBalancerTCPListenerAttributeResponse

	if describeLoadBalancerTCPListenerAttributeRequest == nil {
		describeLoadBalancerTCPListenerAttributeRequest = new(DescribeLoadBalancerTCPListenerAttributeRequest)
	}
	err := c.DoAction(describeLoadBalancerTCPListenerAttributeRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) DescribeLoadBalancers(describeLoadBalancersRequest *DescribeLoadBalancersRequest) (slb_DescribeLoadBalancersResponse.DescribeLoadBalancersResponse, error) {
	var resObj slb_DescribeLoadBalancersResponse.DescribeLoadBalancersResponse

	if describeLoadBalancersRequest == nil {
		describeLoadBalancersRequest = new(DescribeLoadBalancersRequest)
	}
	err := c.DoAction(describeLoadBalancersRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) DescribeLoadBalancerHTTPListenerAttribute(describeLoadBalancerHTTPListenerAttributeRequest *DescribeLoadBalancerHTTPListenerAttributeRequest) (slb_DescribeLoadBalancerHTTPListenerAttributeResponse.DescribeLoadBalancerHTTPListenerAttributeResponse, error) {
	var resObj slb_DescribeLoadBalancerHTTPListenerAttributeResponse.DescribeLoadBalancerHTTPListenerAttributeResponse

	if describeLoadBalancerHTTPListenerAttributeRequest == nil {
		describeLoadBalancerHTTPListenerAttributeRequest = new(DescribeLoadBalancerHTTPListenerAttributeRequest)
	}
	err := c.DoAction(describeLoadBalancerHTTPListenerAttributeRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) DescribeLoadBalancerAttribute(describeLoadBalancerAttributeRequest *DescribeLoadBalancerAttributeRequest) (slb_DescribeLoadBalancerAttributeResponse.DescribeLoadBalancerAttributeResponse, error) {
	var resObj slb_DescribeLoadBalancerAttributeResponse.DescribeLoadBalancerAttributeResponse

	if describeLoadBalancerAttributeRequest == nil {
		describeLoadBalancerAttributeRequest = new(DescribeLoadBalancerAttributeRequest)
	}
	err := c.DoAction(describeLoadBalancerAttributeRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) DescribeBackendServers(describeBackendServersRequest *DescribeBackendServersRequest) (slb_DescribeBackendServersResponse.DescribeBackendServersResponse, error) {
	var resObj slb_DescribeBackendServersResponse.DescribeBackendServersResponse

	if describeBackendServersRequest == nil {
		describeBackendServersRequest = new(DescribeBackendServersRequest)
	}
	err := c.DoAction(describeBackendServersRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) DeleteLoadBalancerListener(deleteLoadBalancerListenerRequest *DeleteLoadBalancerListenerRequest) (slb_DeleteLoadBalancerListenerResponse.DeleteLoadBalancerListenerResponse, error) {
	var resObj slb_DeleteLoadBalancerListenerResponse.DeleteLoadBalancerListenerResponse

	if deleteLoadBalancerListenerRequest == nil {
		deleteLoadBalancerListenerRequest = new(DeleteLoadBalancerListenerRequest)
	}
	err := c.DoAction(deleteLoadBalancerListenerRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) DeleteLoadBalancer(deleteLoadBalancerRequest *DeleteLoadBalancerRequest) (slb_DeleteLoadBalancerResponse.DeleteLoadBalancerResponse, error) {
	var resObj slb_DeleteLoadBalancerResponse.DeleteLoadBalancerResponse

	if deleteLoadBalancerRequest == nil {
		deleteLoadBalancerRequest = new(DeleteLoadBalancerRequest)
	}
	err := c.DoAction(deleteLoadBalancerRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) CreateLoadBalancerTCPListener(createLoadBalancerTCPListenerRequest *CreateLoadBalancerTCPListenerRequest) (slb_CreateLoadBalancerTCPListenerResponse.CreateLoadBalancerTCPListenerResponse, error) {
	var resObj slb_CreateLoadBalancerTCPListenerResponse.CreateLoadBalancerTCPListenerResponse

	if createLoadBalancerTCPListenerRequest == nil {
		createLoadBalancerTCPListenerRequest = new(CreateLoadBalancerTCPListenerRequest)
	}
	err := c.DoAction(createLoadBalancerTCPListenerRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) CreateLoadBalancerHTTPListener(createLoadBalancerHTTPListenerRequest *CreateLoadBalancerHTTPListenerRequest) (slb_CreateLoadBalancerHTTPListenerResponse.CreateLoadBalancerHTTPListenerResponse, error) {
	var resObj slb_CreateLoadBalancerHTTPListenerResponse.CreateLoadBalancerHTTPListenerResponse

	if createLoadBalancerHTTPListenerRequest == nil {
		createLoadBalancerHTTPListenerRequest = new(CreateLoadBalancerHTTPListenerRequest)
	}
	err := c.DoAction(createLoadBalancerHTTPListenerRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) CreateLoadBalancer(createLoadBalancerRequest *CreateLoadBalancerRequest) (slb_CreateLoadBalancerResponse.CreateLoadBalancerResponse, error) {
	var resObj slb_CreateLoadBalancerResponse.CreateLoadBalancerResponse

	if createLoadBalancerRequest == nil {
		createLoadBalancerRequest = new(CreateLoadBalancerRequest)
	}
	err := c.DoAction(createLoadBalancerRequest, &resObj)
	return resObj, err
}

func (c *SlbClient) AddBackendServers(addBackendServersRequest *AddBackendServersRequest) (slb_AddBackendServersResponse.AddBackendServersResponse, error) {
	var resObj slb_AddBackendServersResponse.AddBackendServersResponse

	if addBackendServersRequest == nil {
		addBackendServersRequest = new(AddBackendServersRequest)
	}
	err := c.DoAction(addBackendServersRequest, &resObj)
	return resObj, err
}
