package zstack

import (
	"encoding/json"
)

type QueryLoadBalancerParams struct {
	baseQueryParams
}

func NewQueryLoadBalancerParams() *QueryLoadBalancerParams {
	rtn := &QueryLoadBalancerParams{}
	rtn.p = make(map[string]interface{})
	return rtn
}

func (p *QueryLoadBalancerParams) toApiMessage() (string, error) {
	pp := make(map[string]interface{})
	p.fillQueryStruct()
	pp["org.zstack.network.service.lb.APIQueryLoadBalancerMsg"] = p.p
	b, err := json.Marshal(pp)
	if err != nil {
		return "", err
	}
	return string(b), nil
}

type LoadBalancer struct {
	Uuid        string                 `json:"uuid"`
	Name        string                 `json:"name"`
	Description string                 `json:"description"`
	State       string                 `json:"state"`
	VipUuid     string                 `json:"vipUuid"`
	Listeners   []LoadBalancerListener `json:"listeners"`
}

type LoadBalancerListener struct {
	Uuid             string                 `json:"uuid"`
	LoadBalancerUuid string                 `json:"loadBalancerUuid"`
	Name             string                 `json:"name"`
	Protocol         string                 `json:"protocol"`
	LoadBalancerPort uint16                 `json:"loadBalancerPort"`
	InstancePort     uint16                 `json:"instancePort"`
	CreateDate       string                 `json:"createDate"`
	LastOpDate       string                 `json:"lastOpDate"`
	VmNicRefs        []LoadBalancerVmNicRef `json:"vmNicRefs"`
}

type LoadBalancerVmNicRef struct {
	Id           uint   `json:"id"`
	CreateDate   string `json:"createDate"`
	LastOpDate   string `json:"lastOpDate"`
	ListenerUuid string `json:"listenerUuid"`
	Status       string `json:"status"`
	VmNicUuid    string `json:"vmNicUuid"`
}

type QueryLoadBalancerResponse struct {
	Reply struct {
		Id            string         `json:"id"`
		Success       bool           `json:"success"`
		ServiceId     string         `json:"serviceId"`
		CreatedTime   uint           `json:"createdTime"`
		Total         uint16         `json:"total"`
		LoadBalancers []LoadBalancer `json:"inventories"`
	} `json:"org.zstack.network.service.lb.APIQueryLoadBalancerReply"`
}

type CreateLoadBalancerParams struct {
	baseCreateParams
}

func NewCreateLoadBalancerParams() *CreateLoadBalancerParams {
	rtn := &CreateLoadBalancerParams{}
	rtn.p = make(map[string]interface{})
	return rtn
}

func (p *CreateLoadBalancerParams) toApiMessage() (string, error) {
	pp := make(map[string]interface{})
	pp["org.zstack.network.service.lb.APICreateLoadBalancerMsg"] = p.p
	b, err := json.Marshal(pp)
	if err != nil {
		return "", err
	}
	return string(b), nil
}

func (p *CreateLoadBalancerParams) SetName(name string) {
	p.makeSureNotNil()
	p.p["name"] = name
}

func (p *CreateLoadBalancerParams) SetDescription(description string) {
	p.makeSureNotNil()
	p.p["description"] = description
}

func (p *CreateLoadBalancerParams) SetVipUuid(vipUuid string) {
	p.makeSureNotNil()
	p.p["vipUuid"] = vipUuid
}

type CreateLoadBalancerResponse struct {
	Reply struct {
		id           string       `json:"id"`
		ApiId        string       `json:"apiId"`
		CreatedTime  uint64       `json:"createdTime"`
		Success      bool         `json:"success"`
		Error        ZStackError  `json:"error"`
		Type         ZStackType   `json:"type"`
		LoadBalancer LoadBalancer `json:"inventory"`
	} `json:"org.zstack.network.service.lb.APICreateLoadBalancerEvent"`
}

type DeleteLoadBalancerParams struct {
	baseDeleteParams
}

func NewDeleteLoadBalancerParams() *DeleteLoadBalancerParams {
	rtn := &DeleteLoadBalancerParams{}
	rtn.p = make(map[string]interface{})
	return rtn
}

func (p *DeleteLoadBalancerParams) toApiMessage() (string, error) {
	pp := make(map[string]interface{})
	pp["org.zstack.network.service.lb.APIDeleteLoadBalancerMsg"] = p.p
	b, err := json.Marshal(pp)
	if err != nil {
		return "", err
	}
	return string(b), nil
}

type DeleteLoadBalancerResponse struct {
	Reply struct {
		id          string      `json:"id"`
		ApiId       string      `json:"apiId"`
		CreatedTime uint64      `json:"createdTime"`
		Success     bool        `json:"success"`
		Error       ZStackError `json:"error"`
		Type        ZStackType  `json:"type"`
	} `json:"org.zstack.network.service.lb.APIDeleteLoadBalancerEvent"`
}

type QueryLoadBalancerListenerParams struct {
	baseQueryParams
}

func NewQueryLoadBalancerListenerParams() *QueryLoadBalancerListenerParams {
	rtn := &QueryLoadBalancerListenerParams{}
	rtn.p = make(map[string]interface{})
	return rtn
}

func (p *QueryLoadBalancerListenerParams) toApiMessage() (string, error) {
	pp := make(map[string]interface{})
	p.fillQueryStruct()
	pp["org.zstack.network.service.lb.APIQueryLoadBalancerListenerMsg"] = p.p
	b, err := json.Marshal(pp)
	if err != nil {
		return "", err
	}
	return string(b), nil
}

type QueryLoadBalancerListenerResponse struct {
	Reply struct {
		Id          string                 `json:"id"`
		Success     bool                   `json:"success"`
		ServiceId   string                 `json:"serviceId"`
		CreatedTime uint                   `json:"createdTime"`
		Total       uint16                 `json:"total"`
		Listeners   []LoadBalancerListener `json:"inventories"`
	} `json:"org.zstack.network.service.lb.APIQueryLoadBalancerListenerReply"`
}

type CreateLoadBalancerListenerParams struct {
	baseCreateParams
}

func NewCreateLoadBalancerListenerParams() *CreateLoadBalancerListenerParams {
	rtn := &CreateLoadBalancerListenerParams{}
	rtn.p = make(map[string]interface{})
	return rtn
}

func (p *CreateLoadBalancerListenerParams) toApiMessage() (string, error) {
	pp := make(map[string]interface{})
	pp["org.zstack.network.service.lb.APICreateLoadBalancerListenerMsg"] = p.p
	b, err := json.Marshal(pp)
	if err != nil {
		return "", err
	}
	return string(b), nil
}

func (p *CreateLoadBalancerListenerParams) SetLoadBalancerUuid(loadBalancerUuid string) {
	p.makeSureNotNil()
	p.p["loadBalancerUuid"] = loadBalancerUuid
}

func (p *CreateLoadBalancerListenerParams) SetName(name string) {
	p.makeSureNotNil()
	p.p["name"] = name
}

func (p *CreateLoadBalancerListenerParams) SetDescription(description string) {
	p.makeSureNotNil()
	p.p["description"] = description
}

func (p *CreateLoadBalancerListenerParams) SetInstancePort(instancePort uint16) {
	p.makeSureNotNil()
	p.p["instancePort"] = instancePort
}

func (p *CreateLoadBalancerListenerParams) SetLoadBalancerPort(loadBalancerPort uint16) {
	p.makeSureNotNil()
	p.p["loadBalancerPort"] = loadBalancerPort
}

func (p *CreateLoadBalancerListenerParams) SetProtocol(protocol string) {
	p.makeSureNotNil()
	p.p["protocol"] = protocol
}

type CreateLoadBalancerListenerResponse struct {
	Reply struct {
		id                   string               `json:"id"`
		ApiId                string               `json:"apiId"`
		CreatedTime          uint64               `json:"createdTime"`
		Success              bool                 `json:"success"`
		Error                ZStackError          `json:"error"`
		Type                 ZStackType           `json:"type"`
		LoadBalancerListener LoadBalancerListener `json:"inventory"`
	} `json:"org.zstack.network.service.lb.APICreateLoadBalancerListenerEvent"`
}

type DeleteLoadBalancerListenerParams struct {
	baseDeleteParams
}

func NewDeleteLoadBalancerListenerParams() *DeleteLoadBalancerListenerParams {
	rtn := &DeleteLoadBalancerListenerParams{}
	rtn.p = make(map[string]interface{})
	return rtn
}

func (p *DeleteLoadBalancerListenerParams) toApiMessage() (string, error) {
	pp := make(map[string]interface{})
	pp["org.zstack.network.service.lb.APIDeleteLoadBalancerListenerMsg"] = p.p
	b, err := json.Marshal(pp)
	if err != nil {
		return "", err
	}
	return string(b), nil
}

type DeleteLoadBalancerListenerResponse struct {
	Reply struct {
		id          string      `json:"id"`
		ApiId       string      `json:"apiId"`
		CreatedTime uint64      `json:"createdTime"`
		Success     bool        `json:"success"`
		Error       ZStackError `json:"error"`
		Type        ZStackType  `json:"type"`
	} `json:"org.zstack.network.service.lb.APIDeleteLoadBalancerListenerEvent"`
}

type baseLoadBalancerVmNicParams struct {
	baseParams
}

func (p *baseLoadBalancerVmNicParams) SetVmNicUuids(vmNicUuids string) {
	p.makeSureNotNil()
	p.p["vmNicUuids"] = vmNicUuids
}

func (p *baseLoadBalancerVmNicParams) SetListenerUuid(listenerUuid string) {
	p.makeSureNotNil()
	p.p["listenerUuid"] = listenerUuid
}

type AddVmNicToLoadBalancerParams struct {
	baseLoadBalancerVmNicParams
}

func NewAddVmNicToLoadBalancerParams() *AddVmNicToLoadBalancerParams {
	rtn := &AddVmNicToLoadBalancerParams{}
	rtn.p = make(map[string]interface{})
	return rtn
}

func (p *AddVmNicToLoadBalancerParams) toApiMessage() (string, error) {
	pp := make(map[string]interface{})
	pp["org.zstack.network.service.lb.APIAddVmNicToLoadBalancerMsg"] = p.p
	b, err := json.Marshal(pp)
	if err != nil {
		return "", err
	}
	return string(b), nil
}

type AddVmNicToLoadBalancerResponse struct {
	Reply struct {
		id                   string               `json:"id"`
		ApiId                string               `json:"apiId"`
		CreatedTime          uint64               `json:"createdTime"`
		Success              bool                 `json:"success"`
		Error                ZStackError          `json:"error"`
		Type                 ZStackType           `json:"type"`
		LoadBalancerListener LoadBalancerListener `json:"inventory"`
	} `json:"org.zstack.network.service.lb.APIAddVmNicToLoadBalancerEvent"`
}

type RemoveVmNicFromLoadBalancerParams struct {
	baseLoadBalancerVmNicParams
}

func NewRemoveVmNicFromLoadBalancerParams() *RemoveVmNicFromLoadBalancerParams {
	rtn := &RemoveVmNicFromLoadBalancerParams{}
	rtn.p = make(map[string]interface{})
	return rtn
}

func (p *RemoveVmNicFromLoadBalancerParams) toApiMessage() (string, error) {
	pp := make(map[string]interface{})
	pp["org.zstack.network.service.lb.APIRemoveVmNicFromLoadBalancerMsg"] = p.p
	b, err := json.Marshal(pp)
	if err != nil {
		return "", err
	}
	return string(b), nil
}

type RemoveVmNicFromLoadBalancerResponse struct {
	Reply struct {
		id           string       `json:"id"`
		ApiId        string       `json:"apiId"`
		CreatedTime  uint64       `json:"createdTime"`
		Success      bool         `json:"success"`
		Error        ZStackError  `json:"error"`
		Type         ZStackType   `json:"type"`
		LoadBalancer LoadBalancer `json:"inventory"`
	} `json:"org.zstack.network.service.lb.APIRemoveVmNicFromLoadBalancerEvent"`
}

type LoadBalancerService struct {
	zs ZStackClient
}

func NewLoadBalancerService(zs ZStackClient) *LoadBalancerService {
	return &LoadBalancerService{zs: zs}
}

func (s *LoadBalancerService) QueryLoadBalancer(param *QueryLoadBalancerParams, callback func(data QueryLoadBalancerResponse), error func(err interface{})) {
	var resp QueryLoadBalancerResponse
	s.zs.SyncApi(param, &resp, func() {
		callback(resp)
	}, error)
}

func (s *LoadBalancerService) CreateLoadBalancer(param *CreateLoadBalancerParams, callback func(data CreateLoadBalancerResponse), error func(err interface{})) {
	var resp CreateLoadBalancerResponse
	s.zs.AsyncApi(param, &resp, func() {
		callback(resp)
	}, error)
}

func (s *LoadBalancerService) DeleteLoadBalancer(param *DeleteLoadBalancerParams, callback func(data DeleteLoadBalancerResponse), error func(err interface{})) {
	var resp DeleteLoadBalancerResponse
	s.zs.AsyncApi(param, &resp, func() {
		callback(resp)
	}, error)
}

func (s *LoadBalancerService) QueryLoadBalancerListener(param *QueryLoadBalancerListenerParams, callback func(data QueryLoadBalancerListenerResponse), error func(err interface{})) {
	var resp QueryLoadBalancerListenerResponse
	s.zs.SyncApi(param, &resp, func() {
		callback(resp)
	}, error)
}

func (s *LoadBalancerService) CreateLoadBalancerListener(param *CreateLoadBalancerListenerParams, callback func(data CreateLoadBalancerListenerResponse), error func(err interface{})) {
	var resp CreateLoadBalancerListenerResponse
	s.zs.AsyncApi(param, &resp, func() {
		callback(resp)
	}, error)
}

func (s *LoadBalancerService) DeleteLoadBalancerListener(param *DeleteLoadBalancerListenerParams, callback func(data DeleteLoadBalancerResponse), error func(err interface{})) {
	var resp DeleteLoadBalancerResponse
	s.zs.AsyncApi(param, &resp, func() {
		callback(resp)
	}, error)
}

func (s *LoadBalancerService) AddVmNicToLoadBalancer(param *AddVmNicToLoadBalancerParams, callback func(data AddVmNicToLoadBalancerResponse), error func(err interface{})) {
	var resp AddVmNicToLoadBalancerResponse
	s.zs.AsyncApi(param, &resp, func() {
		callback(resp)
	}, error)
}

func (s *LoadBalancerService) RemoveVmNicFromLoadBalancer(param *RemoveVmNicFromLoadBalancerParams, callback func(data RemoveVmNicFromLoadBalancerResponse), error func(err interface{})) {
	var resp RemoveVmNicFromLoadBalancerResponse
	s.zs.AsyncApi(param, &resp, func() {
		callback(resp)
	}, error)

}
