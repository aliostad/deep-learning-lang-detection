package sqlstore

import (
  "github.com/grafana/grafana/pkg/bus"
  m "github.com/grafana/grafana/pkg/models"
  "github.com/go-xorm/xorm"
  "time"

 // "fmt"
  //"github.com/Unknwon/bra/cmd"
)

func init()  {

  bus.AddHandler("sql",AddProcess)
  bus.AddHandler("sql",GetProcess)

}

func AddProcess(cmd *m.AddProcessCommand) error {
  return inTransaction(func(sess *xorm.Session) error{
    // check if process exists
    if res, err := sess.Query("SELECT 1 from process WHERE org_id=? and process_id", cmd.OrgId, cmd.ProcessId); err != nil {
      return err
    } else if len(res) == 1 {
      return m.ErrProcessAlreadyAdded
    }
    entity := m.Process{
      OrgId:cmd.OrgId,
      ProcessId:cmd.ProcessId,
      ProcessName:cmd.ProcessName,
      ParentProcessName:cmd.ParentProcessName,
      Created:time.Now(),
      Updated:time.Now(),
      UpdatedBy:cmd.UpdatedBy,
    }
    _, err := sess.Insert(&entity)
    return err
  })

}

func GetProcess(query *m.GetProcessQuery) error {

  query.Result = make([]*m.ProcessDTO, 0)
  sess := x.Table("process")
  sess.Where("process.org_id=?", query.OrgId)
  sess.Cols("process.org_id","process.process_name","process.parent_process_name","process.updated_by")

  err := sess.Find(&query.Result)
  return err
}
/*func GetProcess(cmd *m.GetProcessQuery)  {
  return inTransaction2(func(sess *session) error {

    selects :=
      "SELECT * from IConSql.process where org_id=?"


    for _, sql := range selects {
      _, err := sess.Exec(sql, cmd.OrgId1)
      if err != nil {
        return err
      }
    }

    return nil
  })
  }
*/



