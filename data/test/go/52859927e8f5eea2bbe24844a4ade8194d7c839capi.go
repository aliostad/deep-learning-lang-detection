package taskqueue

import (
	"net/url"

	"golang.org/x/net/context"
	ae "google.golang.org/appengine/taskqueue"
)

var queueManager QueueManager

func GetQueueManager() QueueManager {
	return queueManager
}

func UseAeQueueManager() {
	queueManager = NewAeQueueManager()
}

func UseNonExecutingQueueManager() {
	queueManager = NewNonExecutingQueueManager()
}

func NewPOSTTask(path string, params url.Values) *ae.Task {
	return ae.NewPOSTTask(path, params)
}

func Add(c context.Context, task *ae.Task, queueName string) (*ae.Task, error) {
	return queueManager.Add(c, task, queueName)
}

func Delete(c context.Context, task *ae.Task, queueName string) error {
	return queueManager.Delete(c, task, queueName)
}
