package zstack

import (
	"log"
	"testing"
)

func initZSClient() ZStackClient {
	return NewClient("http://172.18.0.101:9999", "cc91bf9cb8fb4898856e87b6a2e15eef", "85ae9643f6164ce099a06f73ed964059", false)
}

func TestZstack1(t *testing.T) {
	zs := initZSClient()
	loadBalancerService := NewLoadBalancerService(zs)

	queryLoadBalancerParams := NewQueryLoadBalancerParams()
	queryLoadBalancerParams.SetCount(false)
	queryLoadBalancerParams.SetLimit(10)
	queryLoadBalancerParams.SetStart(0)
	queryLoadBalancerParams.SetReplyWithCount(true)
	conditions := make([]QueryCondition, 0)
	conditions = append(conditions, *&QueryCondition{Name: "ccc.name", Op: "=", Value: "rr"})
	queryLoadBalancerParams.SetConditions(conditions)

	loadBalancerService.QueryLoadBalancer(queryLoadBalancerParams, func(data QueryLoadBalancerResponse) {
		log.Println("susses")
		if len(data.Reply.LoadBalancers) == 1 {
			log.Println(data.Reply.LoadBalancers[0].Listeners[0].VmNicRefs[0].VmNicUuid)
		} else if len(data.Reply.LoadBalancers) == 0 {
			t.Error("未查询到结果")
		}
	}, func(err interface{}) {
		log.Println("error")
		log.Println(err)
	})
}

func TestZstack2(t *testing.T) {
	zs := initZSClient()
	loadBalancerService := NewLoadBalancerService(zs)

	createLoadBalancerParams := NewCreateLoadBalancerParams()
	createLoadBalancerParams.SetName("test from go")
	createLoadBalancerParams.SetDescription("test from go")
	createLoadBalancerParams.SetVipUuid("73e2bf8bc972463a8131e2a0e603a68c")

	wait := make(chan int)

	loadBalancerService.CreateLoadBalancer(createLoadBalancerParams, func(resp CreateLoadBalancerResponse) {
		log.Println(resp)
	}, func(err interface{}) {
		log.Println("error")
		log.Println(err)
	})
	<-wait
}
