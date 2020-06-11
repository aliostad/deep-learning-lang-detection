package process_result

import (
	"github.com/mlmhl/gcrawler/common/item"
	"github.com/mlmhl/gcrawler/common/request"
)

// Result for page processor.
type ProcessResult struct {
	items    []*item.Item
	requests []*request.Request
}

func NewProcessResult() *ProcessResult {
	return &ProcessResult{
		items:    []*item.Item{},
		requests: []*request.Request{},
	}
}

func (processResult *ProcessResult) AddRequest(url string, resType int) {
	processResult.requests = append(processResult.requests,
		request.NewRequest(url, "GET", nil, "", resType))
}

func (processResult *ProcessResult) AddItem(item *item.Item) {
	processResult.items = append(processResult.items, item)
}

func (processResult *ProcessResult) AddURequests(urls []string, resType int) {
	for _, url := range urls {
		processResult.AddRequest(url, resType)
	}
}

func (processResult *ProcessResult) GetResult() ([]*request.Request, []*item.Item) {
	return processResult.requests, processResult.items
}
