package process

import "time"

type darwinProcess struct {
}

func (*darwinProcess) Pid() int {
	panic("implement me")
}

func (*darwinProcess) PPid() int {
	panic("implement me")
}

func (*darwinProcess) Binary() string {
	panic("implement me")
}

func (*darwinProcess) Args() []string {
	panic("implement me")
}

func (*darwinProcess) Executable() string {
	panic("implement me")
}

func (*darwinProcess) MemorySize() uint64 {
	panic("implement me")
}

func (*darwinProcess) MemoryResident() uint64 {
	panic("implement me")
}

func (*darwinProcess) MemoryShared() uint64 {
	panic("implement me")
}

func (*darwinProcess) Refresh() error {
	panic("implement me")
}

func (*darwinProcess) UserTime() time.Duration {
	panic("implement me")
}

func (*darwinProcess) SystemTime() time.Duration {
	panic("implement me")
}

func processes() (map[int]Process, error) {
	return make(map[int]Process, 0), nil
}

func find(pid int) (Process, error) {
	p := darwinProcess{}
	return &p, nil
}

func findByExecutable(path string) (map[int]Process, error) {
	return make(map[int]Process, 0), nil
}
