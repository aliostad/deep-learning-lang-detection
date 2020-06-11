package courier

import (
	"context"
	"errors"
	"net/http"
	"net/url"

	"go.uber.org/cadence"
)

func init() {
	cadence.RegisterActivity(DispatchCourierActivity)
}

// DispatchCourierActivity implements the dispatch courier activity.
func DispatchCourierActivity(ctx context.Context, orderID string) (string, error) {
	return "", errors.New("not implemented")
}

func dispatch(orderID string, taskToken string) error {
	formData := url.Values{}
	formData.Add("id", orderID)
	formData.Add("task_token", taskToken)

	url := "http://localhost:8090/courier"
	_, err := http.PostForm(url, formData)
	if err != nil {
		return err
	}

	return nil
}
