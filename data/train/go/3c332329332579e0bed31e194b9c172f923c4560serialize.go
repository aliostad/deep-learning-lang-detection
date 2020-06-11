package golang

import (
	"strconv"

	"github.com/ncbray/compilerutil/names"
	"github.com/ncbray/compilerutil/writer"
	"github.com/ncbray/rommy/runtime"
)

func abortSerializeOnError(out *writer.TabbedWriter) {
	out.WriteLine("if err != nil {")
	out.Indent()
	out.WriteLine("return nil, err")
	out.Dedent()
	out.WriteLine("}")
}

func serialize(path string, level int, r *runtime.RegionSchema, t runtime.TypeSchema, out *writer.TabbedWriter) {
	switch t := t.(type) {
	case *runtime.IntegerSchema:
		out.WriteString("s.Write")
		out.WriteString(names.Capitalize(t.CanonicalName()))
		out.WriteString("(")
		out.WriteString(path)
		out.WriteString(")")
		out.EndOfLine()
	case *runtime.FloatSchema:
		out.WriteString("s.Write")
		out.WriteString(names.Capitalize(t.CanonicalName()))
		out.WriteString("(")
		out.WriteString(path)
		out.WriteString(")")
		out.EndOfLine()
	case *runtime.StringSchema:
		out.WriteString("s.WriteString(")
		out.WriteString(path)
		out.WriteString(")")
		out.EndOfLine()
	case *runtime.BooleanSchema:
		out.WriteString("s.WriteBool(")
		out.WriteString(path)
		out.WriteString(")")
		out.EndOfLine()
	case *runtime.StructSchema:
		out.WriteString("err = s.WriteIndex(")
		out.WriteString(path)
		out.WriteString(".PoolIndex, len(r.")
		out.WriteString(poolField(r, t))
		out.WriteString("))")
		out.EndOfLine()
		abortSerializeOnError(out)
	case *runtime.ListSchema:
		out.WriteString("err = s.WriteCount(len(")
		out.WriteString(path)
		out.WriteString("))")
		out.EndOfLine()
		abortSerializeOnError(out)

		child_path := "o" + strconv.Itoa(level)
		out.WriteString("for _, ")
		out.WriteString(child_path)
		out.WriteString(" := range ")
		out.WriteString(path)
		out.WriteString(" {")
		out.EndOfLine()
		out.Indent()
		serialize(child_path, level+1, r, t.Element, out)
		out.Dedent()
		out.WriteLine("}")
	default:
		panic(t)
	}
}

func generateRegionSerialize(r *runtime.RegionSchema, out *writer.TabbedWriter) {
	structName := regionStructName(r)

	// Serializer
	out.EndOfLine()
	out.WriteString("func (r *")
	out.WriteString(structName)
	out.WriteString(") MarshalBinary() ([]byte, error) {")
	out.EndOfLine()
	out.Indent()
	out.WriteLine("s := runtime.MakeSerializer()")
	out.WriteLine("var err error")

	// indexs
	for _, s := range r.Structs {
		f := poolField(r, s)
		out.WriteString("err = s.WriteCount(len(r.")
		out.WriteString(f)
		out.WriteString("))")
		out.EndOfLine()
		abortSerializeOnError(out)
	}
	// Values
	for _, s := range r.Structs {
		f := poolField(r, s)
		out.WriteString("for _, o := range r.")
		out.WriteString(f)
		out.WriteString(" {")
		out.EndOfLine()
		out.Indent()

		for _, f := range s.Fields {
			path := "o." + fieldName(f)
			serialize(path, 0, r, f.Type, out)
		}
		out.Dedent()
		out.WriteLine("}")
	}
	out.WriteLine("return s.Data(), nil")
	out.Dedent()
	out.WriteLine("}")
}
