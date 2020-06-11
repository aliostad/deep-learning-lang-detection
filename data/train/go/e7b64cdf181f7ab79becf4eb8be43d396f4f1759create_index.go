package order

import (
	"bytes"
)

type CreateIndex struct {
	SchemaName string
	TableName  string
	IndexName  string
	Exprs      []string
	Unique     bool
}

func (x CreateIndex) String() string {
	var b bytes.Buffer
	b.WriteString("CREATE ")
	if x.Unique {
		b.WriteString("UNIQUE ")
	}
	b.WriteString("INDEX ")
	b.WriteString(x.IndexName)
	b.WriteString(" ON ")
	b.WriteString(x.SchemaName)
	b.WriteString(".")
	b.WriteString(x.TableName)
	b.WriteString(" (")
	for i, expr := range x.Exprs {
		if i != 0 {
			b.WriteString(", ")
		}
		b.WriteString(expr)
	}
	b.WriteString(")")
	return b.String()
}

var _ Change = (*CreateIndex)(nil)
