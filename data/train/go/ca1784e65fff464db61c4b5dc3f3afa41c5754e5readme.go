package vmgen

import (
	"os"
	"strconv"
)

// GenerateReadMe generates a read me
func (vm *VM) GenerateReadMe(name string) {
	f, _ := os.Create(name)
	defer f.Close()
	f.WriteString("# " + vm.Name + " (" + vm.Author + ")\n")
	f.WriteString(vm.Description + "\n")

	for _, c := range vm.categories {
		f.WriteString("## " + c.name + "\n")
		f.WriteString("### " + c.description + "\n")
		f.WriteString("| " + "Opcode")
		f.WriteString("| " + "Description")
		f.WriteString("| " + "Fuel")
		f.WriteString("|\n")
		for _, v := range c.instructions {
			f.WriteString("| " + string(v.Opcode))
			f.WriteString("| " + v.description)
			f.WriteString("| " + strconv.Itoa(v.fuel))
			f.WriteString("|\n")
		}
	}
	f.Sync()
}
