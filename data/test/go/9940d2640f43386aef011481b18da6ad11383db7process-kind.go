package nvidia

import "strings"

type ProcessKind uint8

const (
	PROCESS_KIND_UNKNOWN  ProcessKind = iota
	PROCESS_KIND_COMPUTE              // process with a compute context on a device
	PROCESS_KIND_GRAPHICS             // process with a graphics context on a device
)

func (it *ProcessKind) UnmarshalJSON(data []byte) error {
	v := strings.Replace(string(data), "\"", "", -1)
	v = strings.TrimSpace(v)
	*it = NewProcessKindFromString(v)
	return nil
}

func NewProcessKind(v string) ProcessKind { return NewProcessKindFromString(v) }
func NewProcessKindFromString(v string) ProcessKind {
	v = strings.Replace(v, "/", "", -1)
	v = strings.ToLower(v)

	switch v {
	case "c", "compute":
		return PROCESS_KIND_COMPUTE
	case "g", "graphics":
		return PROCESS_KIND_GRAPHICS
	}

	return PROCESS_KIND_UNKNOWN
}
