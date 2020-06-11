package supervisor

import (
	"fmt"
	"testing"
	"time"

	etcd "github.com/coreos/etcd/clientv3"
	"github.com/innovate-technologies/Dispatch/dispatchd/config"
	"github.com/innovate-technologies/Dispatch/dispatchd/supervisor/queue"
	"github.com/innovate-technologies/Dispatch/test/etcdserver"
	"github.com/stretchr/testify/assert"
)

func init() {
	cfg := config.GetConfiguration()
	Config = &cfg
	queue.Config = &cfg
}

func Test_isSupervisorAlive(t *testing.T) {
	etcdserver.Start()

	etcdAPI.Put(ctx, fmt.Sprintf("/dispatch/%s/supervisor/alive", Config.Zone), "1")
	assert.Equal(t, isSupervisorAlive(), true)

	etcdAPI.Delete(ctx, fmt.Sprintf("/dispatch/%s/supervisor/alive", Config.Zone))
	assert.Equal(t, isSupervisorAlive(), false)

	etcdserver.Stop()
}

func Test_voteForSupervisor_FirstVote(t *testing.T) {
	etcdserver.Start()
	voteForSupervisor()

	res, _ := etcdAPI.Get(ctx, fmt.Sprintf("/dispatch/%s/vote", Config.Zone))

	assert.Equal(t, int64(1), res.Count)
	if res.Count > 0 { // not wanting to cause panic here
		assert.Equal(t, Config.MachineName, string(res.Kvs[0].Value))
	}

	etcdserver.Stop()
}

func Test_voteForSupervisor_SecondVote(t *testing.T) {
	etcdserver.Start()
	voteForSupervisor()

	etcdAPI.Put(ctx, fmt.Sprintf("/dispatch/%s/vote", Config.Zone), "trump")

	res, _ := etcdAPI.Get(ctx, fmt.Sprintf("/dispatch/%s/vote", Config.Zone))

	assert.Equal(t, int64(1), res.Count)
	if res.Count > 0 { // not wanting to cause panic here
		assert.Equal(t, "trump", string(res.Kvs[0].Value))
	}

	etcdserver.Stop()
}

func Test_voteForSupervisor_AfterVoteDelete(t *testing.T) {
	etcdserver.Start()

	l, _ := etcdAPI.Lease.Grant(ctx, 1)
	etcdAPI.Put(ctx, fmt.Sprintf("/dispatch/%s/vote", Config.Zone), "trump", etcd.WithLease(l.ID))
	time.Sleep(3 * time.Second)

	voteForSupervisor()

	res, _ := etcdAPI.Get(ctx, fmt.Sprintf("/dispatch/%s/vote", Config.Zone))

	assert.Equal(t, int64(1), res.Count)
	if res.Count > 0 { // not wanting to cause panic here
		assert.Equal(t, Config.MachineName, string(res.Kvs[0].Value))
	}

	etcdserver.Stop()
}

func Test_winningVote(t *testing.T) {
	etcdserver.Start()

	etcdAPI.Put(ctx, fmt.Sprintf("/dispatch/%s/vote", Config.Zone), "trump")
	assert.Equal(t, "trump", getWinningVote())

	etcdserver.Stop()
}

func Test_watchToBecomeSupervisorAndWin(t *testing.T) {
	etcdserver.Start()

	l, _ := etcdAPI.Lease.Grant(ctx, 1)
	etcdAPI.Put(ctx, fmt.Sprintf("/dispatch/%s/supervisor/alive", Config.Zone), "1", etcd.WithLease(l.ID))

	watchToBecomeSupervisor()

	res, _ := etcdAPI.Get(ctx, fmt.Sprintf("/dispatch/%s/supervisor/machine", Config.Zone))

	assert.Equal(t, Config.MachineName, string(res.Kvs[0].Value))

	etcdserver.Stop()
}

func Test_checkForDeadMachines(t *testing.T) {
	etcdserver.Start()

	etcdAPI.Put(ctx, fmt.Sprintf("/dispatch/%s/machines/dead-body/name", Config.Zone), "dead-body")

	checkForDeadMachines()

	res, _ := etcdAPI.Get(ctx, fmt.Sprintf("/dispatch/%s/machines/dead-body/name", Config.Zone), etcd.WithPrefix())
	assert.Equal(t, int64(0), res.Count)

	etcdserver.Stop()
}

func Test_checkForDeadMachines_withUnits(t *testing.T) {
	etcdserver.Start()

	etcdAPI.Put(ctx, fmt.Sprintf("/dispatch/%s/machines/die-nginx/name", Config.Zone), "dead-body")
	etcdAPI.Put(ctx, fmt.Sprintf("/dispatch/%s/machines/die-nginx/units/caddy.service", Config.Zone), "caddy.service")

	checkForDeadMachines()

	res, _ := etcdAPI.Get(ctx, fmt.Sprintf("/dispatch/%s/machines/die-nginx", Config.Zone), etcd.WithPrefix())
	assert.Equal(t, int64(0), res.Count)

	queue, _ := etcdAPI.Get(ctx, fmt.Sprintf("/dispatch/%s/queue/", Config.Zone), etcd.WithPrefix())
	assert.Equal(t, int64(1), queue.Count)

	etcdserver.Stop()
}

func Test_foundNewMachine(t *testing.T) {
	etcdserver.Start()

	etcdAPI.Put(ctx, fmt.Sprintf("/dispatch/%s/machines/hello-world/name", Config.Zone), "dead-body")
	etcdAPI.Put(ctx, fmt.Sprintf("/dispatch/%s/machines/hello-world/alive", Config.Zone), "1")
	etcdAPI.Put(ctx, fmt.Sprintf("/dispatch/%s/globals/caddy.service", Config.Zone), "caddy.service")

	foundNewMachine(fmt.Sprintf("/dispatch/%s/machines/hello-world", Config.Zone))

	units, _ := etcdAPI.Get(ctx, fmt.Sprintf("/dispatch/%s/machines/hello-world/units", Config.Zone), etcd.WithPrefix())
	assert.Equal(t, int64(1), units.Count)

	etcdserver.Stop()
}
