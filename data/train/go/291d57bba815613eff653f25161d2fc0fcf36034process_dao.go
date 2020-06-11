/*
 * bakufu
 *
 * Copyright (c) 2016 STNMRSHX
 * Licensed under the WTFPL license.
 */

package inst

import (
	"github.com/stnmrshx/golib/log"
	"github.com/stnmrshx/golib/sqlutils"
	"github.com/stnmrshx/bakufu/go/db"
)

func WriteLongRunningProcesses(instanceKey *InstanceKey, processes []Process) error {
	writeFunc := func() error {
		_, err := db.ExecBakufu(`
			delete from
					database_instance_long_running_queries
				where
					hostname = ?
					and port = ?
			`,
			instanceKey.Hostname,
			instanceKey.Port)
		if err != nil {
			return log.Errore(err)
		}

		for _, process := range processes {
			_, merr := db.ExecBakufu(`
	        	insert ignore into database_instance_long_running_queries (
	        		hostname,
	        		port,
	        		process_id,
	        		process_started_at,
					process_user,
					process_host,
					process_db,
					process_command,
					process_time_seconds,
					process_state,
					process_info
				) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
				instanceKey.Hostname,
				instanceKey.Port,
				process.Id,
				process.StartedAt,
				process.User,
				process.Host,
				process.Db,
				process.Command,
				process.Time,
				process.State,
				process.Info,
			)
			if merr != nil {
				err = merr
			}
		}
		if err != nil {
			return log.Errore(err)
		}

		return nil
	}
	return ExecDBWriteFunc(writeFunc)
}

func ReadLongRunningProcesses(filter string) ([]Process, error) {
	longRunningProcesses := []Process{}

	if filter != "" {
		filter = "%" + filter + "%"
	} else {
		filter = "%"
	}
	query := `
		select
			hostname,
			port,
			process_id,
			process_started_at,
			process_user,
			process_host,
			process_db,
			process_command,
			process_time_seconds,
			process_state,
			process_info
		from
			database_instance_long_running_queries
		where
			hostname like ?
			or process_user like ?
			or process_host like ?
			or process_db like ?
			or process_command like ?
			or process_state like ?
			or process_info like ?
		order by
			process_time_seconds desc
		`
	args := sqlutils.Args(filter, filter, filter, filter, filter, filter, filter)
	err := db.QueryBakufu(query, args, func(m sqlutils.RowMap) error {
		process := Process{}
		process.InstanceHostname = m.GetString("hostname")
		process.InstancePort = m.GetInt("port")
		process.Id = m.GetInt64("process_id")
		process.User = m.GetString("process_user")
		process.Host = m.GetString("process_host")
		process.Db = m.GetString("process_db")
		process.Command = m.GetString("process_command")
		process.Time = m.GetInt64("process_time_seconds")
		process.State = m.GetString("process_state")
		process.Info = m.GetString("process_info")
		process.StartedAt = m.GetString("process_started_at")

		longRunningProcesses = append(longRunningProcesses, process)
		return nil
	})

	if err != nil {
		log.Errore(err)
	}
	return longRunningProcesses, err
}
