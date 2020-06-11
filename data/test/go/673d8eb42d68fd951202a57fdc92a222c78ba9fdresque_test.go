package resque

import (
	"exec"
	"log"
	"os"
	"testing"
	"github.com/bmizerany/assert"
)


var i = 0

func myProcessor(args map[string] interface{}) {
	i++
}

func loadRedis() {
	cmd := exec.Command("ruby", "loader.rb")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err := cmd.Run()
	if err != nil {
		log.Fatalln("Unable to load messages into Redis", err)
	}
}

func TestClient(t *testing.T) {
	loadRedis()

  Register("Job", myProcessor)

  spec := &ClientSpec{
    "localhost:6379",
    "test_queue",
    4,
  }
  client := NewClient(spec)

	job := client.Fetch()
	result := client.Dispatch(job)
	assert.Equal(t, result, true)
	assert.Equal(t, i, 1)

	job = client.Fetch()
	result = client.Dispatch(job)
	assert.Equal(t, result, true)
	assert.Equal(t, i, 2)

	job = client.Fetch()
	result = client.Dispatch(job)
	assert.Equal(t, result, false)
	assert.Equal(t, i, 2)
}
