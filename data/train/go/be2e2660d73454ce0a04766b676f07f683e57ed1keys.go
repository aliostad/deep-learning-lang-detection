package commands

import "time"

// WriteDel writes a DEL command to the buffer.
func (b *Buffer) WriteDel(keys ...[]byte) {
	b.WriteCommand("DEL", len(keys))
	for _, key := range keys {
		b.WriteBulkBytes(key)
	}
}

// WriteDump writes a DUMP command to the buffer.
func (b *Buffer) WriteDump(key []byte) {
	const cmd = "*2" + crlf + "$4" + crlf + "DUMP" + crlf
	b.WriteString(cmd)
	b.WriteBulkBytes(key)
}

// WriteExists writes an EXISTS command to the buffer.
func (b *Buffer) WriteExists(key []byte) {
	const cmd = "*2" + crlf + "$6" + crlf + "EXISTS" + crlf
	b.WriteString(cmd)
	b.WriteBulkBytes(key)
}

// WriteExpire writes an (P)EXPIRE command to the buffer.
func (b *Buffer) WriteExpire(key []byte, d time.Duration) {
	const (
		cmd  = "*3" + crlf + "$6" + crlf + "EXPIRE" + crlf
		pcmd = "*3" + crlf + "$7" + crlf + "PEXPIRE" + crlf
	)
	var i int
	if d%time.Second == 0 { // TODO: Add a version check here?
		b.WriteString(cmd)
		i = int(d / time.Second)
	} else {
		b.WriteString(pcmd)
		i = int(d / time.Millisecond)
	}
	b.WriteBulkBytes(key)
	b.writeInt(i, true)
}

// WriteRename writes a RENAME command to the buffer.
func (b *Buffer) WriteRename(key, newkey []byte) {
	const cmd = "*3" + crlf + "$6" + crlf + "RENAME" + crlf
	b.WriteString(cmd)
	b.WriteBulkBytes(key)
	b.WriteBulkBytes(newkey)
}

// WriteRenameNX writes a RENAMENX command to the buffer.
func (b *Buffer) WriteRenameNX(key, newkey []byte) {
	const cmd = "*3" + crlf + "$8" + crlf + "RENAMENX" + crlf
	b.WriteString(cmd)
	b.WriteBulkBytes(key)
	b.WriteBulkBytes(newkey)
}
