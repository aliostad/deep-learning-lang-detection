package main

import (
	"os"
	"strconv"
)

func GenerateUpdate(f *os.File, r Datarows) {
	f.WriteString("\r\n\r\n")
	f.WriteString("func (t *" + r.tablename + ") Update(db *sql.DB) (int64, error) {")
	f.WriteString("\r\n\t")
	f.WriteString("buf := new(bytes.Buffer)")
	f.WriteString("\r\n\t")
	f.WriteString("buf.WriteString(\"UPDATE public.\\\"" + r.tablename + "\\\" SET \")")

	f.WriteString("\r\n\t")
	for i := 1; i < len(r.columnnames)-1; i++ {
		f.WriteString("buf.WriteString(\" \\\"" + r.columnnames[i] + "\\\"=$" + strconv.Itoa(i) + ",\")")
		f.WriteString("\r\n\t")
	}
	f.WriteString("buf.WriteString(\" \\\"" + r.columnnames[len(r.columnnames)-1] + "\\\"=$" + strconv.Itoa(len(r.columnnames)-1) + "\")")
	f.WriteString("\r\n\t")
	f.WriteString("buf.WriteString(\" WHERE \\\"Id\\\"=$" + strconv.Itoa(len(r.columnnames)) + "\")")

	f.WriteString("\r\n\t\r\n\t")
	f.WriteString("stmt, err := db.Prepare(buf.String())")
	f.WriteString("\r\n\t")
	f.WriteString("check(err)")

	f.WriteString("\r\n\t\r\n\t")
	f.WriteString("res, err := stmt.Exec(")
	for i := 1; i < len(r.columnnames); i++ {
		f.WriteString("t." + r.columnnames[i] + ", ")
	}
	f.WriteString("t.Id)")
	f.WriteString("\r\n\t")
	f.WriteString("check(err)")

	f.WriteString("\r\n\t\r\n\t")
	f.WriteString("return res.RowsAffected()")

	f.WriteString("\r\n")
	f.WriteString("}")
}
