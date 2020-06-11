package main

import (
	"bytes"
	"encoding/binary"
	"encoding/json"
	"io"
)

type Handshake struct {
	Version uint64
	Address string
	Port    uint16
	State   uint64
}

type Status struct {
	Version     Version     `json:"version"`
	Players     Players     `json:"players"`
	Description Description `json:"description"`
}

type Version struct {
	Name     string `json:"name"`
	Protocol int    `json:"protocol"`
}

type Players struct {
	Max    int `json:"max"`
	Online int `json:"online"`
}

type Description struct {
	Text string `json:"text"`
}

type Chat struct {
	Text string `json:"text"`
}

func ReadHandshake(r *bytes.Reader) Handshake {
	handshake := Handshake{}
	handshake.Version, _ = binary.ReadUvarint(r)
	handshake.Address = ReadString(r)
	binary.Read(r, binary.BigEndian, &handshake.Port)
	handshake.State, _ = binary.ReadUvarint(r)

	return handshake
}

func ReadVarint(r io.Reader) (uint64, error) {
	return binary.ReadUvarint(byteReader{r, make([]byte, 1)})
}

func ReadString(r *bytes.Reader) string {
	length, _ := binary.ReadUvarint(r)
	if length < 1 {
		return ""
	} else {
		buf := make([]byte, length)
		r.Read(buf)

		return string(buf)
	}
}

func WriteStatus(w io.Writer, status Status) {
	b := &bytes.Buffer{}

	WriteVarint(b, 0x00)
	WriteJSON(b, status)

	WriteVarint(w, uint64(b.Len()))
	w.Write(b.Bytes())
}

func WriteLoginSuccess(w io.Writer, uuid, username string) {
	b := &bytes.Buffer{}

	WriteVarint(b, 0x02)
	WriteString(b, uuid)
	WriteString(b, username)

	WriteVarint(w, uint64(b.Len()))
	w.Write(b.Bytes())
}

func WriteJoinGame(w io.Writer) {
	b := &bytes.Buffer{}

	b.WriteByte(0)

	WriteVarint(b, 0x01)
	binary.Write(b, binary.BigEndian, int32(1337))
	b.WriteByte(0)
	binary.Write(b, binary.BigEndian, int8(0))
	b.WriteByte(2)
	b.WriteByte(16)
	WriteString(b, "default")
	b.WriteByte(0)

	WriteVarint(w, uint64(b.Len()))
	w.Write(b.Bytes())
}

func WriteChatMessage(w io.Writer, message string) {
	b := &bytes.Buffer{}

	b.WriteByte(0)

	WriteVarint(b, 0x02)
	WriteJSON(b, Chat{message})
	b.WriteByte(0)

	WriteVarint(w, uint64(b.Len()))
	w.Write(b.Bytes())
}

func WriteTimeUpdate(w io.Writer, worldAge, timeOfDay int64) {
	b := &bytes.Buffer{}

	b.WriteByte(0)

	WriteVarint(b, 0x03)
	binary.Write(b, binary.BigEndian, worldAge)
	binary.Write(b, binary.BigEndian, timeOfDay)

	WriteVarint(w, uint64(b.Len()))
	w.Write(b.Bytes())
}

func WriteSpawnPosition(w io.Writer, x, y, z int) {
	b := &bytes.Buffer{}
	pos := uint64(((x & 0x3FFFFFF) << 38) | ((y & 0xFFF) << 26) | (z & 0x3FFFFFF))

	b.WriteByte(0)

	WriteVarint(b, 0x05)
	binary.Write(b, binary.BigEndian, pos)

	WriteVarint(w, uint64(b.Len()))
	w.Write(b.Bytes())
}

func WritePositionAndLook(w io.Writer, x, y, z float64) {
	b := &bytes.Buffer{}

	b.WriteByte(0)

	WriteVarint(b, 0x08)
	binary.Write(b, binary.BigEndian, x)
	binary.Write(b, binary.BigEndian, y)
	binary.Write(b, binary.BigEndian, z)
	binary.Write(b, binary.BigEndian, float32(0))
	binary.Write(b, binary.BigEndian, float32(0))
	b.WriteByte(0)

	WriteVarint(w, uint64(b.Len()))
	w.Write(b.Bytes())
}

func WriteSetCompression(w io.Writer, threshold uint64) {
	b := &bytes.Buffer{}

	WriteVarint(b, 0x46)
	WriteVarint(b, threshold)

	WriteVarint(w, uint64(b.Len()))
	w.Write(b.Bytes())
}

func WriteVarint(w io.Writer, i uint64) {
	buf := make([]byte, 8)
	n := binary.PutUvarint(buf, i)
	w.Write(buf[:n])
}

func WriteSignedVarint(w io.Writer, i int64) {
	buf := make([]byte, 8)
	n := binary.PutVarint(buf, i)
	w.Write(buf[:n])
}

func WriteString(w io.Writer, str string) {
	WriteVarint(w, uint64(len(str)))
	w.Write([]byte(str))
}

func WriteJSON(w io.Writer, val interface{}) {
	data, _ := json.Marshal(val)
	WriteVarint(w, uint64(len(data)))
	w.Write(data)
}

type byteReader struct {
	reader io.Reader
	buf    []byte
}

func (b byteReader) ReadByte() (byte, error) {
	_, err := b.reader.Read(b.buf)
	if err != nil {
		return 0, err
	}

	return b.buf[0], nil
}
