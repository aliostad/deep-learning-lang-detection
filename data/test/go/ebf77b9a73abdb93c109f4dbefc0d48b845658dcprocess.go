package api

import (
  m "github.com/grafana/grafana/pkg/models"
  "github.com/grafana/grafana/pkg/bus"
  "github.com/grafana/grafana/pkg/middleware"

  "github.com/grafana/grafana/pkg/log"

  "github.com/grafana/grafana/pkg/api/dtos"
)

func addProcessHelper(cmd m.AddProcessCommand) Response {

  logger := log.New("main")
  logger.Info("Add ProcessForCurrentOrg111",cmd.OrgId)
  query:=m.AddProcessCommand{}

  query.OrgId=cmd.OrgId
  query.ProcessName=cmd.ProcessName
  query.UpdatedBy=cmd.UpdatedBy

  if err := bus.Dispatch(&query); err != nil {
    return ApiError(500, "Could not add process to organization", err)
  }


  return ApiSuccess("Process Sucessfully added ")

}

// POST /api/process
func AddProcessToCurrentOrg(c *middleware.Context, cmd m.AddProcessCommand) Response {

  logger := log.New("main")
  logger.Info("Add ProcessForCurrentOrg",c.OrgId)
  cmd.OrgId = c.OrgId

  return addProcessHelper(cmd)
}

// POST /api/process/:orgId
func AddProcess(c *middleware.Context, cmd m.AddProcessCommand) Response {
  cmd.OrgId = c.OrgId
  return addProcessParentHelper(cmd)
}
func addProcessParentHelper(cmd m.AddProcessCommand) Response {

  logger := log.New("main")
  logger.Info("Add ProcessForCurrentOrg111",cmd.OrgId)
  query:=m.AddProcessCommand{}

  query.OrgId=cmd.OrgId
  query.ProcessName=cmd.ProcessName
  query.UpdatedBy=cmd.UpdatedBy

  if err := bus.Dispatch(&query); err != nil {
    return ApiError(500, "Could not add process to organization", err)
  }


  return ApiSuccess("Process Sucessfully added ")

}
func getProcessHelper(OrgId int64) Response {

  query :=m.GetProcessQuery{OrgId:OrgId}
  if err := bus.Dispatch(&query); err != nil {
    return ApiError(500, "Failed to get Process ", err)
  }

  return Json(200, query.Result)

}
// GET /api/org/process
func GetProcessForCurrentOrg(c *middleware.Context) Response {
  logger := log.New("main")
  logger.Info("GetProcessForCurrentOrg12",c.OrgId)

  return getProcessHelper(c.OrgId)
}



// DELETE /api/org/users/:userId
func RemoveProcessCurrentOrg(c *middleware.Context) Response {
  processId := c.ParamsInt64(":processId")
  logger := log.New("main")
  logger.Info("Delete Process  %s")
  return removeOrgProcessHelper(c.OrgId, processId)
}

// DELETE /api/orgs/:orgId/users/:userId
func RemoveOrgProcess(c *middleware.Context) Response {
  logger := log.New("main")
  logger.Info("GetProcess",c.ParamsInt64(":process_id"))
  processId := c.ParamsInt64(":process_id")
  orgId := c.ParamsInt64(":orgId")
  return removeOrgProcessHelper(orgId, processId)
}

func removeOrgProcessHelper(orgId int64, processId int64) Response {
  logger := log.New("main")
  logger.Info("Delete Process 2 %s")
  cmd := m.DeleteProcessCommand{OrgId: orgId, ProcessId: processId}

  logger.Info("GetProcess456")
  if err := bus.Dispatch(&cmd); err != nil {
    if err == m.ErrLastOrgAdmin {
      return ApiError(400, "Cannot remove last organization admin", nil)
    }
    return ApiError(500, "Failed to remove Process from organization", err)
  }

  return ApiSuccess("Process removed from organization")
}


func GetProcessById(c *middleware.Context) Response {
  logger := log.New("main")
  logger.Info("GetProcess123 %s")
  processId:=c.ParamsInt64(":processId")
  logger.Info("GetProcess123 %s",processId)
  return getProcessUserProfile(processId)
}
func getProcessUserProfile(processId int64) Response {
  query := m.GetProcessByIdQuery{ProcessId:processId}
  logger := log.New("main")
  logger.Info("GetProcess456 %s")
  if err := bus.Dispatch(&query); err != nil {
    return ApiError(500, "Failed to get Process", err)
  }
  process := query.Result
  result := m.ProcessDetailDTO{
    ProcessId:   process.ProcessId,
    ProcessName: process.ProcessName,
    UpdatedBy:process.UpdatedBy,
  }
  return Json(200, &result)
}


func UpdateOrgProcessForCurrentOrg(c *middleware.Context, cmd m.UpdateOrgProcessCommand) Response {

  cmd.ProcessId = c.ParamsInt64(":processId")
  logger := log.New("main")
  logger.Info("updatedProcess1 %s",)
  return updateOrgProcessHelper(cmd)
}
func updateOrgProcessHelper(cmd m.UpdateOrgProcessCommand) Response {
  logger := log.New("main")
  logger.Info("updatedProcess2 %s")

  if err := bus.Dispatch(&cmd); err != nil {

    return ApiError(500, "Failed update org Process", err)
  }

  return ApiSuccess("Organization Process updated")
}

// PUT /api/orgs/:orgId
func UpdateProcess(c *middleware.Context, form dtos.UpdateProcessForm) Response {

  processId := c.ParamsInt64(":processId")
  return updateProcessHelper( processId,form)
}

func updateProcessHelper(processId int64,form dtos.UpdateProcessForm) Response {
  logger := log.New("main")
  logger.Info("updatedProcess1 %s")
  cmd := m.UpdateProcessCommand{ProcessId:processId,ProcessName: form.ProcessName, UpdatedBy:form.UpdatedBy}

  logger.Info("updatedProcess2 %s")
  if err := bus.Dispatch(&cmd); err != nil {
    if err == m.ErrOrgNameTaken {
      return ApiError(400, "Organization name taken", err)
    }
    return ApiError(500, "Failed to update Process organization", err)
  }

  return ApiSuccess(" Successful Process updated")
}
//gekljf


func GetProcessByParentName(c *middleware.Context) Response {
  logger := log.New("main")
  logger.Info("GetProcess123 %s")
  return getParentProcessUserProfile(c.OrgId)
}
func getParentProcessUserProfile(OrgId int64) Response {

  query :=m.GetProcessByNameQuery{OrgId:OrgId}
  if err := bus.Dispatch(&query); err != nil {
    return ApiError(500, "Failed to get Process", err)
  }

  return Json(200, query.Result)

}
func GetProcessByProcessName(c *middleware.Context) Response {
  logger := log.New("main")
  logger.Info("GetProcess123 %s")
  return getProcessProfile(c.OrgId)
}
func getProcessProfile(OrgId int64) Response {

  query :=m.GetProcessByProcessNameQuery{OrgId:OrgId}
  if err := bus.Dispatch(&query); err != nil {
    return ApiError(500, "Failed to get Process", err)
  }

  return Json(200, query.Result)

}
