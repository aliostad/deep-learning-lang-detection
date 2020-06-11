package linda

import (
	"github.com/sirupsen/logrus"
	"testing"
	"time"
)

func setupRedisBroker(t *testing.T) {
	logrus.SetLevel(logrus.DebugLevel)
	broker = &RedisBroker{}
	if err := broker.Connect("redis://localhost:6379/", time.Second); err != nil {
		t.Error(err)
	} else {
		t.Log("setupRedisBroker")
	}
}

func closeRedisBroker(t *testing.T) {
	if err := broker.Close(); err != nil {
		t.Error(err)
	} else {
		t.Log("closeRedisBroker")
	}
}

func TestRedisBroker_MigrateExpiredJobs(t *testing.T) {
	setupRedisBroker(t)
	defer closeRedisBroker(t)

	broker.MigrateExpiredJobs("test")
	t.Log("TestRedisBroker_MigrateExpiredJobs")
}

func TestRedisBroker_Push(t *testing.T) {
	setupRedisBroker(t)
	defer closeRedisBroker(t)

	queue := "test"
	id := "1"
	if err := broker.Push(queue, id); err != nil {
		t.Error(err)
	} else {
		t.Log("TestRedisBroker_Push", queue, id)
	}
}

func TestRedisBroker_Delete(t *testing.T) {
	setupRedisBroker(t)
	defer closeRedisBroker(t)

	queue := "test"
	id := "2"
	if err := broker.Delete(queue, id); err != nil {
		t.Error(err)
	} else {
		t.Log("TestRedisBroker_Delete", queue, id)
	}
}

func TestRedisBroker_Later(t *testing.T) {
	setupRedisBroker(t)
	defer closeRedisBroker(t)

	queue := "test"
	id := "3"
	delay := int64(60)

	if err := broker.Later(queue, id, delay); err != nil {
		t.Error(err)
	} else {
		t.Log("TestRedisBroker_Later", queue, id, delay)
	}
}

func TestRedisBroker_Release(t *testing.T) {
	setupRedisBroker(t)
	defer closeRedisBroker(t)

	queue := "test"
	id := "3"
	delay := int64(60)
	if err := broker.Release(queue, id, delay); err != nil {
		t.Error(err)
	} else {
		t.Log("TestRedisBroker_Release", queue, id, delay)
	}
}

func TestRedisBroker_Reserve(t *testing.T) {
	setupRedisBroker(t)
	defer closeRedisBroker(t)

	queue := "test"
	timeout := int64(60)
	if id, err := broker.Reserve(queue, timeout); err != nil {
		t.Error(err)
	} else {
		t.Log("TestRedisBroker_Reserve", queue, timeout, id)
	}
}
