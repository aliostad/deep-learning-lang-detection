package api

/************************************************
  generated by IDE. for [LoadBalancerAPI]
************************************************/

import (
	"github.com/yamamoto-febc/libsacloud/sacloud"
)

/************************************************
   To support influent interface for Find()
************************************************/

func (api *LoadBalancerAPI) Reset() *LoadBalancerAPI {
	api.reset()
	return api
}

func (api *LoadBalancerAPI) Offset(offset int) *LoadBalancerAPI {
	api.offset(offset)
	return api
}

func (api *LoadBalancerAPI) Limit(limit int) *LoadBalancerAPI {
	api.limit(limit)
	return api
}

func (api *LoadBalancerAPI) Include(key string) *LoadBalancerAPI {
	api.include(key)
	return api
}

func (api *LoadBalancerAPI) Exclude(key string) *LoadBalancerAPI {
	api.exclude(key)
	return api
}

func (api *LoadBalancerAPI) FilterBy(key string, value interface{}) *LoadBalancerAPI {
	api.filterBy(key, value, false)
	return api
}

// func (api *LoadBalancerAPI) FilterMultiBy(key string, value interface{}) *LoadBalancerAPI {
// 	api.filterBy(key, value, true)
// 	return api
// }

func (api *LoadBalancerAPI) WithNameLike(name string) *LoadBalancerAPI {
	return api.FilterBy("Name", name)
}

func (api *LoadBalancerAPI) WithTag(tag string) *LoadBalancerAPI {
	return api.FilterBy("Tags.Name", tag)
}
func (api *LoadBalancerAPI) WithTags(tags []string) *LoadBalancerAPI {
	return api.FilterBy("Tags.Name", []interface{}{tags})
}

// func (api *LoadBalancerAPI) WithSizeGib(size int) *LoadBalancerAPI {
// 	api.FilterBy("SizeMB", size*1024)
// 	return api
// }

// func (api *LoadBalancerAPI) WithSharedScope() *LoadBalancerAPI {
// 	api.FilterBy("Scope", "shared")
// 	return api
// }

// func (api *LoadBalancerAPI) WithUserScope() *LoadBalancerAPI {
// 	api.FilterBy("Scope", "user")
// 	return api
// }

func (api *LoadBalancerAPI) SortBy(key string, reverse bool) *LoadBalancerAPI {
	api.sortBy(key, reverse)
	return api
}

func (api *LoadBalancerAPI) SortByName(reverse bool) *LoadBalancerAPI {
	api.sortByName(reverse)
	return api
}

// func (api *LoadBalancerAPI) SortBySize(reverse bool) *LoadBalancerAPI {
// 	api.sortBy("SizeMB", reverse)
// 	return api
// }

/************************************************
  To support CRUD(Create/Read/Update/Delete)
************************************************/

// func (api *LoadBalancerAPI) New() *sacloud.LoadBalancer {
// 	return &sacloud.LoadBalancer{}
// }

// func (api *LoadBalancerAPI) Create(value *sacloud.LoadBalancer) (*sacloud.LoadBalancer, error) {
// 	return api.request(func(res *sacloud.Response) error {
// 		return api.create(api.createRequest(value), res)
// 	})
// }

// func (api *LoadBalancerAPI) Read(id string) (*sacloud.LoadBalancer, error) {
// 	return api.request(func(res *sacloud.Response) error {
// 		return api.read(id, nil, res)
// 	})
// }

// func (api *LoadBalancerAPI) Update(id string, value *sacloud.LoadBalancer) (*sacloud.LoadBalancer, error) {
// 	return api.request(func(res *sacloud.Response) error {
// 		return api.update(id, api.createRequest(value), res)
// 	})
// }

// func (api *LoadBalancerAPI) Delete(id string) (*sacloud.LoadBalancer, error) {
// 	return api.request(func(res *sacloud.Response) error {
// 		return api.delete(id, nil, res)
// 	})
// }

/************************************************
  Inner functions
************************************************/

func (api *LoadBalancerAPI) setStateValue(setFunc func(*sacloud.Request)) *LoadBalancerAPI {
	api.baseAPI.setStateValue(setFunc)
	return api
}

//func (api *LoadBalancerAPI) request(f func(*sacloud.Response) error) (*sacloud.LoadBalancer, error) {
//	res := &sacloud.Response{}
//	err := f(res)
//	if err != nil {
//		return nil, err
//	}
//	return res.LoadBalancer, nil
//}
//
//func (api *LoadBalancerAPI) createRequest(value *sacloud.LoadBalancer) *sacloud.Request {
//	req := &sacloud.Request{}
//	req.LoadBalancer = value
//	return req
//}
