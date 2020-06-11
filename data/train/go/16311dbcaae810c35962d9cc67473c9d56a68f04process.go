package sqlstore

import (
  "github.com/grafana/grafana/pkg/bus"
  m "github.com/grafana/grafana/pkg/models"
  "github.com/go-xorm/xorm"
  "time"
  "github.com/grafana/grafana/pkg/log"
 // "fmt"
  //"github.com/Unknwon/bra/cmd"

 // "github.com/grafana/grafana/pkg/events"


  "github.com/grafana/grafana/pkg/events"
 // "github.com/grafana/grafana/pkg/cmd/grafana-cli/logger"
)

func init()  {

  bus.AddHandler("sql",addProcess)
  bus.AddHandler("sql",GetProcess)
  bus.AddHandler("sql",RemoveOrgProcess)
  bus.AddHandler("sql",GetProcessById)
  //bus.AddHandler("sql",UpdateProcessUser)
  bus.AddHandler("sql",UpdateProcess)
  bus.AddHandler("sql",GetProcessByProcessId)
  bus.AddHandler("sql",GetProcessByName)
  bus.AddHandler("sql",GetProcessByProcessName)
}

func addProcess(cmd *m.AddProcessCommand) error {
  return inTransaction(func(sess *xorm.Session) error {
    // check if user exists
    logger := log.New("main")
    logger.Info("AddProcessForCurrentOrg")

    entity := m.Process{
      OrgId:   cmd.OrgId,

      ProcessName:    cmd.ProcessName,
      UpdatedBy:cmd.UpdatedBy,
      Created: time.Now(),
      Updated: time.Now(),
    }

    _, err := sess.Insert(&entity)
    return err
  })
}

func GetProcess(query *m.GetProcessQuery) error {

  query.Result = make([]*m.ProcessDTO, 0)
  sess := x.Table("process")
  sess.Where("process.org_id=?", query.OrgId)
  sess.Cols("process.org_id","process.process_name","process.updated_by","process.process_id")

  err := sess.Find(&query.Result)
  return err
}


func RemoveOrgProcess(cmd *m.DeleteProcessCommand) error {
  return inTransaction(func(sess *xorm.Session) error {
    logger := log.New("main")
    logger.Info("Delete Process 3 %s")
    var rawSql = "DELETE FROM process WHERE org_id=? and process_id=?"
    _, err := sess.Exec(rawSql, cmd.OrgId, cmd.ProcessId)
    if err != nil {
      return err
    }

    logger.Info("Delete Process 4 %s")
    return validateOneAdminLeftInOrg(cmd.OrgId, sess)
  })
}



func GetProcessById(query *m.GetProcessByIdQuery) error {

  logger := log.New("main")
  logger.Info("get Process by id 1%s")
  var process m.Process
  exists, err := x.Where("process_id= ?",query.ProcessId).Get(&process)
  if err != nil {
    return err
  }

  logger.Info("get Process by id %s")
  if !exists {
    return m.ErrOrgNotFound
  }

  query.Result = &process
  return nil



}

/*
func UpdateProcessUser(cmd *m.UpdateOrgProcessCommand) error {
  return inTransactiologger := log.New("main")
    logger.Info("updatedProcess3 %s")n(func(sess *xorm.Session) error {
    logger := log.New("main")
    logger.Info("updatedProcess3 %s")
    var orgUser m.Process
    exists, err := sess.Where("org_id=? AND process_id=?", cmd.OrgId, cmd.ProcessId).Get(&orgUser)

    logger.Info("updatedProcess3 %s")
    if err != nil {
      return err
    }

    if !exists {
      return m.ErrOrgUserNotFound
    }

    orgUser.ProcessName = cmd.ProcessName
    orgUser.ParentProcessName=cmd.ParentProcessName
    orgUser.UpdatedBy= cmd.UpdatedBy
    orgUser.Updated = time.Now()

    logger.Info("updatedProcess3 %s")
    _, err = sess.Id(orgUser.ProcessId).Update(&orgUser)
    if err != nil {
      return err
    }

    return validateOneAdminLeftInOrg(cmd.OrgId, sess)
  })
}
*/

func UpdateProcess(cmd *m.UpdateProcessCommand) error {
  return inTransaction2(func(sess *session) error {
    logger := log.New("main")
    logger.Info("updatedProcess3 %s")


    process := m.Process{
      ProcessId:cmd.ProcessId,
      ProcessName:    cmd.ProcessName,
      UpdatedBy:cmd.UpdatedBy,
      Updated: time.Now(),
    }
    logger.Info("updatedProcess4 %s")
    /*if _, err := sess.Sql("SELECT  FROM process where process_id=?",cmd.ProcessId).Update(process); err != nil {
       return err
     }

*/

    if _, err := sess.Where("process_id= ?",process.ProcessId).Update(&process); err != nil {
       return err
     }

    /*
    if _, err := sess.Id("processId").Update(&process); err != nil {
      return err
    }
   */
    logger.Info("updatedProcess5 %s")
    sess.publishAfterCommit(&events.ProcessUpdated{
      Timestamp: process.Created,
      ProcessId: process.ProcessId,
      ProcessName:process.ProcessName,
      UpdatedBy:process.UpdatedBy,
    })

    return nil
  })
}

/*
func UpdateProcess(cmd *m.UpdateOrgProcessCommand) error {
  return inTransaction(func(sess *xorm.Session) error {
    process := m.Process{
      ProcessName:    cmd.ProcessName,
      ParentProcessName:cmd.ParentProcessName,
      UpdatedBy:cmd.UpdatedBy,
      Updated: time.Now(),
    }
    var rawSql = "UPDATE process SET process_name=? WHERE process_id=?"
    _, err := sess.Exec(rawSql, string(process.ProcessName), process.ProcessId)
    return err
  })
}
*/




func GetProcessByProcessId(query *m.GetProcessByCodeQuery) error {
  var rawSql = `SELECT FROM ` + dialect.Quote("process") + `WHERE process_id=?`

  var tempUser m.ProcessDTO
  sess := x.Sql(rawSql, query.ProcessId)
  has, err := sess.Get(&tempUser)

  if err != nil {
    return err
  } else if has == false {
    return m.ErrTempUserNotFound
  }

  query.Result = &tempUser
  return err
}


func GetProcessByName(query *m.GetProcessByNameQuery) error {

  query.Result = make([]*m.ProcessDTO, 0)
  sess := x.Table("process")
  sess.Where("process.org_id=?", query.OrgId)
  sess.Cols("process.org_id","process.process_name","process.updated_by","process.process_id")
  sess.Distinct("process.process_name")
  err := sess.Find(&query.Result)
  return err
}

func GetProcessByProcessName(query *m.GetProcessByProcessNameQuery) error {

  query.Result = make([]*m.ProcessDTO, 0)
  sess := x.Table("process")
  sess.Where("process.org_id=?", query.OrgId)
  sess.Cols("process.org_id","process.process_name","process.updated_by","process.process_id")
  err := sess.Find(&query.Result)
  return err
}
