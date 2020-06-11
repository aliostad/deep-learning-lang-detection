package main

import (
    "bytes"
)

type Container struct {
    Imports []Import
    Regs []Reg
    Lists []List
    Root Resolver
}

type Import struct {
    Alias, Package string
}
 
type Reg struct {
    Tags []string
    Resolver Resolver
    Lazy bool
}

type Resolver struct {
    Package, Func string
    Deps []string
}

type List struct {
    Tags, ResolveTo []string
}

func (self *Container) String() string {
    var buffer bytes.Buffer

    writeImports(&buffer, self.Imports)
    writeRegs(&buffer, self.Regs)
    writeLists(&buffer, self.Lists)
    writeRoot(&buffer, self.Root)

    return buffer.String()
}

func writeImports(buffer *bytes.Buffer, imports []Import) {
    buffer.WriteString("import (\n")
    for _, imp := range imports {
        buffer.WriteRune('\t')
        buffer.WriteString(imp.Alias)
        buffer.WriteString(" \"")
        buffer.WriteString(imp.Package)
        buffer.WriteString("\"\n")
    }
    buffer.WriteString(")\n\n")
}

func writeRegs(buffer *bytes.Buffer, regs []Reg) {
    for _, reg := range regs {
        if reg.Lazy {
            buffer.WriteString("lazy")
        } else {
            buffer.WriteString("reg")
        }
        writeTags(buffer, reg.Tags)
        buffer.WriteRune(' ')
        writeResolver(buffer, reg.Resolver)
        buffer.WriteRune('\n')
    }
}

func writeTags(buffer *bytes.Buffer, tags []string) {
    for i, tag := range tags {
        if i == 0 {
            buffer.WriteRune(' ')
        } else {
            buffer.WriteRune(',')
        }
        buffer.WriteString(tag)
    }
}

func writeResolver(buffer *bytes.Buffer, resolver Resolver) {
    buffer.WriteString(resolver.Package)
    buffer.WriteRune('.')
    buffer.WriteString(resolver.Func)
    for _, dep := range resolver.Deps {
        buffer.WriteRune(' ')
        buffer.WriteString(dep)
    }
}

func writeLists(buffer *bytes.Buffer, lists []List) {
    for _, list := range lists {
        buffer.WriteString("list")
        writeTags(buffer, list.Tags)
        writeTags(buffer, list.ResolveTo)
        buffer.WriteRune('\n')
    }
}

func writeRoot(buffer *bytes.Buffer, root Resolver) {
    buffer.WriteString("root ")
    writeResolver(buffer, root)
    buffer.WriteRune('\n')
}

