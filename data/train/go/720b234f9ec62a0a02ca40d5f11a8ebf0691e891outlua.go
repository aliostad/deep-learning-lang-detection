package main

import (
	"fmt"
	"os"
)

type LuaOut struct {
	f *os.File
}

func (p *LuaOut) createFile() {
	f, err := os.OpenFile("sim_h.lua", os.O_RDWR|os.O_CREATE, os.ModePerm)
	if err != nil {
		panic(fmt.Sprintf("open file error. %v\n", err))
	}
	err = f.Truncate(0)
	if err != nil {
		panic(fmt.Sprintf("Truncate file error. %v\n", err))
	}
	p.f = f
}
func (p *LuaOut) close() {
	if p.f != nil {
		p.f.Close()
		p.f = nil
	}
}

func (p *LuaOut) begin() {
	p.f.WriteString("if g_sim ~= nil then return end\n")
	p.f.WriteString("\tg_Sim = \n")
	p.f.WriteString("\t{\n")
}
func (p *LuaOut) end() {
	p.f.WriteString("\t}\n")
	//p.f.WriteString("end\n")
}
func (p *LuaOut) beginLevel(level int) {
	p.f.WriteString("\t\t{\n")
	p.f.WriteString(fmt.Sprintf("\t\t\tlevel = %v,\n", level))
	p.f.WriteString("\t\t\tcurvs = \n")
	p.f.WriteString("\t\t\t{\n")
}
func (p *LuaOut) endLevel() {
	p.f.WriteString("\t\t\t},\n")
	p.f.WriteString("\t\t},\n")
}

func (p *LuaOut) append(idx int, lc *LevelCurv) {
	p.f.WriteString("\t\t\t\t{\n")
	p.f.WriteString(fmt.Sprintf("\t\t\t\t\tlineid = %v,\n", idx))
	p.f.WriteString("\t\t\t\t\tline = {\n")
	out := "\t\t\t\t\t\t"
	for i := 1; i < *jushu+1; i++ {
		p := lc.points[i]
		s := fmt.Sprintf("{%v,%v},", p.min, p.max)
		out = out + s
	}
	out += "\n"
	p.f.WriteString(out)
	p.f.WriteString("\t\t\t\t\t},\n")
	p.f.WriteString("\t\t\t\t},\n")
}
