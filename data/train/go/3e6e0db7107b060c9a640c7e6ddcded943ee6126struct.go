package golang

import (
	"fmt"
	"strconv"

	"github.com/ncbray/compilerutil/writer"
	"github.com/ncbray/rommy/runtime"
)

func schemaFieldType(t runtime.TypeSchema) string {
	switch t := t.(type) {
	case *runtime.IntegerSchema:
		return fmt.Sprintf("&runtime.IntegerSchema{Bits: %d, Unsigned: %v}", t.Bits, t.Unsigned)
	case *runtime.FloatSchema:
		return fmt.Sprintf("&runtime.FloatSchema{Bits: %d}", t.Bits)
	case *runtime.StringSchema:
		return "&runtime.StringSchema{}"
	case *runtime.BooleanSchema:
		return "&runtime.BooleanSchema{}"
	case *runtime.StructSchema:
		return structSchemaName(t)
	case *runtime.ListSchema:
		// Precedence issues with "&" operator.
		return "(" + schemaFieldType(t.Element) + ").List()"
	default:
		panic(t)
	}
}

func generateStructDecls(r *runtime.RegionSchema, s *runtime.StructSchema, out *writer.TabbedWriter) {
	out.EndOfLine()
	out.WriteString("type ")
	out.WriteString(s.Name)
	out.WriteString(" struct {")
	out.EndOfLine()
	out.Indent()
	out.WriteLine("PoolIndex int")
	for _, f := range s.Fields {
		out.WriteString(fieldName(f))
		out.WriteString(" ")
		out.WriteString(goTypeRef(f.Type))
		out.EndOfLine()
	}
	out.Dedent()
	out.WriteLine("}")

	// Global variable holding the schema.
	schemaName := structSchemaName(s)

	out.EndOfLine()
	out.WriteString("func (s *")
	out.WriteString(s.Name)
	out.WriteString(") Schema() *runtime.StructSchema {")
	out.EndOfLine()
	out.Indent()
	out.WriteString("return ")
	out.WriteString(schemaName)
	out.EndOfLine()
	out.Dedent()
	out.WriteLine("}")

	out.EndOfLine()
	out.WriteString("var ")
	out.WriteString(schemaName)
	out.WriteString(" = &runtime.StructSchema{")
	out.WriteString("Name: ")
	out.WriteString(strconv.Quote(s.Name))
	out.WriteString(", GoType: (*")
	out.WriteString(s.Name)
	out.WriteString(")(nil)}")
	out.EndOfLine()
}

func generateRegionDecls(r *runtime.RegionSchema, out *writer.TabbedWriter) {
	for _, s := range r.Structs {
		generateStructDecls(r, s, out)
	}

	structName := regionStructName(r)
	schemaName := regionSchemaName(r)

	// Type decl
	out.EndOfLine()
	out.WriteString("type ")
	out.WriteString(structName)
	out.WriteString(" struct {")
	out.EndOfLine()
	out.Indent()
	for _, s := range r.Structs {
		out.WriteString(poolField(r, s))
		out.WriteString(" ")
		out.WriteString(goTypeRef(s.List()))
		out.EndOfLine()
	}
	out.Dedent()
	out.WriteLine("}")

	// Constructor.=
	out.EndOfLine()
	out.WriteString("func Create")
	out.WriteString(structName)
	out.WriteString("() *")
	out.WriteString(structName)
	out.WriteString(" {")
	out.EndOfLine()
	out.Indent()
	out.WriteString("return &")
	out.WriteString(structName)
	out.WriteString("{}")
	out.EndOfLine()
	out.Dedent()
	out.WriteLine("}")

	// Schema
	out.EndOfLine()
	out.WriteString("var ")
	out.WriteString(schemaName)
	out.WriteString(" = &runtime.RegionSchema{")
	out.WriteString("Name: ")
	out.WriteString(strconv.Quote(r.Name))
	out.WriteString(", GoType: (*")
	out.WriteString(structName)
	out.WriteString(")(nil)}")
	out.EndOfLine()

	// Schema getter
	out.EndOfLine()
	out.WriteString("func (r *")
	out.WriteString(structName)
	out.WriteString(") Schema() *runtime.RegionSchema {")
	out.EndOfLine()
	out.Indent()
	out.WriteString("return ")
	out.WriteString(schemaName)
	out.EndOfLine()
	out.Dedent()
	out.WriteLine("}")

	// Concrete child allocators
	for _, s := range r.Structs {
		out.EndOfLine()
		out.WriteString("func (r *")
		out.WriteString(structName)
		out.WriteString(") Allocate")
		out.WriteString(s.Name)
		out.WriteString("() *")
		out.WriteString(s.Name)
		out.WriteString(" {")
		out.EndOfLine()
		out.Indent()
		out.WriteString("o := &")
		out.WriteString(s.Name)
		out.WriteString("{}")
		out.EndOfLine()

		f := poolField(r, s)

		out.WriteString("o.PoolIndex = len(r.")
		out.WriteString(f)
		out.WriteString(")")
		out.EndOfLine()

		out.WriteString("r.")
		out.WriteString(f)
		out.WriteString(" = append(r.")
		out.WriteString(f)
		out.WriteString(", o)")
		out.EndOfLine()

		out.WriteLine("return o")
		out.Dedent()
		out.WriteLine("}")
	}

	// Generic child allocator
	out.EndOfLine()
	out.WriteString("func (r *")
	out.WriteString(structName)
	out.WriteString(") Allocate(name string) interface{} {")
	out.EndOfLine()
	out.Indent()
	out.WriteLine("switch name {")
	for _, s := range r.Structs {
		out.WriteString("case ")
		out.WriteString(strconv.Quote(s.Name))
		out.WriteString(":")
		out.EndOfLine()
		out.Indent()
		out.WriteString("return r.Allocate")
		out.WriteString(s.Name)
		out.WriteString("()")
		out.EndOfLine()
		out.Dedent()
	}
	out.WriteLine("}")
	out.WriteLine("return nil")
	out.Dedent()
	out.WriteLine("}")
}

func generateStructInit(r *runtime.RegionSchema, s *runtime.StructSchema, out *writer.TabbedWriter) {
	schemaName := structSchemaName(s)

	out.EndOfLine()
	out.WriteString(schemaName)
	out.WriteString(".Fields = []*runtime.FieldSchema{")
	out.EndOfLine()

	out.Indent()
	for _, f := range s.Fields {
		out.WriteString("{Name: ")
		out.WriteString(strconv.Quote(f.Name))
		out.WriteString(", Type: ")
		out.WriteString(schemaFieldType(f.Type))
		out.WriteString("},")
		out.EndOfLine()
	}
	out.Dedent()
	out.WriteLine("}")
}

func generateRegionInit(r *runtime.RegionSchema, out *writer.TabbedWriter) {
	for _, s := range r.Structs {
		generateStructInit(r, s, out)
	}

	schemaName := regionSchemaName(r)

	out.EndOfLine()
	out.WriteString(schemaName)
	out.WriteString(".Structs = []*runtime.StructSchema{")
	out.EndOfLine()

	out.Indent()
	for _, s := range r.Structs {
		out.WriteString(structSchemaName(s))
		out.WriteString(",")
		out.EndOfLine()
	}
	out.Dedent()
	out.WriteLine("}")

	out.WriteString(schemaName)
	out.WriteString(".Init()")
	out.EndOfLine()
}

func GenerateSource(pkg string, regions []*runtime.RegionSchema, out *writer.TabbedWriter) {
	// Header
	out.WriteString("package ")
	out.WriteString(pkg)
	out.EndOfLine()
	out.EndOfLine()
	out.WriteLine("/* Generated with rommyc, do not edit by hand. */")
	out.EndOfLine()

	out.WriteLine("import (")
	out.Indent()
	out.WriteLine("\"github.com/ncbray/rommy/runtime\"")
	out.Dedent()
	out.WriteLine(")")

	for _, r := range regions {
		generateRegionDecls(r, out)
		generateRegionSerialize(r, out)
		generateRegionDeserialize(r, out)
		generateRegionCloner(r, out)
	}

	// Init
	out.EndOfLine()
	out.WriteLine("func init() {")
	out.Indent()

	for _, r := range regions {
		generateRegionInit(r, out)
	}

	out.Dedent()
	out.WriteLine("}")
}
