package tools

import (
	"fmt"
	originalRedis "github.com/garyburd/redigo/redis"
)

//-----------------Mysql Transaction--------------------------------//

func ExecStep(sql string, args ...interface{}) func(*instrument.Tx) error {
	return func(tx *instrument.Tx) error {
		r, e := tx.Exec(sql, args...)
		if e == nil {
			if ar, e := r.RowsAffected(); ar <= 0 {
				if e == nil {
					e = CreateError(ErrorType_PROCESS_ERROR, fmt.Sprint("Statement:", sql, "Arguments:", args))
				}
				return e
			} else {
				return nil
			}
		} else {
			return e
		}
	}
}

func OtherStep(step func() error) func(*instrument.Tx) error {
	return func(*instrument.Tx) error {
		return step()
	}
}

func DoTransaction(db *instrument.DB, runObjs ...func(*instrument.Tx) error) (e error) {
	tx, e := db.Begin()
	if e == nil {
		for i := 0; i < len(runObjs); i++ {
			e = runObjs[i](tx)
			if e != nil {
				tx.Rollback()
				return e
			}
		}
		tx.Commit()
	}
	return e
}

//-----------------Mysql Transaction--------------------------------//

//-----------------Redis Transaction--------------------------------//

func DoRedisInsertTransaction(rc *redis.Cluster, key string, commands ...func(originalRedis.Conn) error) (e error) {
	r := rc.Do(
		key,
		func(con originalRedis.Conn) {
			con.Do("MULIT")
			for i := 0; i < len(commands); i++ {
				if e = commands[i](con); e != nil {
					con.Do("AbortThisTransaction")
					break;
				}
			}
			con.Do("EXEC")
		})
	if e == nil {
		return r
	}
	return e
}
