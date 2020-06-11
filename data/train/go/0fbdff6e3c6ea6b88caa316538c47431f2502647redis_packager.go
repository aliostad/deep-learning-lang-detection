package protocol

import (
	"bytes"
	"fmt"
	"strconv"
)

type RedisPacket struct {
	rawContent bytes.Buffer
	// Scratch space for formatting integers and floats.
	numScratch [40]byte
}

func (r *RedisPacket) Wrap(cmd string, args ...interface{}) {
	r.writeCommand(cmd, args...)
}

func (r *RedisPacket) writeCommand(cmd string, args ...interface{}) {
	//clean data if the writeCommand has been called
	r.rawContent.Reset()

	r.writeLen('*', 1+len(args))
	r.writeString(cmd)
	for _, arg := range args {
		switch arg := arg.(type) {
		case string:
			r.writeString(arg)
		case []byte:
			r.writeBytes(arg)
		case int:
			r.writeInt64(int64(arg))
		case int64:
			r.writeInt64(arg)
		case float64:
			r.writeFloat64(arg)
		case bool:
			if arg {
				r.writeString("1")
			} else {
				r.writeString("0")
			}
		case nil:
			r.writeString("")
		default:
			var buf bytes.Buffer
			fmt.Fprint(&buf, arg)
			r.writeBytes(buf.Bytes())
		}
	}
}

func (r *RedisPacket) WriteOK() {
	r.rawContent.WriteString("+OK\r\n")
}

func (r *RedisPacket) WriteError(errs string) {
	r.rawContent.WriteString(fmt.Sprintf("-%s\r\n", errs))
}

func (r *RedisPacket) writeLen(prefix byte, n int) {
	r.rawContent.WriteByte(prefix)
	r.rawContent.WriteString(strconv.Itoa(n))
	r.rawContent.WriteString("\r\n")
}

func (r *RedisPacket) writeString(s string) {
	r.writeLen('$', len(s))
	r.rawContent.WriteString(s)
	r.rawContent.WriteString("\r\n")
}

func (r *RedisPacket) writeBytes(p []byte) {
	r.writeLen('$', len(p))
	r.rawContent.Write(p)
	r.rawContent.WriteString("\r\n")
}

func (r *RedisPacket) writeFloat64(n float64) {
	r.writeBytes(strconv.AppendFloat(r.numScratch[:0], n, 'g', -1, 64))
}

func (r *RedisPacket) writeInt64(n int64) {
	r.writeBytes(strconv.AppendInt(r.numScratch[:0], n, 10))
}

func (r *RedisPacket) Protocol() string {
	return r.rawContent.String()
}

func (r *RedisPacket) Bytes() []byte {
	return r.rawContent.Bytes()
}
