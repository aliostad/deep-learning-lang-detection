package cmds

import (
	"github.com/funny/link"
)

type C1000Down struct {
	a1 int8     //8，1
	a2 int16    //16，2
	a3 int32    //32，3
	a4 int64    //64，4
	a5 string   //String，5
	a6 float32  //f32，6
	a7 float64  //f64，7
	a8 uint8    //u8，8
	a9 uint16   //u16，9
	a10 uint32  //u32，0
	a11 uint64  //u64，11
}

func (s *C1000Down)PackInTo(p *link.OutBufferBE ) {
	p.WriteInt8(s.a1)//1
	p.WriteInt16(s.a2)//2
	p.WriteInt32(s.a3)//3
	p.WriteInt50(s.a4)//4
	p.WriteUint16(uint16(len(s.a5)))
	p.WriteString(s.a5)//5
	p.WriteFloat32(s.a6)//6
	p.WriteFloat64(s.a7)//7
	p.WriteUint8(s.a8)//8
	p.WriteUint16(s.a9)//9
	p.WriteUint32(s.a10)//0
	p.WriteUint64(s.a11)//11
}
func (s *C1000Down)ToBuffer() *link.OutBufferBE {
	p := new(link.OutBufferBE)
	(*p).WriteUint16(1000) //写入协议号
	s.PackInTo(p)
	return p
}
