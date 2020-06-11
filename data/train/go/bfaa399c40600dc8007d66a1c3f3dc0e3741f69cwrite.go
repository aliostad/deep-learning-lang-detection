package programs

import (
	"strings"
)

type write struct {
	programStruct
}

func (p *write) Run() {
	defer p.out.Flush()
	if len(p.args) < 2 {
		p.out.WriteString(p.args[0] + ": No file specified\n")
		return
	} else if len(p.args) < 3 {
		p.out.WriteString(p.args[0] + ": Nothing text given to write\n")
		return
	}

	fileName := p.args[1]
	contents := strings.Join(p.args[2:], " ")

	err := p.env.Filesystem.Write(fileName, contents)
	if err != nil {
		p.out.WriteString(p.args[0] + ": " + err.Error() + "\n")
	}
}
