// worker
package engine

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"time"
)

type LoadWorker struct {
	loadStorage  *LoadStorage
	loadReporter *LoadReporter
}

func NewWorker(loadStorage *LoadStorage, loadReporter *LoadReporter) *LoadWorker {
	return &LoadWorker{
		loadStorage:  loadStorage,
		loadReporter: loadReporter,
	}
}

func (worker *LoadWorker) HttpGet(name string, url string) error {
	client := &http.Client{}
	before := time.Now()
	resp, err := client.Get(url)
	if err != nil {
		worker.loadReporter.Error(fmt.Sprintf("call http.Client.Get failed with result: %+v\n", err))
		return err
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		worker.loadReporter.Error(fmt.Sprintf("call ioutil.ReadAll failed with result: %+v\n", err))
		return err
	}
	after := time.Now()
	if worker.loadReporter != nil {
		worker.loadReporter.Metric("ResponseLength", len(body))
		worker.loadReporter.Metric("ResponseTime", after.UnixNano()-before.UnixNano())
		//worker.loadReporter.Info("ResponseBody: " + string(body))
	}
	return nil
}

func (worker *LoadWorker) HtmlGet(url string) error {
	return nil
}
