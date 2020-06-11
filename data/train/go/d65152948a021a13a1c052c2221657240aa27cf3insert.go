package main

import (
	//"database/sql"
	_ "github.com/lib/pq"
	"os"
	"strconv"
)

func GenerateInsert(f *os.File, r Datarows) {

	f.WriteString("\r\n\r\n")
	f.WriteString("func (t *" + r.tablename + ") Insert(db *sql.DB) {")

	f.WriteString("\r\n\t\r\n\t")
	f.WriteString("var id int")

	f.WriteString("\r\n\t\r\n\t")
	f.WriteString("buf := new(bytes.Buffer)")

	f.WriteString("\r\n\t")
	f.WriteString("buf.WriteString(\"\\r\\n\")")
	f.WriteString("\r\n\t")
	f.WriteString("buf.WriteString(\"INSERT INTO public.\\\"" + r.tablename + "\\\" (\")")

	for i := 1; i < len(r.columnnames)-1; i++ {
		f.WriteString("\r\n\t")
		f.WriteString("buf.WriteString(\"\\\"" + r.columnnames[i] + "\\\",\")")
	}
	f.WriteString("\r\n\t")
	f.WriteString("buf.WriteString(\"\\\"" + r.columnnames[len(r.columnnames)-1] + "\\\"\")")

	f.WriteString("\r\n\t")
	f.WriteString("buf.WriteString(\") values (\")")

	for i := 0; i < len(r.columnnames)-2; i++ {
		f.WriteString("\r\n\t")
		f.WriteString("buf.WriteString(\"$" + strconv.Itoa(i+1) + ",\")")
	}
	f.WriteString("\r\n\t")
	f.WriteString("buf.WriteString(\"$" + strconv.Itoa(len(r.columnnames)-1) + ")\")")
	f.WriteString("\r\n\t")
	f.WriteString("buf.WriteString(\" returning \\\"Id\\\";\")")

	f.WriteString("\r\n\t\r\n\t")

	f.WriteString("err := db.QueryRow(buf.String()")

	for i := 1; i < len(r.columnnames); i++ {
		f.WriteString(", t." + r.columnnames[i])

	}
	f.WriteString(").Scan(&id)")

	f.WriteString("\r\n\t")
	f.WriteString("check(err)")

	f.WriteString("\r\n\t")
	f.WriteString("t.Id = id")

	f.WriteString("\r\n")
	f.WriteString("}")

}
