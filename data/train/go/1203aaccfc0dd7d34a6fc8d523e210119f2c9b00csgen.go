package main

import (
	"bytes"
	"io/ioutil"
	"strconv"
	"strings"
)

func WriteCS(messages []Message, messageMap map[string]Message) {
	gobuf := &bytes.Buffer{}
	gobuf.WriteString("using System;\nusing System.IO;\nusing System.Text;\n\n")

	gobuf.WriteString("interface INet {\n\tvoid Serialize(BinaryWriter buffer);\n\tvoid Deserialize(BinaryReader buffer);\n}\n\n")

	// Message type enum
	gobuf.WriteString("enum MsgType : ushort {Unknown=0,Ack=1,")
	for idx, t := range messages {
		gobuf.WriteString(t.Name)
		gobuf.WriteString("=")
		gobuf.WriteString(strconv.Itoa(idx + 2))
		if idx < len(messages)-1 {
			gobuf.WriteString(",")
		}
	}
	gobuf.WriteString("}\n\n")

	gobuf.WriteString("static class Messages {\n")
	gobuf.WriteString("// ParseNetMessage accepts input of raw bytes from a NetMessage. Parses and returns a Net message.\n")
	gobuf.WriteString("public static INet Parse(ushort msgType, byte[] content) {\n")
	gobuf.WriteString("\tINet msg = null;\n\tMsgType mt = (MsgType)msgType;\n")
	gobuf.WriteString("\tswitch (mt)\n\t{\n")
	for _, t := range messages {
		gobuf.WriteString("\t\tcase MsgType.")
		gobuf.WriteString(t.Name)
		gobuf.WriteString(":\n")
		gobuf.WriteString("\t\t\tmsg = new ")
		gobuf.WriteString(t.Name)
		gobuf.WriteString("();\n\t\t\tbreak;\n")
	}
	gobuf.WriteString("\t}\n")
	gobuf.WriteString("\tMemoryStream ms = new MemoryStream(content);")
	gobuf.WriteString("\n\tmsg.Deserialize(new BinaryReader(ms));\n\treturn msg;\n}\n")
	gobuf.WriteString("}\n\n")
	// 2. Generate go classes
	for _, msg := range messages {
		gobuf.WriteString("public class ")
		gobuf.WriteString(msg.Name)
		gobuf.WriteString(" : INet {")
		for _, f := range msg.Fields {
			gobuf.WriteString("\n\tpublic ")
			gobuf.WriteString(goTypeToCS(f.Type))
			gobuf.WriteString(" ")
			gobuf.WriteString(f.Name)
			gobuf.WriteString(";")
		}
		gobuf.WriteString("\n\n")

		gobuf.WriteString("\tpublic void Serialize(BinaryWriter buffer) {\n")
		for _, f := range msg.Fields {
			WriteCSSerialize(f, 1, gobuf, messageMap)
		}
		gobuf.WriteString("\t}\n\n")
		gobuf.WriteString("\tpublic void Deserialize(BinaryReader buffer) {\n")
		for _, f := range msg.Fields {
			WriteCSDeserial(f, 1, gobuf, messageMap)
		}
		gobuf.WriteString("\t}\n}\n\n")

	}
	ioutil.WriteFile("../client/Assets/Scripts/messages/messages.cs", gobuf.Bytes(), 0775)
}

func goTypeToCS(tn string) string {
	if len(tn) > 2 {
		prefix := ""
		for tn[:2] == "[]" {
			tn = tn[2:]
			prefix += "[]"
		}
		switch tn {
		case "uint16":
			tn = "ushort"
		case "uint32":
			tn = "uint"
		case "uint64":
			tn = "ulong"
		case "int16":
			tn = "short"
		case "int32":
			tn = "int"
		case "int64":
			tn = "long"
		}
		tn += prefix
	}
	tn = strings.Replace(tn, "*", "", -1)

	return tn
}

func WriteCSSerialize(f MessageField, scopeDepth int, buf *bytes.Buffer, messages map[string]Message) {
	for i := 0; i < scopeDepth+1; i++ {
		buf.WriteString("\t")
	}
	switch f.Type {
	// TODO: special case for []byte
	case "byte", "int16", "int32", "int64", "uint16", "uint32", "uint64":
		buf.WriteString("buffer.Write(")
		if scopeDepth == 1 {
			buf.WriteString("this.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(");\n")
	case "string":
		buf.WriteString("buffer.Write((Int32)")
		if scopeDepth == 1 {
			buf.WriteString("this.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(".Length);\n")
		for i := 0; i < scopeDepth+1; i++ {
			buf.WriteString("\t")
		}
		buf.WriteString("buffer.Write(System.Text.Encoding.UTF8.GetBytes(")
		if scopeDepth == 1 {
			buf.WriteString("this.")
		}
		buf.WriteString(f.Name)
		buf.WriteString("));\n")
	default:
		if f.Type[:2] == "[]" {
			// Array!
			buf.WriteString("buffer.Write((Int32)")
			if scopeDepth == 1 {
				buf.WriteString("this.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(".Length);\n")
			for i := 0; i < scopeDepth+1; i++ {
				buf.WriteString("\t")
			}

			loopvar := "v" + strconv.Itoa(scopeDepth+1)
			buf.WriteString("for (int ")
			buf.WriteString(loopvar)
			buf.WriteString(" = 0; ")
			buf.WriteString(loopvar)
			buf.WriteString(" < ")
			if scopeDepth == 1 {
				buf.WriteString("this.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(".Length; ")
			buf.WriteString(loopvar)
			buf.WriteString("++) {\n")
			fn := f.Name + "[" + loopvar + "]"
			if scopeDepth == 1 {
				fn = "this." + fn
			}
			WriteCSSerialize(MessageField{Name: fn, Type: f.Type[2:], Order: f.Order}, scopeDepth+1, buf, messages)
			for i := 0; i < scopeDepth+1; i++ {
				buf.WriteString("\t")
			}
			buf.WriteString("}\n")
		} else {
			// Custom message deserial here.
			if scopeDepth == 1 {
				buf.WriteString("this.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(".Serialize(buffer);\n")
		}
	}
}

func WriteCSDeserial(f MessageField, scopeDepth int, buf *bytes.Buffer, messages map[string]Message) {
	for i := 0; i < scopeDepth+1; i++ {
		buf.WriteString("\t")
	}
	switch f.Type {
	// TODO: special case for []byte
	case "byte":
		if scopeDepth == 1 {
			buf.WriteString("this.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(" = buffer.ReadByte();\n")
	case "int16", "int32", "int64", "uint16", "uint32", "uint64":
		if scopeDepth == 1 {
			buf.WriteString("this.")
		}
		buf.WriteString(f.Name)

		funcName := "Read"
		if f.Type[0] == 'u' {
			funcName += strings.ToUpper(f.Type[0:2]) + f.Type[2:]
		} else {
			funcName += strings.ToUpper(f.Type[0:1]) + f.Type[1:]
		}
		buf.WriteString(" = buffer.")
		buf.WriteString(funcName)
		buf.WriteString("();\n")
	case "string":
		lname := "l" + strconv.Itoa(f.Order) + "_" + strconv.Itoa(scopeDepth)
		buf.WriteString("int ")
		buf.WriteString(lname)
		buf.WriteString(" = buffer.ReadInt32();\n")
		for i := 0; i < scopeDepth+1; i++ {
			buf.WriteString("\t")
		}
		buf.WriteString("byte[] ")
		tmpname := "temp" + strconv.Itoa(f.Order) + "_" + strconv.Itoa(scopeDepth)
		buf.WriteString(tmpname)
		buf.WriteString(" = buffer.ReadBytes(")
		buf.WriteString(lname)
		buf.WriteString(");\n")
		for i := 0; i < scopeDepth+1; i++ {
			buf.WriteString("\t")
		}
		if scopeDepth == 1 {
			buf.WriteString("this.")
		}
		buf.WriteString(f.Name)
		buf.WriteString(" = System.Text.Encoding.UTF8.GetString(")
		buf.WriteString(tmpname)
		buf.WriteString(");\n")
	default:
		if f.Type[:2] == "[]" {
			// Get len of array
			lname := "l" + strconv.Itoa(f.Order) + "_" + strconv.Itoa(scopeDepth)
			buf.WriteString("int ")
			buf.WriteString(lname)
			buf.WriteString(" = buffer.ReadInt32();\n")
			for i := 0; i < scopeDepth+1; i++ {
				buf.WriteString("\t")
			}

			// Create array variable
			if scopeDepth == 1 {
				buf.WriteString("this.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(" = new ")
			t := goTypeToCS(f.Type)
			numdim := 0
			for t[len(t)-2:] == "[]" {
				t = t[:len(t)-2]
				numdim++
			}
			buf.WriteString(t)
			buf.WriteString("[")
			buf.WriteString(lname)
			buf.WriteString("]")
			for i := 0; i < numdim-1; i++ {
				buf.WriteString("[]")
			}
			buf.WriteString(";\n")

			// Read each var into the array in loop
			for i := 0; i < scopeDepth+1; i++ {
				buf.WriteString("\t")
			}
			loopvar := "v" + strconv.Itoa(scopeDepth+1)
			buf.WriteString("for (int ")
			buf.WriteString(loopvar)
			buf.WriteString(" = 0; ")
			buf.WriteString(loopvar)
			buf.WriteString(" < ")
			buf.WriteString(lname)
			buf.WriteString("; ")
			buf.WriteString(loopvar)
			buf.WriteString("++) {\n")
			fn := ""
			if scopeDepth == 1 {
				fn += "this."
			}
			fn += f.Name + "[" + loopvar + "]"
			WriteCSDeserial(MessageField{Name: fn, Type: f.Type[2:]}, scopeDepth+1, buf, messages)
			for i := 0; i < scopeDepth+1; i++ {
				buf.WriteString("\t")
			}
			buf.WriteString("}\n")
		} else {
			// Custom message deserial here.
			if scopeDepth == 1 {
				buf.WriteString("this.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(" = new ")
			buf.WriteString(f.Type[1:])
			buf.WriteString("();\n")

			for i := 0; i < scopeDepth+1; i++ {
				buf.WriteString("\t")
			}
			if scopeDepth == 1 {
				buf.WriteString("this.")
			}
			buf.WriteString(f.Name)
			buf.WriteString(".Deserialize(buffer);\n")
		}
	}

}
