/*
 * Copyright 2015 1&1 Internet AG, http://1und1.de . All rights reserved. Licensed under the Apache v2 License.
 */

package oneandone_cloudserver_api

import (
	"github.com/docker/machine/log"
	"net/http"
)

type LoadBalancer struct {
	withId
	withApi
	Name                  string                  `json:"name"`
	Description           string                  `json:"description"`
	State                 string                  `json:"state"`
	CreationDate          string                  `json:"creation_date"`
	Ip                    string                  `json:"ip"`
	HealthCheckTest       string                  `json:"health_check_test"`
	HealthCheckInterval   int                     `json:"health_check_interval"`
	HealthCheckPath       string                  `json:"health_check_path"`
	HealthCheckPathParser string                  `json:"health_check_path_parser"`
	Persistence           bool                    `json:"persistence"`
	PersistenceTime       int                     `json:"persistence_time"`
	Method                string                  `json:"method"`
	Rules                 []LoadBalancerRules     `json:"rules"`
	ServerIps             []LoadBalancerServerIps `json:"server_ips"`
	CloudPanelId          string                  `json:"cloudpanel_id"`
}

type LoadBalancerRules struct {
	withId
	Protocol     string `json:"protocol"`
	PortBalancer int    `json:"port_balancer"`
	PortServer   int    `json:"port_server"`
	Source       string `json:"source"`
}

type LoadBalancerServerIps struct {
	withId
	Ip         string `json:"ip"`
	ServerName string `json:"server_name"`
}

type LoadBalancerUpdate struct {
	Name                  string `json:"name"`
	Description           string `json:"description"`
	HealthCheckTest       string `json:"health_check_test"`
	HealthCheckInterval   int    `json:"health_check_interval"`
	HealthCheckPath       string `json:"health_check_path"`
	HealthCheckPathParser string `json:"health_check_path_parser"`
	Persistence           bool   `json:"persistence"`
	PersistenceTime       int    `json:"persistence_time"`
	Method                string `json:"method"`
}

// GET /load_balancers
func (api *API) GetLoadBalancers() ([]LoadBalancer, error) {
	log.Debug("Requesting information about load balancers")
	result := []LoadBalancer{}
	err := api.Client.Get(createUrl(api, "load_balancers"), &result, http.StatusOK)
	if err != nil {
		return nil, err
	}
	for index, _ := range result {
		result[index].api = api
	}
	return result, nil
}

// POST /load_balancers
func (api *API) CreateLoadBalancer(loadBalancer LoadBalancer) (*LoadBalancer, error) {
	log.Debugf("Creating new load balancer: '%s'", loadBalancer.Name)
	result := new(LoadBalancer)
	err := api.Client.Post(createUrl(api, "load_balancers"), &loadBalancer, &result, http.StatusAccepted)
	if err != nil {
		return nil, err
	}
	result.api = api
	return result, nil
}

// GET /load_balancers/{id}
func (api *API) GetLoadBalancer(id string) (*LoadBalancer, error) {
	log.Debugf("Requesting information about load balancer: '%s'", id)
	result := new(LoadBalancer)
	err := api.Client.Get(createUrl(api, "load_balancers", id), &result, http.StatusOK)
	if err != nil {
		return nil, err
	}
	result.api = api
	return result, nil
}

// DELETE /load_balancers/{id}
func (lb *LoadBalancer) Delete() (*LoadBalancer, error) {
	log.Debugf("Deleting load balancer: '%s'", lb.Id)
	result := new(LoadBalancer)
	err := lb.api.Client.Delete(createUrl(lb.api, "load_balancers", lb.Id), &result, http.StatusAccepted)
	if err != nil {
		return nil, err
	}
	result.api = lb.api
	return result, nil
}

// PUT /load_balancers/{id}
func (lb *LoadBalancer) Update(loadBalancerUpdate LoadBalancerUpdate) (*LoadBalancer, error) {
	log.Debugf("Updateing load balancer configuration for: '%s'", lb.Id)
	result := new(LoadBalancer)
	err := lb.api.Client.Put(createUrl(lb.api, "load_balancers", lb.Id), &loadBalancerUpdate, &result, http.StatusAccepted)
	if err != nil {
		return nil, err
	}
	result.api = lb.api
	return result, nil
}

// GET /load_balancers/{id}/server_ips

// PUT /load_balancers/{id}/server_ips

// GET /load_balancers/{id}/server_ips/{id}

// DELETE /load_balancers/{id}/server_ips/{id}

// GET /load_balancers/{load_balancer_id}/rules

// PUT /load_balancers/{load_balancer_id}/rules

// GET /load_balancers/{load_balancer_id}/rules/{rule_id}

// DELETE /load_balancers/{load_balancer_id}/rules/{rule_id}
