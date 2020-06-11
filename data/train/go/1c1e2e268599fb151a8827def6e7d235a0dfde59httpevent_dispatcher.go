package workers

import (
	"bytes"
	"fmt"
	"net/http"

	"github.com/nicholasjackson/sorcery/entities"
)

type HTTPEventDispatcher struct {
}

func (h *HTTPEventDispatcher) DispatchEvent(event *entities.Event, endpoint string) (int, error) {
	fmt.Println("DispatchEvent to:", endpoint)

	payload := []byte(event.Payload)
	reader := bytes.NewReader(payload)

	resp, err := http.Post(endpoint, "application/json", reader)
	if err != nil {
		fmt.Println("DispatchEvent: Error:", err)
		return 500, err
	}

	defer resp.Body.Close()
	return resp.StatusCode, nil
}
