package sqlstore


import (
  "github.com/grafana/grafana/pkg/bus"
  m "github.com/grafana/grafana/pkg/models"

  "time"
  "github.com/go-xorm/xorm"
  "github.com/grafana/grafana/pkg/log"
  "github.com/grafana/grafana/pkg/events"
)
func init()  {

  bus.AddHandler("sql",GetSubProcess)
  bus.AddHandler("sql",addSubProcess)
  bus.AddHandler("sql",RemoveOrgSubProcess)
  bus.AddHandler("sql",UpdateSubProcess)
  bus.AddHandler("sql",GetSubProcessById)
  bus.AddHandler("sql",GetSubProcessByName)
}
func GetSubProcess(query *m.GetSubProcessQuery) error {

  query.Result = make([]*m.SubProcessDTO, 0)
  sess := x.Table("sub_process")
  sess.Where("sub_process.org_id=?", query.OrgId)
  sess.Cols("sub_process.org_id","sub_process.process_name","sub_process.sub_process_name","sub_process.updated_by","sub_process.sub_process_id")

  err := sess.Find(&query.Result)
  return err
}

func addSubProcess(cmd *m.AddSubProcessCommand) error {
  return inTransaction(func(sess *xorm.Session) error {
    // check if user exists
    logger := log.New("main")
    logger.Info("AddProcessForCurrentOrg")

    entity := m.SubProcess{
      OrgId:   cmd.OrgId,

      SubProcessName:    cmd.SubProcessName,
      ProcessName:cmd.ProcessName,
      UpdatedBy:cmd.UpdatedBy,
      Created: time.Now(),
      Updated: time.Now(),
    }

    _, err := sess.Insert(&entity)
    return err
  })
}

func RemoveOrgSubProcess(cmd *m.DeleteSubProcessCommand) error {
  return inTransaction(func(sess *xorm.Session) error {
    logger := log.New("main")
    logger.Info("Delete Process 3 %s")
    var rawSql = "DELETE FROM sub_process WHERE org_id=? and sub_process_id=?"
    _, err := sess.Exec(rawSql, cmd.OrgId, cmd.SubProcessId)
    if err != nil {
      return err
    }

    logger.Info("Delete Process 4 %s")
    return validateOneAdminLeftInOrg(cmd.OrgId, sess)
  })
}

func UpdateSubProcess(cmd *m.UpdateSubProcessCommand) error {
  return inTransaction2(func(sess *session) error {
    logger := log.New("main")
    logger.Info("updatedProcess3 %s")


    subprocess := m.SubProcess{
      SubProcessId:cmd.SubProcessId,
      ProcessName:cmd.ProcessName,
      SubProcessName:    cmd.SubProcessName,
      UpdatedBy:cmd.UpdatedBy,
      Updated: time.Now(),
    }
    logger.Info("updatedProcess4 %s")
    if _, err := sess.Where("sub_process_id= ?",subprocess.SubProcessId).Update(&subprocess); err != nil {
      return err
    }


    logger.Info("updatedProcess5 %s")
    sess.publishAfterCommit(&events.SubProcessUpdated{
      Timestamp: subprocess.Created,
      SubProcessId: subprocess.SubProcessId,
      SubProcessName:subprocess.SubProcessName,
      ProcessName:subprocess.ProcessName,
      UpdatedBy:subprocess.UpdatedBy,
    })

    return nil
  })
}

func GetSubProcessById(query *m.GetSubProcessByIdQuery) error {

  logger := log.New("main")
  logger.Info("get Process by id 5%s")
  var subprocess m.SubProcess
  _, err := x.Where("sub_process_id= ?",query.SubProcessId).Get(&subprocess)
  if err != nil {
    return err
  }

  logger.Info("get Process by id 6%s")


  query.Result = &subprocess
  return nil



}
/*
func GetSubProce(query *m.GetSubProcessByMainProcessQuery) error {

  logger := log.New("main")
  logger.Info("Get Sub Process 4%s")
  var subprocess m.SubProcess
  _, err := x.Where("process_name= ?",query.ProcessName).Get(&subprocess)
  if err != nil {
    return err
  }

  logger.Info("Get Sub Process 5%s")


  query.Result = &subprocess
  return nil



}
*/
func GetSubProcessByName(query *m.GetSubProcessByMainProcessQuery) error {

  query.Result = make([]*m.SubProcessDTO, 0)
  sess := x.Table("sub_process")
  sess.Where("sub_process.process_name=?", query.ProcessName)
  sess.Cols("sub_process.org_id","sub_process.process_name","sub_process.sub_process_name","sub_process.updated_by","sub_process.sub_process_id")

  err := sess.Find(&query.Result)
  return err
}
