package main

import (
	"bytes"
	"io/ioutil"
	"strconv"
)

func WriteGo(messages []Message, messageMap map[string]Message) {
	gobuf := &bytes.Buffer{}
	gobuf.WriteString("package messages\n\nimport (\n\t\"bytes\"\n\t\"encoding/binary\"\n\t\"log\"\n)\n\n")
	// 1. List type values!
	gobuf.WriteString("type Net interface {\n\tSerialize(*bytes.Buffer)\n\tDeserialize(*bytes.Buffer)\n\tLen() int\n}\n\n")
	gobuf.WriteString("type MessageType uint16\n\n")
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
	gobuf.WriteString("\tvar msg Net\n")
	gobuf.WriteString("\tswitch packet.Frame.MsgType {\n")
	for _, t := range messages {
		gobuf.WriteString("\tcase ")
		gobuf.WriteString(t.Name)
		gobuf.WriteString("MsgType:\n")
		gobuf.WriteString("\t\tmsg = &")
		gobuf.WriteString(t.Name)
		gobuf.WriteString("{}\n")
	}
	gobuf.WriteString("\tdefault:\n\t\tlog.Printf(\"Unknown message type: %d\", packet.Frame.MsgType)\n\t\treturn nil\n\t}\n\tmsg.Deserialize(bytes.NewBuffer(content))\n\treturn msg\n}\n\n")

	// 2. Generate go classes
	for _, msg := range messages {
		gobuf.WriteString("type ")
		gobuf.WriteString(msg.Name)
		gobuf.WriteString(" struct {")
		for _, f := range msg.Fields {
			gobuf.WriteString("\n\t")
			gobuf.WriteString(f.Name)
			gobuf.WriteString(" ")
			gobuf.WriteString(f.Type)
		}
		gobuf.WriteString("\n}\n\n")
		gobuf.WriteString("func (m *")
		gobuf.WriteString(msg.Name)
		gobuf.WriteString(") Serialize(buffer *bytes.Buffer) {\n")
		for _, f := range msg.Fields {
			WriteGoSerialize(f, 1, gobuf, messageMap)
		}
		gobuf.WriteString("}\n\n")

		gobuf.WriteString("func (m *")
		gobuf.WriteString(msg.Name)
		gobuf.WriteString(") Deserialize(buffer *bytes.Buffer) {\n")
		for _, f := range msg.Fields {
			WriteGoDeserial(f, 1, gobuf, messageMap)
		}
		gobuf.WriteString("}\n\n")

		gobuf.WriteString("func (m *")
		gobuf.WriteString(msg.Name)
		gobuf.WriteString(") Len() int {\n\tmylen := 0\n")
		for _, f := range msg.Fields {
			WriteGoLen(f, 1, gobuf, messageMap)
		}
		gobuf.WriteString("\treturn mylen\n}\n\n")
	}
	ioutil.WriteFile("../server/messages/net.go", gobuf.Bytes(), 0775)
}

func WriteGoLen(f MessageField, scopeDepth int, buf *bytes.Buffer, messages map[string]Message) {
	for i := 0; i < scopeDepth; i++ {
		buf.WriteString("\t")
	}
	switch f.Type {
	case "[]byte":
		buf.WriteString("mylen += 4 + len(")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(")")
	case "byte":
		buf.WriteString("mylen += 1")
	case "uint16", "int16":
		buf.WriteString("mylen += 2")
	case "uint32", "int32":
		buf.WriteString("mylen += 4")
	case "uint64", "int64":
		buf.WriteString("mylen += 8")
	case "string":
		buf.WriteString("mylen += 4 + len(")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(")")
	default:
		if f.Type[:2] == "[]" {
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
			WriteGoLen(MessageField{Name: fn, Type: f.Type[2:], Order: f.Order}, scopeDepth+1, buf, messages)
			for i := 0; i < scopeDepth; i++ {
				buf.WriteString("\t")
			}
			buf.WriteString("}\n")
		} else {
			buf.WriteString("mylen += ")
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(".Len()")
		}
	}
	buf.WriteString("\n")
}

func WriteGoSerialize(f MessageField, scopeDepth int, buf *bytes.Buffer, messages map[string]Message) {
	for i := 0; i < scopeDepth; i++ {
		buf.WriteString("\t")
	}
	switch f.Type {
	case "[]byte":
		buf.WriteString("binary.Write(buffer, binary.LittleEndian, int32(len(")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(")))\n")
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}
		buf.WriteString("buffer.Write(")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(")\n")
	case "byte":
		buf.WriteString("buffer.WriteByte(")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(")\n")
	case "int16", "int32", "uint16", "uint32", "int64", "uint64":
		buf.WriteString("binary.Write(buffer, binary.LittleEndian, ")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(")\n")
	case "string":
		buf.WriteString("binary.Write(buffer, binary.LittleEndian, int32(len(")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(")))\n")
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}
		buf.WriteString("buffer.WriteString(")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(")\n")
	default:
		if f.Type[:2] == "[]" {
			// Array!
			buf.WriteString("binary.Write(buffer, binary.LittleEndian, int32(len(")
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}

			buf.WriteString(f.Name)
			buf.WriteString(")))\n")
			for i := 0; i < scopeDepth; i++ {
				buf.WriteString("\t")
			}
			fn := "v" + strconv.Itoa(scopeDepth+1)
			buf.WriteString("for _, ")
			buf.WriteString(fn)
			buf.WriteString(" := range ")
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(" {\n")
			WriteGoSerialize(MessageField{Name: fn, Type: f.Type[2:], Order: f.Order}, scopeDepth+1, buf, messages)
			for i := 0; i < scopeDepth; i++ {
				buf.WriteString("\t")
			}
			buf.WriteString("}\n")
		} else {
			// Custom message deserial here.
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(".Serialize(buffer)\n")
		}
	}
}

func WriteGoDeserial(f MessageField, scopeDepth int, buf *bytes.Buffer, messages map[string]Message) {
	for i := 0; i < scopeDepth; i++ {
		buf.WriteString("\t")
	}
	switch f.Type {
	case "byte":
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(", _ = buffer.ReadByte()\n")
	case "int16", "int32", "int64", "uint16", "uint32", "uint64":
		buf.WriteString("binary.Read(buffer, binary.LittleEndian, &")
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(")\n")
	case "string":
		lname := "l" + strconv.Itoa(f.Order) + "_" + strconv.Itoa(scopeDepth)
		buf.WriteString("var ")
		buf.WriteString(lname)
		buf.WriteString(" int32\n")
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}
		buf.WriteString("binary.Read(buffer, binary.LittleEndian, &")
		buf.WriteString(lname)
		buf.WriteString(")\n")
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}
		tmpname := "temp" + strconv.Itoa(f.Order) + "_" + strconv.Itoa(scopeDepth)
		buf.WriteString(tmpname)
		buf.WriteString(" := make([]byte, ")
		buf.WriteString(lname)
		buf.WriteString(")\n")
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}
		buf.WriteString("buffer.Read(")
		buf.WriteString(tmpname)
		buf.WriteString(")\n")
		for i := 0; i < scopeDepth; i++ {
			buf.WriteString("\t")
		}
		if scopeDepth == 1 {
			buf.WriteString("m.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(" = string(")
		buf.WriteString(tmpname)
		buf.WriteString(")\n")
	default:
		if f.Type[:2] == "[]" {
			// Get len of array
			lname := "l" + strconv.Itoa(f.Order) + "_" + strconv.Itoa(scopeDepth)
			buf.WriteString("var ")
			buf.WriteString(lname)
			buf.WriteString(" int32\n")
			for i := 0; i < scopeDepth; i++ {
				buf.WriteString("\t")
			}
			buf.WriteString("binary.Read(buffer, binary.LittleEndian, &")
			buf.WriteString(lname)
			buf.WriteString(")\n")

			// Create array variable
			for i := 0; i < scopeDepth; i++ {
				buf.WriteString("\t")
			}
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(" = make([]")
			buf.WriteString(f.Type[2:])
			buf.WriteString(", ")
			buf.WriteString(lname)
			buf.WriteString(")\n")

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
			WriteGoDeserial(MessageField{Name: fn, Type: f.Type[2:]}, scopeDepth+1, buf, messages)
			for i := 0; i < scopeDepth; i++ {
				buf.WriteString("\t")
			}
			buf.WriteString("}\n")
		} else {
			// Custom message deserial here.
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(" = new(")
			buf.WriteString(f.Type[1:])
			buf.WriteString(")\n")

			for i := 0; i < scopeDepth; i++ {
				buf.WriteString("\t")
			}
			if scopeDepth == 1 {
				buf.WriteString("m.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(".Deserialize(buffer)\n")
		}
	}

}
