package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"os"
	"path"
	"strconv"
	"strings"
	"unicode"
	"unicode/utf8"
)

func WriteGo(pkgname string, messages []Message, messageMap map[string]Message, enums []Enum, enumMap map[string]Enum) {
	gobuf := &bytes.Buffer{}
	gopath := os.Getenv("GOPATH")
	f, err := ioutil.ReadFile(path.Join(gopath, "src/github.com/lologarithm/netgen/lib/go/frame.go.tmpl"))
	if err != nil {
		fmt.Printf("Error: %s\n", err)
		panic("failed to load frame helper.")
	}
	gobuf.WriteString(fmt.Sprintf("package %s\n\nimport (\n\t\"math\"\n)\n\n", pkgname))
	gobuf.WriteString("// Make sure math import is always valid\nvar _ = math.Pi\n\n")
	gobuf.Write(f)
	gobuf.WriteString("\n")
	// 1. List type values!
	gobuf.WriteString("const (\n\tUnknownMsgType MessageType = iota\n\tAckMsgType\n")
	for _, t := range messages {
		gobuf.WriteString("\t")
		gobuf.WriteString(t.Name)
		gobuf.WriteString("MsgType\n")
	}
	gobuf.WriteString(")\n\n")

	// 1.a. Parent parser function
	gobuf.WriteString("// ParseNetMessage accepts input of raw bytes from a NetMessage. Parses and returns a Net message.\n")
	gobuf.WriteString("func ParseNetMessage(packet Packet, content []byte) Net {\n")
	gobuf.WriteString("\tswitch packet.Frame.MsgType {\n")
	for _, t := range messages {
		gobuf.WriteString("\tcase ")
		gobuf.WriteString(t.Name)
		gobuf.WriteString("MsgType:\n")
		gobuf.WriteString("\t\tmsg := ")
		gobuf.WriteString(t.Name)
		gobuf.WriteString("Deserialize(content)\n\t\treturn &msg\n")
	}
	gobuf.WriteString("\tdefault:\n\t\treturn nil\n\t}\n}\n\n")

	for _, enum := range enums {
		gobuf.WriteString("type ")
		gobuf.WriteString(enum.Name)
		gobuf.WriteString(" int\n\nconst(")
		for _, ev := range enum.Values {
			gobuf.WriteString(fmt.Sprintf("\n\t%s\t %s = %d", ev.Name, enum.Name, ev.Value))
		}
		gobuf.WriteString("\n)\n\n")
	}

	// 2. Generate go classes
	for _, msg := range messages {
		gobuf.WriteString("type ")
		gobuf.WriteString(msg.Name)
		gobuf.WriteString(" struct {")
		for _, f := range msg.Fields {
			gobuf.WriteString("\n\t")
			gobuf.WriteString(f.Name)
			gobuf.WriteString(" ")
			if f.Array {
				gobuf.WriteString("[]")
			}
			if f.Pointer {
				gobuf.WriteString("*")
			}
			if f.Type == DynamicType {
				gobuf.WriteString("Net")
				gobuf.WriteString("\n\t")
				gobuf.WriteString(lowerFirst(f.Name))
				gobuf.WriteString("Type ")
				gobuf.WriteString("MessageType")
			} else {
				gobuf.WriteString(f.Type)
			}

		}
		gobuf.WriteString(fmt.Sprintf("\n}\n\nfunc (m %s) Serialize(buffer []byte) {\n", msg.Name))
		if len(msg.Fields) > 0 {
			gobuf.WriteString("\tidx := 0\n")
		}
		for _, f := range msg.Fields {
			WriteGoSerialize(f, 1, gobuf, messageMap, enumMap)
		}
		gobuf.WriteString("}\n")
		gobuf.WriteString(fmt.Sprintf("\nfunc %sDeserialize(buffer []byte) (m %s) {\n", msg.Name, msg.Name))
		if len(msg.Fields) > 0 {
			gobuf.WriteString("\tidx := 0\n")
		}
		for _, f := range msg.Fields {
			WriteGoDeserial(f, 1, gobuf, messageMap, enumMap)
		}
		gobuf.WriteString("\treturn m\n}\n")
		gobuf.WriteString(fmt.Sprintf("\nfunc (m %s) Len() int {\n\tmylen := 0\n", msg.Name))
		for _, f := range msg.Fields {
			WriteGoLen(f, 1, gobuf, messageMap, enumMap)
		}
		gobuf.WriteString("\treturn mylen\n}\n\n")

		gobuf.WriteString("func (m ")
		gobuf.WriteString(msg.Name)
		gobuf.WriteString(") MsgType() MessageType {\n\treturn ")
		gobuf.WriteString(msg.Name)
		gobuf.WriteString("MsgType\n}\n\n")

	}
	os.MkdirAll(pkgname, 0777)
	ioutil.WriteFile(path.Join(pkgname, pkgname+".go"), gobuf.Bytes(), 0666)
}

func WriteGoLen(f MessageField, scopeDepth int, buf *bytes.Buffer, messages map[string]Message, enums map[string]Enum) {
	for i := 0; i < scopeDepth; i++ {
		buf.WriteString("\t")
	}
	if f.Array && f.Type != ByteType { // array handling for non-byte type
		buf.WriteString("mylen += 4\n\t")
		fn := "v" + strconv.Itoa(scopeDepth+1)
		buf.WriteString("for _, ")
		buf.WriteString(fn)
		buf.WriteString(" := range ")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(" {\n")
		buf.WriteString("\t_ = ")
		buf.WriteString(fn)
		buf.WriteString("\n")
		WriteGoLen(MessageField{Name: fn, Type: f.Type, Order: f.Order, Pointer: f.Pointer}, scopeDepth+1, buf, messages, enums)
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}
		buf.WriteString("}\n")
		return
	}
	switch f.Type {
	case ByteType:
		if f.Array {
			buf.WriteString("mylen += 4 + len(")
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(")")
		} else {
			buf.WriteString("mylen += 1")
		}
	case Uint16Type, Int16Type:
		buf.WriteString("mylen += 2")
	case Uint32Type, Int32Type:
		buf.WriteString("mylen += 4")
	case Uint64Type, Int64Type, Float64Type:
		buf.WriteString("mylen += 8")
	case StringType:
		buf.WriteString("mylen += 4 + len(")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(")")
	case DynamicType:
		buf.WriteString("mylen += 2\n\t")
		buf.WriteString("mylen += ")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(".Len()")
	default:
		if _, ok := messages[f.Type]; ok {
			buf.WriteString("mylen += ")
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(".Len()")
		} else if _, ok := enums[f.Type]; ok {
			buf.WriteString("mylen += 4")
		}
	}
	buf.WriteString("\n")
}

func writeArrayLen(f MessageField, scopeDepth int, buf *bytes.Buffer) {
	buf.WriteString("LittleEndian.PutUint32(buffer[idx:], uint32(len(")
	if scopeDepth == 1 {
		buf.WriteString("m.")
	}
	buf.WriteString(f.Name)
	buf.WriteString(")))\n")
	for i := 0; i < scopeDepth; i++ {
		buf.WriteString("\t")
	}
	buf.WriteString("idx += 4\n")
	for i := 0; i < scopeDepth; i++ {
		buf.WriteString("\t")
	}
}

func writeIdxInc(f MessageField, scopeDepth int, buf *bytes.Buffer) {
	buf.WriteString("\n")
	for i := 0; i < scopeDepth; i++ {
		buf.WriteString("\t")
	}
	buf.WriteString("idx+=")
	switch f.Type {
	case ByteType:
		if f.Array {
			buf.WriteString("len(")
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(")")
		} else {
			buf.WriteString("1")
		}
	case Int16Type, Uint16Type:
		buf.WriteString("2")
	case Int32Type, Uint32Type:
		buf.WriteString("4")
	case Int64Type, Uint64Type, Float64Type:
		buf.WriteString("8")
	default:
		// Array probably
		if f.Type == StringType || f.Array {
			buf.WriteString("len(")
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(")")
		} else {
			fmt.Printf("Failed to find type for '%s' to write idx incrementer for.", f.Type)
			panic("unknown type")
		}
	}
	buf.WriteString("\n")
}

func WriteGoSerialize(f MessageField, scopeDepth int, buf *bytes.Buffer, messages map[string]Message, enums map[string]Enum) {
	for i := 0; i < scopeDepth; i++ {
		buf.WriteString("\t")
	}

	if f.Array && f.Type != ByteType { // Specially handle byte array type.
		// Array!
		writeArrayLen(f, scopeDepth, buf)
		fn := "v" + strconv.Itoa(scopeDepth+1)
		buf.WriteString("for _, ")
		buf.WriteString(fn)
		buf.WriteString(" := range ")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(" {\n")
		WriteGoSerialize(MessageField{Name: fn, Type: f.Type, Order: f.Order, Pointer: f.Pointer}, scopeDepth+1, buf, messages, enums)
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}
		buf.WriteString("}\n")
		return
	}

	switch f.Type {
	case ByteType:
		if f.Array {
			// Faster handler for byte arrays
			writeArrayLen(f, scopeDepth, buf)
			buf.WriteString("copy(buffer[idx:], ")
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(")")
			writeIdxInc(f, scopeDepth, buf)
		} else {
			// Single byte
			buf.WriteString("buffer[idx] = ")
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			writeIdxInc(f, scopeDepth, buf)
		}
	case Int16Type, Uint16Type:
		buf.WriteString("LittleEndian.PutUint16(buffer[idx:], uint16(")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString("))")
		writeIdxInc(f, scopeDepth, buf)
	case Int32Type, Uint32Type:
		buf.WriteString("LittleEndian.PutUint32(buffer[idx:], uint32(")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString("))")
		writeIdxInc(f, scopeDepth, buf)
	case Int64Type, Uint64Type:
		buf.WriteString("LittleEndian.PutUint64(buffer[idx:], uint64(")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString("))")
		writeIdxInc(f, scopeDepth, buf)
	case Float64Type:
		buf.WriteString("LittleEndian.PutUint64(buffer[idx:], math.Float64bits(")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString("))")
		writeIdxInc(f, scopeDepth, buf)
	case StringType:
		writeArrayLen(f, scopeDepth, buf)
		buf.WriteString("copy(buffer[idx:], []byte(")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString("))")
		writeIdxInc(f, scopeDepth, buf)
	case DynamicType:
		// Custom message deserial here.
		buf.WriteString("LittleEndian.PutUint16(buffer[idx:], uint16(")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(".MsgType()))")
		buf.WriteString("\n")
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}
		buf.WriteString("idx+=2")
		buf.WriteString("\n")
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}

		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(".Serialize(buffer[idx:])\n")
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}
		buf.WriteString("idx+=")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(".Len()\n")
	default:
		if _, ok := messages[f.Type]; ok {
			// Custom message deserial here.
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(".Serialize(buffer[idx:])\n")
			for i := 0; i < scopeDepth; i++ {
				buf.WriteString("\t")
			}
			buf.WriteString("idx+=")
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(".Len()\n")
		} else if _, ok := enums[f.Type]; ok {
			buf.WriteString("LittleEndian.PutUint32(buffer[idx:], uint32(")
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString("))")
			buf.WriteString("\n")
			for i := 0; i < scopeDepth; i++ {
				buf.WriteString("\t")
			}
			buf.WriteString("idx+=4\n")
		}
	}
}

func writeNumericDeserialFunc(f MessageField, scopeDepth int, buf *bytes.Buffer) {
	buf.WriteString("LittleEndian.")
	switch f.Type {
	case Int16Type, Uint16Type:
		buf.WriteString("Uint16(")
	case Int32Type, Uint32Type:
		buf.WriteString("Uint32(")
	case Int64Type, Uint64Type, Float64Type:
		buf.WriteString("Uint64(")
	}
	buf.WriteString("buffer[idx:]")
	buf.WriteString(")")
}

func writeArrayLenRead(lname string, scopeDepth int, buf *bytes.Buffer) {
	buf.WriteString(lname)
	buf.WriteString(" := int(LittleEndian.Uint32(buffer[idx:]))\n")
	for i := 0; i < scopeDepth; i++ {
		buf.WriteString("\t")
	}
	buf.WriteString("idx += 4\n")
	for i := 0; i < scopeDepth; i++ {
		buf.WriteString("\t")
	}
}

func WriteGoDeserial(f MessageField, scopeDepth int, buf *bytes.Buffer, messages map[string]Message, enums map[string]Enum) {
	for i := 0; i < scopeDepth; i++ {
		buf.WriteString("\t")
	}
	if f.Array && f.Type != ByteType { // handle byte array specially
		// Get len of array
		lname := "l" + strconv.Itoa(f.Order) + "_" + strconv.Itoa(scopeDepth)
		writeArrayLenRead(lname, scopeDepth, buf)

		// 	// Create array variable
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(" = make([]")
		if f.Pointer {
			buf.WriteString("*")
		}
		buf.WriteString(f.Type)
		buf.WriteString(", ")
		buf.WriteString(lname)
		buf.WriteString(")\n")
		//
		// Read each var into the array in loop
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}
		buf.WriteString("for i := 0; i < int(")
		buf.WriteString(lname)
		buf.WriteString("); i++ {\n")
		fn := ""
		if scopeDepth == 1 {
			fn += "m."
		}
		fn += f.Name + "[i]"
		WriteGoDeserial(MessageField{Name: fn, Type: f.Type, Pointer: f.Pointer}, scopeDepth+1, buf, messages, enums)
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}
		buf.WriteString("}\n")
		return
	}
	switch f.Type {
	case ByteType:
		if f.Array {
			lname := "l" + strconv.Itoa(f.Order) + "_" + strconv.Itoa(scopeDepth)
			writeArrayLenRead(lname, scopeDepth, buf)

			dest := ""
			if scopeDepth == 1 {
				dest = "m."
			}
			dest += f.Name
			buf.WriteString(dest)
			buf.WriteString(" = make([]byte, ")
			buf.WriteString(lname)
			buf.WriteString(")\n")
			for i := 0; i < scopeDepth; i++ {
				buf.WriteString("\t")
			}
			buf.WriteString(fmt.Sprintf("copy(%s, buffer[idx:idx+%s])\n", dest, lname))
		} else {
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(" = buffer[idx]\n")
			writeIdxInc(f, scopeDepth, buf)
		}
	case Int16Type, Int32Type, Int64Type, Uint16Type, Uint32Type, Uint64Type, Float64Type:
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(" = ")
		switch f.Type {
		case Int16Type, Int32Type, Int64Type:
			buf.WriteString(f.Type)
			buf.WriteString("(")
		case Float64Type:
			buf.WriteString("math.Float64frombits(")
		}
		writeNumericDeserialFunc(f, scopeDepth, buf)
		if f.Type[0] == 'i' || f.Type[0] == 'f' {
			buf.WriteString(")")
		}
		writeIdxInc(f, scopeDepth, buf)
	case StringType:
		// Get length of string first
		lname := "l" + strconv.Itoa(f.Order) + "_" + strconv.Itoa(scopeDepth)
		writeArrayLenRead(lname, scopeDepth, buf)
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(" = string(buffer[idx:idx+")
		buf.WriteString(lname)
		buf.WriteString("])")
		writeIdxInc(f, scopeDepth, buf)
	case DynamicType:
		pre := ""
		if scopeDepth == 1 {
			pre = "m."
		}
		mt := fmt.Sprintf("%s%sType", pre, lowerFirst(f.Name))

		buf.WriteString(mt)
		buf.WriteString(" = MessageType(LittleEndian.Uint16(buffer[idx:]))\n\t")
		buf.WriteString("idx+=2\n\t")

		//ParseNetMessage
		buf.WriteString(fmt.Sprintf("p := Packet{Frame: Frame{MsgType: %s}}\n", mt))
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(" = ParseNetMessage(p, buffer[idx:])\n")
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}

		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}
		buf.WriteString("idx+=")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(".Len()\n")

	default:
		if _, ok := messages[f.Type]; ok {
			// 	// Custom message deserial here.
			if f.Pointer {
				subName := "sub" + f.Name
				if strings.Contains(f.Name, "[") {
					subName = "subi"
				}
				buf.WriteString("var ")
				buf.WriteString(subName)
				buf.WriteString(" = ")
				buf.WriteString(f.Type)
				buf.WriteString("Deserialize(buffer[idx:])\n")
				for i := 0; i < scopeDepth; i++ {
					buf.WriteString("\t")
				}
				if scopeDepth == 1 {
					buf.WriteString("m.")
				}
				buf.WriteString(f.Name)
				buf.WriteString(" = &")
				buf.WriteString(subName)
				buf.WriteString("\n")
			} else {
				if scopeDepth == 1 {
					buf.WriteString("m.")
				}
				buf.WriteString(f.Name)
				buf.WriteString(" = ")
				buf.WriteString(f.Type[0:])
				buf.WriteString("Deserialize(buffer[idx:])\n")
			}
			for i := 0; i < scopeDepth; i++ {
				buf.WriteString("\t")
			}
			buf.WriteString("idx+=")
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(".Len()\n")
		} else if _, ok := enums[f.Type]; ok {
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(" = ")
			buf.WriteString(f.Type)
			buf.WriteString("(")
			buf.WriteString("LittleEndian.")
			buf.WriteString("Uint32(")
			buf.WriteString("buffer[idx:]")
			buf.WriteString("))")
			buf.WriteString("\n")
			for i := 0; i < scopeDepth; i++ {
				buf.WriteString("\t")
			}
			buf.WriteString("idx+=4\n")
		}
	}

}

func lowerFirst(s string) string {
	if s == "" {
		return ""
	}
	r, n := utf8.DecodeRuneInString(s)
	return string(unicode.ToLower(r)) + s[n:]
}
