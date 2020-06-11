package ssa

import "github.com/MovingtoMars/nnvm/types"

type Load struct {
	NameHandler
	ReferenceHandler
	BlockHandler

	location Value
}

func newLoad(location Value) *Load {
	return &Load{
		location: location,
	}
}

func (v *Load) operands() []*Value {
	return []*Value{&v.location}
}

func (v Load) String() string {
	return "load " + ValueString(v.location)
}

func (v Load) Type() types.Type {
	ptr, ok := v.location.Type().(*types.Pointer)
	if !ok {
		return types.NewVoid()
	}

	return ptr.Element()
}

func (_ Load) IsTerminating() bool {
	return false
}
