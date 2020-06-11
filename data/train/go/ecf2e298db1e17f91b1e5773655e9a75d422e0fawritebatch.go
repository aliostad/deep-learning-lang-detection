package gonemo

// #include "nemo_c.h"
// #include <stdlib.h>
import "C"

// WriteBatch object of batch write
type WriteBatch struct {
	c *C.nemo_WriteBatch_t
}

// NewWriteBatch Create new writeBatch object
func NewWriteBatch() *WriteBatch {
	var wb WriteBatch
	wb.c = C.createWriteBatch()
	return &wb
}

// WriteBatchPut Append "put ops" into writeBatch object
func (wb *WriteBatch) WriteBatchPut(key []byte, value []byte) {

	C.rocksdb_WriteBatch_Put(wb.c, goByte2char(key), C.size_t(len(key)), goByte2char(value), C.size_t(len(value)))
}

// WriteBatchDel Append "del ops" into writeBatch object
func (wb *WriteBatch) WriteBatchDel(key []byte) {

	C.rocksdb_WriteBatch_Del(wb.c, goByte2char(key), C.size_t(len(key)))
}
