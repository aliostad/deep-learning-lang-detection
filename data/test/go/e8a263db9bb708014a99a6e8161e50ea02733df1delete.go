package main

import (
"os"
)

func GenerateDelete(f *os.File, r Datarows){
	f.WriteString("\r\n\r\n")
	f.WriteString("func (t *" + r.tablename + ") Delete(db *sql.DB) (int64, error) {")
	f.WriteString("\r\n\t\r\n\t")
	f.WriteString("stmt, err := db.Prepare(\"DELETE FROM public.\\\"" + r.tablename + "\\\" WHERE \\\"Id\\\" = $1\")")
	f.WriteString("\r\n\t")
	f.WriteString("check(err)")
	f.WriteString("\r\n\t\r\n\t")
	f.WriteString("res, err := stmt.Exec(t.Id)")
	f.WriteString("\r\n\t")
	f.WriteString("check(err)")
	f.WriteString("\r\n\t\r\n\t")
	f.WriteString("return res.RowsAffected()")
	f.WriteString("\r\n")
	f.WriteString("}")
}