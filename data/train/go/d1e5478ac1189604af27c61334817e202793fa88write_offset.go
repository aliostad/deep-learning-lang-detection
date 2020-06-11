package endibuf

// Offset-base Write methods

// WriteDataFromOffset is offset-base Write method of WriteData
func (w *Writer) WriteDataFromOffset(offset int64, data interface{}) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteData(data)
	w.Seek(origin, 0)
	return
}

// WriteCStringFromOffset is offset-base Write method of WriteString
func (w *Writer) WriteCStringFromOffset(offset int64, line string) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteCString(line)
	w.Seek(origin, 0)
	return
}

// WriteStringFromOffset is offset-base Write method of WriteString
func (w *Writer) WriteStringFromOffset(offset int64, line string, delim byte) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteString(line, delim)
	w.Seek(origin, 0)
	return
}

// WriteByteFromOffset is offset-base Write method of WriteByte
func (w *Writer) WriteByteFromOffset(offset int64, data byte) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteByte(data)
	w.Seek(origin, 0)
	return
}

// WriteBytesFromOffset is offset-base Write method of WriteBytes
func (w *Writer) WriteBytesFromOffset(offset int64, data []byte) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteBytes(data)
	w.Seek(origin, 0)
	return
}

// WriteInt8FromOffset is offset-base Write method of WriteInt8
func (w *Writer) WriteInt8FromOffset(offset int64, data int8) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteInt8(data)
	w.Seek(origin, 0)
	return
}

// WriteInt16FromOffset is offset-base Write method of WriteInt16
func (w *Writer) WriteInt16FromOffset(offset int64, data int16) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteInt16(data)
	w.Seek(origin, 0)
	return
}

// WriteInt32FromOffset is offset-base Write method of WriteInt32
func (w *Writer) WriteInt32FromOffset(offset int64, data int32) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteInt32(data)
	w.Seek(origin, 0)
	return
}

// WriteInt64FromOffset is offset-base Write method of WriteInt64
func (w *Writer) WriteInt64FromOffset(offset int64, data int64) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteInt64(data)
	w.Seek(origin, 0)
	return
}

// WriteUint8FromOffset is offset-base Write method of WriteUint8
func (w *Writer) WriteUint8FromOffset(offset int64, data uint8) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteUint8(data)
	w.Seek(origin, 0)
	return
}

// WriteUint16FromOffset is offset-base Write method of WriteUint16
func (w *Writer) WriteUint16FromOffset(offset int64, data uint16) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteUint16(data)
	w.Seek(origin, 0)
	return
}

// WriteUint32FromOffset is offset-base Write method of WriteUint32
func (w *Writer) WriteUint32FromOffset(offset int64, data uint32) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteUint32(data)
	w.Seek(origin, 0)
	return
}

// WriteUint64FromOffset is offset-base Write method of WriteUint64
func (w *Writer) WriteUint64FromOffset(offset int64, data uint64) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteUint64(data)
	w.Seek(origin, 0)
	return
}

// WriteFloat32FromOffset is offset-base Write method of WriteFloat32
func (w *Writer) WriteFloat32FromOffset(offset int64, data float32) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteFloat32(data)
	w.Seek(origin, 0)
	return
}

// WriteFloat64FromOffset is offset-base Write method of WriteFloat64
func (w *Writer) WriteFloat64FromOffset(offset int64, data float64) (err error) {
	origin := w.GetOffset()
	w.Seek(offset, 0)
	err = w.WriteFloat64(data)
	w.Seek(origin, 0)
	return
}
