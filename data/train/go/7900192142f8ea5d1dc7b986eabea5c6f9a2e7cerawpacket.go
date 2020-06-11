// Author  Raido Pahtma
// License MIT

package sfconnection

import "fmt"

type RawPacket struct {
	dispatch byte
	Payload  []byte
}

var _ Packet = (*RawPacket)(nil)
var _ PacketFactory = (*RawPacket)(nil)

func NewRawPacket(dispatch byte) *RawPacket {
	p := new(RawPacket)
	p.dispatch = dispatch
	return p
}

func (self *RawPacket) NewPacket() Packet {
	p := new(RawPacket)
	p.dispatch = self.dispatch
	return p
}

func (self *RawPacket) Dispatch() byte {
	return self.dispatch
}

func (self *RawPacket) SetPayload(payload []byte) error {
	self.Payload = payload
	return nil
}

func (self *RawPacket) GetPayload() []byte {
	return self.Payload
}

func (self *RawPacket) Serialize() ([]byte, error) {
	p := make([]byte, len(self.Payload)+1)
	p[0] = self.dispatch
	copy(p[1:], self.Payload)
	return p, nil
}

func (self *RawPacket) Deserialize(data []byte) error {
	self.Payload = make([]byte, len(data)-1)
	copy(self.Payload, data[1:])
	return nil
}

func (self *RawPacket) String() string {
	return fmt.Sprintf("%X", self.Payload)
}
