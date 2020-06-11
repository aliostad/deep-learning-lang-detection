package istm

type operation struct {
	kind       int
	readValue  int
	writeValue int
}

const (
	readOperation = iota
	writeOperation
	readWriteOperation
)

func newReadTVarLog(v int) *operation {
	return &operation{
		kind:      readOperation,
		readValue: v,
	}
}

func newWriteTVarLog(v int) *operation {
	return &operation{
		kind:       writeOperation,
		writeValue: v,
	}
}

func (t *operation) read() int {
	if t.kind == readOperation {
		return t.readValue
	}

	return t.writeValue
}

func (t *operation) write(v int) {
	if t.kind == readOperation {
		t.kind = readWriteOperation
	}

	t.writeValue = v
}
