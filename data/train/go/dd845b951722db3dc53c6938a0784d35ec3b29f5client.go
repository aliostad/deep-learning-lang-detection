package client

import "github.com/dghubble/sling"
import "github.com/mscrypto/mscryptotest/data_types"
import "net/http"

const baseURL = "api.softlayer.com/rest/v3/"

type LoadBalancerService struct {
	sling *sling.Sling
}

func NewLoadBalancerService(username string, apiKey string) *LoadBalancerService {
	return &LoadBalancerService{
		sling: sling.New().Client(nil).Base("https://"+username+":"+apiKey+"@"+baseURL),
	}
}

func (s *LoadBalancerService) getIpAddress() (*data_types.ResLoadBalancer, *http.Response, error) {
	resLoadBalancer := new(data_types.ResLoadBalancer)
	resLoadBalancerError := new(data_types.ResLoadBalancer)
	resp, err := s.sling.New().Get("SoftLayer_Network_Application_Delivery_Controller_LoadBalancer_VirtualIpAddress/146505/getIpAddress.json").Receive(resLoadBalancer,resLoadBalancerError)
	return resLoadBalancer, resp, err
}


