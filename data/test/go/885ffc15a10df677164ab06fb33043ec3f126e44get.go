package main

import (
"os"
)

func GenerateGetById(f *os.File, r Datarows) {
	f.WriteString("\r\n\r\n")
	f.WriteString("func (t *" + r.tablename + ") GetById(id int, db *sql.DB) {")
	f.WriteString("\r\n\t\r\n\t")
	f.WriteString("rows, err := db.Query(\"SELECT * FROM public.\\\"" + r.tablename + "\\\" WHERE \\\"Id\\\" = \" + strconv.Itoa(id))")
	f.WriteString("\r\n\t")
	f.WriteString("defer rows.Close()")
	f.WriteString("\r\n\t")
	f.WriteString("check(err)")
	f.WriteString("\r\n\t\r\n\t")
	f.WriteString("for rows.Next() {")
	f.WriteString("\r\n\t\t")
	f.WriteString("rows.Scan(")
	for i := 0; i < len(r.columnnames)-1; i++ {
		f.WriteString("&t." + r.columnnames[i] + ", ")
	}
	f.WriteString("&t." + r.columnnames[len(r.columnnames)-1] )
	
	f.WriteString(")")
	f.WriteString("\r\n\t")
	f.WriteString("}")
	f.WriteString("\r\n")
	f.WriteString("}")
}