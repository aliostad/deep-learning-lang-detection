package shipper

import (
	"fmt"
	"os"
	"time"
)

type Dispatcher struct {
	Client            LogShipper
	TimestampProvider TimeProvider
	Metadata          LogMetadata
	BulkSize          int
	FlushTimeout      time.Duration
}

func (d *Dispatcher) Run(input <-chan string) {
	collection := &dispatchCollection{}
	timeout := time.After(d.FlushTimeout)
	for {
		select {
		case line, ok := <-input:
			if !ok {
				collection.Flush(d.Client)
				return
			}
			entry := d.buildLogEntry(line)
			collection.Append(entry)
			if collection.Size() == d.BulkSize {
				collection.Flush(d.Client)
			}
		case <-timeout:
			collection.Flush(d.Client)
			timeout = time.After(d.FlushTimeout)
		}
	}
}

func (d *Dispatcher) buildLogEntry(line string) LogEntry {
	return LogEntry{
		Timestamp: d.TimestampProvider.Now(),
		Message:   line,
		Metadata:  d.Metadata,
	}
}

type dispatchCollection struct {
	collection LogCollection
}

func (c *dispatchCollection) Append(entry LogEntry) {
	c.collection.Logs = append(c.collection.Logs, entry)
}

func (c *dispatchCollection) Size() int {
	return len(c.collection.Logs)
}

func (c *dispatchCollection) Flush(client LogShipper) {
	if len(c.collection.Logs) == 0 {
		return
	}
	if err := client.Ship(c.collection); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to ship log: %s\n", err)
	}
	c.collection.Logs = nil
}
