package queue

import (
	"fmt"
	"testing"

	"github.com/innovate-technologies/Dispatch/dispatchd/config"
	"github.com/innovate-technologies/Dispatch/test/etcdserver"
	"github.com/stretchr/testify/assert"
)

func init() {
	cfg := config.GetConfiguration()
	Config = &cfg
}

func Test_AddUnit(t *testing.T) {
	etcdserver.Start()

	AddUnit("test.service")

	res, _ := etcdAPI.Get(ctx, fmt.Sprintf("/dispatch/%s/queue/test.service", Config.Zone))
	assert.Equal(t, "test.service", string(res.Kvs[0].Value))

	res, _ = etcdAPI.Get(ctx, fmt.Sprintf("/dispatch/%s/units/test.service/machine", Config.Zone))
	assert.Equal(t, "", string(res.Kvs[0].Value))

	etcdserver.Stop()
}

func Test_assignUnitToMachine(t *testing.T) {
	etcdserver.Start()

	etcdAPI.Put(ctx, fmt.Sprintf("/dispatch/%s/queue/test.service", Config.Zone), "test.service")
	assignUnitToMachine("test.service", "test-machine")

	res, _ := etcdAPI.Get(ctx, fmt.Sprintf("/dispatch/%s/queue/test.service", Config.Zone))
	assert.Equal(t, int64(0), res.Count, "queue remove")

	res, _ = etcdAPI.Get(ctx, fmt.Sprintf("/dispatch/%s/machines/test-machine/units/test.service", Config.Zone))
	assert.Equal(t, "test.service", string(res.Kvs[0].Value))

	res, _ = etcdAPI.Get(ctx, fmt.Sprintf("/dispatch/%s/units/test.service/machine", Config.Zone))
	assert.Equal(t, "test-machine", string(res.Kvs[0].Value))

	etcdserver.Stop()
}
