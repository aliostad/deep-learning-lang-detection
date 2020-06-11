package sql_metrics

import (
	"database/sql"
	"time"
)

type Stmt struct {
	proxyDB  *DB
	query    string
	Original *sql.Stmt
}

func newStmt(proxy *DB, stmt *sql.Stmt, query string) *Stmt {
	return &Stmt{
		proxyDB:  proxy,
		Original: stmt,
		query:    query,
	}
}

func (proxy *Stmt) measure(startTime time.Time) {
	proxy.proxyDB.measure(startTime, proxy.query)
}

// instrument Exec
func (proxy *Stmt) Exec(args ...interface{}) (sql.Result, error) {
	if Enable {
		startTime := time.Now()
		defer proxy.measure(startTime)
	}
	return proxy.Original.Exec(args...)
}

// instrument Query
func (proxy *Stmt) Query(args ...interface{}) (*sql.Rows, error) {
	if Enable {
		startTime := time.Now()
		defer proxy.measure(startTime)
	}
	return proxy.Original.Query(args...)
}

// instrument QueryRow
func (proxy *Stmt) QueryRow(args ...interface{}) *sql.Row {
	if Enable {
		startTime := time.Now()
		defer proxy.measure(startTime)
	}
	return proxy.Original.QueryRow(args...)
}

// just wrap
func (proxy *Stmt) Close() error {
	return proxy.Original.Close()
}
