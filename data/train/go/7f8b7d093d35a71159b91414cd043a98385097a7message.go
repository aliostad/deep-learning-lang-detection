package messages

import (
	gdb "github.com/huntaub/go-db"
)

// A full AirDispatch Message
type Message struct {
	Id gdb.PrimaryKey
	// Name registered on Server
	Name string
	// Cleared Addresses
	To string
	// Fingerprint of Sender
	From string
	// Message Metadata
	Alert    bool
	Incoming bool
	Date     int64

	Components *gdb.HasMany `table:"component" on:"message"`
}

// An AirDispatch Component
type Component struct {
	Id      gdb.PrimaryKey
	Message *gdb.HasOne `table:"message"`
	Name    string
	Data    []byte
}
