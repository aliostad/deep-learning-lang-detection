package safepackets

type ReadWriteMode string

const (
	NetAscii ReadWriteMode = "netascii"
	Octet    ReadWriteMode = "octet"
)

type SafeReadRequest struct {
	Filename string
	Mode     ReadWriteMode
}

type SafeWriteRequest struct {
	Filename string
	Mode     ReadWriteMode
}

func NewSafeReadRequest(filename string, mode ReadWriteMode) *SafeReadRequest {
	return &SafeReadRequest{filename, mode}
}

func NewSafeWriteRequest(filename string, mode ReadWriteMode) *SafeWriteRequest {
	return &SafeWriteRequest{filename, mode}
}
