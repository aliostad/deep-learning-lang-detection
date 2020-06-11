package frm

import (
	"encoding/binary"
	"io"
)

type column struct {
	fieldLength  uint16
	unireg       uint8
	flags        uint16
	uniregType   uint8
	charsetLow   uint8
	intervalNr   uint8
	fieldType    uint8
	charset      uint8
	comentLength uint16
	name         string
}

func (c *column) read(d []byte) {
	// skip 3
	c.fieldLength = binary.LittleEndian.Uint16(d[3:5])
	// skip 2
	c.unireg = d[7]
	c.flags = binary.LittleEndian.Uint16(d[8:10])
	c.uniregType = d[10]
	c.charsetLow = d[11]
	c.intervalNr = d[12]
	c.fieldType = d[13]
	c.charset = d[14]
	c.comentLength = binary.LittleEndian.Uint16(d[15:17])
}

func (c *column) charsetNum() int {
	return (int(c.charsetLow) << 8) + int(c.charset)
}

func (c *column) charsetA() *charset {
	return charsets[c.charsetNum()]
}

func (c *column) maxLen() int {
	return c.charsetA().maxLen
}

func (c *column) writeSize(w io.Writer) {
	writeParened(w, int(c.fieldLength))
}

func (c *column) writeSign(w io.Writer) {
	if (int(c.flags) & signedFieldFlag) == 0 {
		writeString(w, " UNSIGNED")
	}
}

func (c *column) writeCharset(w io.Writer) {
	cs := c.charsetA()
	writeString(w, " CHARACTER SET ")
	writeString(w, cs.name)
	writeString(w, " COLLATE ")
	writeString(w, cs.collate)
}

func (c *column) writeSized(w io.Writer, s string) {
	writeString(w, s)
	c.writeSize(w)
}

func (c *column) writeSigned(w io.Writer, s string) {
	writeString(w, s)
	c.writeSign(w)
}

func (c *column) writeSizedSigned(w io.Writer, s string) {
	writeString(w, s)
	c.writeSize(w)
	c.writeSign(w)
}

func (c *column) writeBlob(w io.Writer, s string) {
	writeString(w, s)
	if c.charsetNum() == binaryCharset {
		writeString(w, "BLOB")
	} else {
		writeString(w, "TEXT")
		c.writeCharset(w)
	}
}

func (c *column) writeBinary(w io.Writer, s string) {
	cn := c.charsetNum()
	writeString(w, s)
	if cn == binaryCharset {
		writeString(w, "BINARY")
		c.writeSize(w)
	} else {
		cs := c.charsetA()
		writeString(w, "CHAR")
		writeParened(w, int(c.fieldLength)/cs.maxLen)
		c.writeCharset(w)
	}
}

func (c *column) write(w io.Writer) {
	writeQuoted(w, c.name)
	writeSpace(w)
	switch c.fieldType {
	case newDateFieldType:
		writeString(w, "DATE")
	case dateTime2FieldType:
		writeString(w, "DATETIME")
	case time2FieldType:
		writeString(w, "TIME")
	case timeStamp2FieldType:
		writeString(w, "TIMESTAMP DEFAULT '2000-01-01'")
	case geometryFieldType:
		switch c.charsetNum() {
		case geometryGeomType:
			writeString(w, "GEOMETRY")
		case pointGeomType:
			writeString(w, "POINT")
		case lineStringGeomType:
			writeString(w, "LINESTRING")
		case polygonGeomType:
			writeString(w, "POLYGON")
		case multiPointGeomType:
			writeString(w, "MULTIPOINT")
		case multiLineStrintGeomType:
			writeString(w, "MULTILINESTRING")
		case multiPolygonGeomType:
			writeString(w, "MULTIPOLYGON")
		case geometryCollectionGeomType:
			writeString(w, "GEOMETRYCOLLECTION")
		}
	case doubleFieldType:
		c.writeSigned(w, "DOUBLE")
	case floatFieldType:
		c.writeSigned(w, "FLOAT")
	case bitFieldType:
		c.writeSized(w, "BIT")
	case tinyFieldType:
		c.writeSizedSigned(w, "TINYINT")
	case shortFieldType:
		c.writeSizedSigned(w, "SMALLINT")
	case longFieldType:
		c.writeSizedSigned(w, "INT")
	case int24FieldType:
		c.writeSizedSigned(w, "MEDIUMINT")
	case longLongFieldType:
		c.writeSizedSigned(w, "BIGINT")
	case tinyBlobFieldType:
		c.writeBlob(w, "TINY")
	case mediumBlobFieldType:
		c.writeBlob(w, "MEDIUM")
	case longBlobFieldType:
		c.writeBlob(w, "LONG")
	case blobFieldType:
		c.writeBlob(w, emptyString)
	case varCharFieldType:
		c.writeBinary(w, "VAR")
	case stringFieldType:
		c.writeBinary(w, emptyString)
	case newDecimalFieldType:
		writeString(w, "DECIMAL")
		i := int(c.fieldLength) - (int(c.flags) & signedFieldFlag)
		f := (int(c.flags) >> decimalShift) & decimalMask
		if f > 0 {
			i--
		}
		writeOpenParen(w)
		writeNumber(w, i)
		writeComma(w)
		writeNumber(w, f)
		writeCloseParen(w)
		c.writeSign(w)
	default:
		writeString(w, "<UNKNOWN_TYPE>")
	}
	if (c.flags & nullableFieldFlag) == 0 {
		writeString(w, " NOT NULL")
	}
	if c.uniregType == 15 {
		writeString(w, " AUTO_INCREMENT")
	}
}
