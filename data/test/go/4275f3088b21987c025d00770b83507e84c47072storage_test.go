package base

import (
	"testing"

	"path/filepath"

	"fmt"

	"os"

	"github.com/ineiti/cybermind/broker"
	"github.com/ineiti/cybermind/modules/test"
	"github.com/stretchr/testify/require"
	"gopkg.in/dedis/onet.v1/log"
)

func TestStorageSave(t *testing.T) {
	sb := initStorageBroker(true)
	sb.Broker.BroadcastMessage(&broker.Message{
		ID:      broker.NewMessageID(),
		Objects: getObjs(1),
		Tags:    broker.Tags{broker.NewTag("test", "123")},
	})
	sb.Broker.Stop()

	log.Lvl1("Starting new broker")
	sb = initStorageBroker(false)
	modId := broker.NewKeyValue("module_id", fmt.Sprintf("X'%x'", ModuleIDConfig))
	sb.Broker.BroadcastMessage(StorageSearchObject(modId))
	log.Print(sb.Logger.Messages)
	require.Equal(t, 2, len(sb.Logger.Messages))
	sb.Broker.Stop()
}

func TestStorageSaveTagsObject(t *testing.T) {
	sb := initStorageBroker(true)
	sb.Broker.BroadcastMessage(&broker.Message{
		ID:      broker.NewMessageID(),
		Objects: getObjs(1),
		Tags:    getTags(2),
	})
	sb.Broker.Stop()

	log.Lvl1("Starting new broker")
	sb = initStorageBroker(false)
	sb.Broker.BroadcastMessage(&broker.Message{
		ID: broker.NewMessageID(),
		Action: broker.Action{
			Command: storageActionSearchObject,
			Arguments: map[string]string{
				"module_id": fmt.Sprintf("X'%x'", ModuleIDConfig),
			},
		},
	})
	log.Print(sb.Logger.Messages)
	require.Equal(t, 2, len(sb.Logger.Messages))
	find := sb.Logger.Messages[1]
	require.Equal(t, 1, len(find.Objects))
	sb.Broker.Stop()
}

func TestStorageSaveRelation(t *testing.T) {
	sb := initStorageBroker(true)
	tags := broker.Tags{broker.NewTag("test", "123"),
		broker.NewTag("test2", "456")}

	sb.Broker.BroadcastMessage(&broker.Message{
		ID:      broker.NewMessageID(),
		Objects: getObjs(2),
		Tags:    tags,
	})
	sb.Broker.Stop()

	log.Lvl1("Starting new broker")
	sb = initStorageBroker(false)
	log.ErrFatal(sb.Broker.BroadcastMessage(StorageSearchTag(broker.NewKeyValue("key", "test"))))
	log.Print(sb.Logger.Messages)
	require.Equal(t, 2, len(sb.Logger.Messages))
	sb.Broker.Stop()
}

func TestStorageTagTags(t *testing.T) {
	sb := initStorageBroker(true)
	tags := broker.Tags{broker.NewTag("test", "123"),
		broker.NewTag("test2", "456"),
		broker.NewTag("test3", "789")}
	(&tags[2]).AddAssociation([]broker.Tag{tags[0], tags[1]}, broker.AssociationIsA)

	sb.Broker.BroadcastMessage(&broker.Message{
		ID:   broker.NewMessageID(),
		Tags: tags,
	})
	log.Print(tags)
	sb.Broker.Stop()

	log.Lvl1("Starting new broker")
	sb = initStorageBroker(false)
	sb.Broker.BroadcastMessage(&broker.Message{
		ID: broker.NewMessageID(),
		Action: broker.Action{
			Command:   storageActionSearchTag,
			Arguments: map[string]string{"Key": "test3"},
		},
	})
	log.Print(sb.Logger.Messages)
	require.Equal(t, 2, len(sb.Logger.Messages))
	require.Equal(t, 1, len(sb.Logger.Messages[1].Tags))
	tag := sb.Logger.Messages[1].Tags[0]
	require.Equal(t, 1, len(tag.TagA))
	log.Print(tag.TagA[0].Tags)
	require.Equal(t, 3, len(tag.TagA[0].Tags))
	require.Equal(t, uint64(broker.AssociationIsA), tag.TagA[0].Association)
	sb.Broker.Stop()
}

type storBrok struct {
	Broker *broker.Broker
	Logger *test.Logger
}

func initStorageBroker(clear bool) *storBrok {
	if clear {
		path := filepath.Join(broker.ConfigPath, StorageDB)
		os.Remove(path)
	}
	sb := &storBrok{
		Broker: broker.NewBroker(),
	}
	RegisterStorage(sb.Broker)
	sb.Logger = test.SpawnLogger(sb.Broker)
	return sb
}

func getObjs(num int) []broker.Object {
	var objs []broker.Object
	for n := 0; n < num; n++ {
		objs = append(objs, broker.Object{
			GID:      broker.NewObjectID(),
			ModuleID: ModuleIDConfig,
		})
	}
	return objs
}

func getTags(num int) []broker.Tag {
	tags := broker.Tags{broker.NewTag("test", "123"),
		broker.NewTag("test2", "456"),
		broker.NewTag("test3", "789")}
	return tags[0:num]
}
