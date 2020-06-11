package gudp

import (
	"net"
)

// Client sends the request to the Server
type Client struct {
	handlers
	Host       string
	Port       int
	BufferSize int
	err        error
}

// Dispatch sends opens up a connnection, sends a message and closes it.
func (client *Client) Dispatch(msg []byte) error {
	var address *net.UDPAddr
	var conn *net.UDPConn

	address, client.err = getAddress(client.Host, client.Port)
	conn, client.err = getConnection(address, "dial")

	defer conn.Close()

	conn.SetWriteBuffer(client.BufferSize)

	_, client.err = conn.Write(msg)

	return client.err
}
