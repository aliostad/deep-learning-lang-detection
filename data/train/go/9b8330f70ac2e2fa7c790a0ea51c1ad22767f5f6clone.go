package golang

import (
	"strconv"

	"github.com/ncbray/compilerutil/writer"
	"github.com/ncbray/rommy/runtime"
)

func generateValueClone(src_path string, dst_path string, level int, t runtime.TypeSchema, r *runtime.RegionSchema, out *writer.TabbedWriter) {
	switch t := t.(type) {
	case *runtime.IntegerSchema, *runtime.FloatSchema, *runtime.StringSchema, *runtime.BooleanSchema:
		out.WriteString(dst_path)
		out.WriteString(" = ")
		out.WriteString(src_path)
		out.EndOfLine()
	case *runtime.StructSchema:
		out.WriteString(dst_path)
		out.WriteString(" = c.Clone")
		out.WriteString(t.Name)
		out.WriteString("(")
		out.WriteString(src_path)
		out.WriteString(")")
		out.EndOfLine()
	case *runtime.ListSchema:
		out.WriteString(dst_path)
		out.WriteString(" = make(")
		out.WriteString(goTypeRef(t))
		out.WriteString(", len(")
		out.WriteString(src_path)
		out.WriteString("))")
		out.EndOfLine()

		child_index := "i" + strconv.Itoa(level)
		out.WriteLine("for " + child_index + ", _ := range " + src_path + " {")
		out.Indent()
		index_op := "[" + child_index + "]"
		generateValueClone(src_path+index_op, dst_path+index_op, level+1, t.Element, r, out)
		out.Dedent()
		out.WriteLine("}")
		// Copy
	default:
		panic(t)
	}
}

func generateRegionCloner(r *runtime.RegionSchema, out *writer.TabbedWriter) {
	structName := regionStructName(r)
	clonerName := regionClonerName(r)

	out.EndOfLine()
	out.WriteString("type ")
	out.WriteString(clonerName)
	out.WriteString(" struct {")
	out.EndOfLine()
	out.Indent()

	out.WriteString("src *")
	out.WriteString(structName)
	out.EndOfLine()

	out.WriteString("dst *")
	out.WriteString(structName)
	out.EndOfLine()

	for _, s := range r.Structs {
		f := mapingField(r, s)
		out.WriteString(f)
		out.WriteString(" ")
		out.WriteString(goTypeRef(s.List()))
		out.EndOfLine()
	}

	out.Dedent()
	out.WriteLine("}")

	// Constructor
	out.EndOfLine()
	out.WriteString("func Create")
	out.WriteString(clonerName)
	out.WriteString("(src *")
	out.WriteString(structName)
	out.WriteString(", dst *")
	out.WriteString(structName)
	out.WriteString(") *")
	out.WriteString(clonerName)
	out.WriteString(" {")
	out.EndOfLine()
	out.Indent()
	out.WriteString("c := &")
	out.WriteString(clonerName)
	out.WriteString("{")
	out.EndOfLine()
	out.Indent()
	out.WriteLine("src: src,")
	out.WriteLine("dst: dst,")
	for _, s := range r.Structs {
		f := mapingField(r, s)
		out.WriteString(f)
		out.WriteString(": make(")
		out.WriteString(goTypeRef(s.List()))
		out.WriteString(", len(src.")
		out.WriteString(poolField(r, s))
		out.WriteString(")),")
		out.EndOfLine()
	}
	out.Dedent()
	out.WriteLine("}")
	out.WriteLine("return c")
	out.Dedent()
	out.WriteLine("}")

	// Struct clone methods.
	for _, s := range r.Structs {
		out.EndOfLine()
		out.WriteString("func (c *")
		out.WriteString(clonerName)
		out.WriteString(") Clone")
		out.WriteString(s.Name)
		out.WriteString("(src *")
		out.WriteString(s.Name)
		out.WriteString(") *")
		out.WriteString(s.Name)
		out.WriteString(" {")
		out.EndOfLine()
		out.Indent()

		f := mapingField(r, s)
		out.WriteString("dst := c.")
		out.WriteString(f)
		out.WriteString("[src.PoolIndex]")
		out.EndOfLine()

		// Early out
		out.WriteLine("if dst != nil {")
		out.Indent()
		out.WriteLine("return dst")
		out.Dedent()
		out.WriteLine("}")

		out.WriteString("dst = c.dst.Allocate")
		out.WriteString(s.Name)
		out.WriteString("()")
		out.EndOfLine()

		out.WriteString("c.")
		out.WriteString(f)
		out.WriteString("[src.PoolIndex] = dst")
		out.EndOfLine()

		// Deep clone
		for _, f := range s.Fields {
			fn := fieldName(f)
			generateValueClone("src."+fn, "dst."+fn, 0, f.Type, r, out)
		}

		out.WriteLine("return dst")
		out.Dedent()
		out.WriteLine("}")
	}
}
