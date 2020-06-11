package stages

import (
	"io"
	"proxy/log"
	"proxy/contexts"
	"proxy/tcp"
)

// ==== WRITE - START

func write(context *contexts.ChunkContext) {
	log.LoggerFactory().Debug("Write Stage START - %s", context)
	amountToWrite := len(context.Data)
	if amountToWrite > 0 {
		writeSize, writeError := context.To.Write(context.Data)
		if writeSize > 0 {
			context.TotalWriteSize += int64(writeSize)
		}
		if writeError != nil {
			context.Err = writeError
		} else if /* allow for header size update in dual connection */ !tcp.IsDualConnection(context.To) && amountToWrite != writeSize {
			log.LoggerFactory().Debug("Write Stage ErrShortWrite - amountToWrite: %d writeSize: %d %s", amountToWrite, writeSize, context)
			context.Err = io.ErrShortWrite
		}
	}
	log.LoggerFactory().Debug("Write Stage END - %s", context)
}

// ==== WRITE - END
