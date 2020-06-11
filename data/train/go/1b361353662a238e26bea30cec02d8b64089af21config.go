package config

import (
	"bytes"
	"database/sql"
	"unicode"
)

var db *sql.DB
var err error

func Dbconn() (db *sql.DB, err error) {
	//host := "192.168.10.201"
	host := "localhost"
	port := "3306"
	dbname := "myposys_db_833"
	uid := "mssaf"
	pass := "trian@akxmflej"

	var buf bytes.Buffer

	buf.WriteString(uid).WriteString(":").WriteString(pass).WriteString("@tcp(").WriteString(host).WriteString(":").WriteString(port).WriteString(")/").WriteString(dbname)
	// sql.DB 객체 생성
	db, err = sql.Open("mysql", buf.String())
	return
}
