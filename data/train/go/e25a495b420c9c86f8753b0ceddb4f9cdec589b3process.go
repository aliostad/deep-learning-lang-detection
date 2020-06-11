package api

import (
  m "github.com/grafana/grafana/pkg/models"
  "github.com/grafana/grafana/pkg/bus"
  "github.com/grafana/grafana/pkg/middleware"

  "github.com/grafana/grafana/pkg/log"
)

func addProcessHelper(cmd m.AddProcessCommand) Response {

  userQuery := m.GetProcessByProcessIdQuery{OrgId:cmd.OrgId}
  err := bus.Dispatch(&userQuery)
  if err != nil {
    return ApiError(404, "organization not found", nil)
  }
  processToAdd:=userQuery.Result

  cmd.OrgId=processToAdd.OrgId
  if err := bus.Dispatch(&cmd); err != nil {
    return ApiError(500, "Could not add Process", err)
  }

  return ApiSuccess("Process Sucessfully added ")

}

// POST /api/process
func AddProcessToCurrentOrg(c *middleware.Context, cmd m.AddProcessCommand) Response {
  cmd.OrgId = c.OrgId
  return addProcessHelper(cmd)
}

// POST /api/process/:orgId
func AddProcess(c *middleware.Context, cmd m.AddProcessCommand) Response {
  cmd.OrgId = c.ParamsInt64(":orgId")
  return addProcessHelper(cmd)
}

func getProcessHelper(OrgId int64) Response {

  query :=m.GetProcessQuery{OrgId:OrgId}
  if err := bus.Dispatch(&query); err != nil {
    return ApiError(500, "Failed to get Process1", err)
  }

  return Json(200, query.Result)

}
// GET /api/org/process
func GetProcessForCurrentOrg(c *middleware.Context) Response {
  logger := log.New("main")
  logger.Info("GetProcessForCurrentOrg",c.OrgId)

  return getProcessHelper(c.OrgId)
}

// GET /api/orgs/:orgId/process
func GetProcess(c *middleware.Context) Response {
  logger := log.New("main")
  logger.Info("GetProcess",c.ParamsInt64(":orgId"))
  return getProcessHelper(c.ParamsInt64(":orgId"))

}
