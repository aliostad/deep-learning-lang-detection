package model

import (
	"bytes"
)

func WriteAttrIf(b *bytes.Buffer, fieldName string, fieldValue *string) {
	if fieldValue != nil {
		b.WriteString(fieldName + `="` + *fieldValue + `" `)
	}
}

func (s Schema) String() string {
	b := bytes.Buffer{}

	b.WriteString(`<?xml version="1.0" encoding="UTF-8" ?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
`)

	for _, c := range s.ComplexTypes {
		b.WriteString(c.String())
	}

	for _, s := range s.SimpleTypes {
		b.WriteString(s.String())
	}

	for _, e := range s.Elements {
		b.WriteString(e.String())
	}

	b.WriteString("</xs:schema>\n")
	return b.String()
}

func (e Element) String() string {
	b := &bytes.Buffer{}
	b.WriteString("<xs:element ")
	WriteAttrIf(b, "name", e.Name)
	WriteAttrIf(b, "type", e.Type)
	WriteAttrIf(b, "ref", e.Ref)

	c := e.Child()
	if c == nil {
		b.WriteString("/>\n")
		return b.String()
	}
	b.WriteString(">\n")

	switch c := c.(type) {
	case *SimpleType:
		b.WriteString(c.String())
	case *ComplexType:
		b.WriteString(c.String())
	}
	b.WriteString("</element>\n")
	return b.String()

}

func (c ComplexType) String() string {
	b := &bytes.Buffer{}
	b.WriteString("<xs:complexType ")
	WriteAttrIf(b, "name", c.Name)
	b.WriteString(">\n")

	b.WriteString(c.Sequence.String())

	for _, a := range c.Attributes {
		b.WriteString(a.String())
	}

	b.WriteString("</xs:complexType>\n")
	return b.String()
}

func (s *Sequence) String() string {
	if s == nil {
		return ""
	}
	b := &bytes.Buffer{}
	b.WriteString("<xs:sequence>\n")
	for _, e := range s.Elements {
		b.WriteString(e.String())
	}
	b.WriteString("</xs:sequence>\n")
	return b.String()
}

func (c SimpleType) String() string {
	b := &bytes.Buffer{}
	b.WriteString("<xs:simpleType ")
	WriteAttrIf(b, "name", c.Name)
	b.WriteString(">\n")
	b.WriteString("</xs:simpleType>")
	return b.String()
}

func (a Attribute) String() string {
	b := &bytes.Buffer{}
	b.WriteString("<xs:attribute ")
	WriteAttrIf(b, "name", a.Name)
	WriteAttrIf(b, "type", a.Type)
	WriteAttrIf(b, "ref", a.Ref)
	b.WriteString("/>\n")

	return b.String()
}
