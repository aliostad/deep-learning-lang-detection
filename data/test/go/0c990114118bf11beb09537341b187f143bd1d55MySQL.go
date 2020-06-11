package commons

import (
	"AccountManagement/conf"

	"database/sql"
	"fmt"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

const (
	BizMySQLConfPrefix = "bmysql."
	mySQLUrlPattern    = "%s:%s@tcp(%s:%d)/%s?charset=utf8mb4"
)

var (
	dbMap map[string]*instrument.DB
)

func SetupMySQL() {
	dbMap = make(map[string]*instrument.DB)

	for _, instance := range conf.BizMySQLInstances {
		config := conf.BizMySQL[instance]
		db := newDBInstance(config.DbName, config)
		//instance = BizMySQLConfPrefix + instance
		dbMap[instance] = instrument.NewDB(db,
			&instrument.Options{
				Tag: instance,
				LogVerbose: func(v ...interface{}) {
					logger.Debug(nil, v...)
				},
				ObserveLatency: func(latency time.Duration) {
					prometheus.MySQLHistogramVec.WithLabelValues(instance).Observe(float64(latency.Nanoseconds()) * 1e-6)
				},
			},
		)
	}
}

func newDBInstance(dbName string, config conf.MySQLConf) *sql.DB {
	dbUrl := fmt.Sprintf(mySQLUrlPattern, config.Username, config.Password, config.Host, config.Port, dbName)

	db, err := sql.Open("mysql", dbUrl)
	if err != nil {
		logger.Fatalf(nil, "open %s failed: %v", dbUrl, err)
	}

	db.SetMaxIdleConns(config.MaxIdle)
	db.SetMaxOpenConns(config.MaxConn)
	return db
}

func GetDB(name string) *instrument.DB {
	return dbMap[name]
}
