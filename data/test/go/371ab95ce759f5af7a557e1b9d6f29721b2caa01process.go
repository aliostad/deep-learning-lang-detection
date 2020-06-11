package models

import (
  "time"
  "errors"
)

type Process struct {
  OrgId    int64
  ProcessId       int64
  ProcessName     string
  ParentProcessName string
  Created         time.Time
  Updated         time.Time
  UpdatedBy       string
}
// ---------------------
// COMMANDS
type AddProcessCommand struct {
  OrgId    int64            `json:"-"`

  ProcessName     string    `json:"processName" binding:"Required"`
  ParentProcessName string     `json:"parentProcessName" `
  UpdatedBy       string      `json:"updatedBy" `


}
type CreateProcessCommand struct {
  OrgId    int64
  ProcessId       int64
  ProcessName     string
  ParentProcessName string
  UpdatedBy       string
  Result *Process

}
type DeleteProcessCommand struct {
  OrgId int64
  ProcessId int64
}
type GetProcessCommand struct {
  OrgId int64
  ProcessId int64
}
// Typed errors
var (

  ErrProcessAlreadyAdded = errors.New("User is already added to organization")
ErrOrgFound=errors.New("User is already added to oation")
)
// ----------------------
// QUERIES

type GetProcessQuery struct {
  OrgId    int64
  Result []*ProcessDTO
}


// ----------------------
// Projections and DTOs

type ProcessUser struct {

  ProcessId       int64
  ProcessName     string
  ParentProcessName string
  UpdatedBy       string
}


type ProcessDTO struct {
  OrgId    int64            `json:"orgId"`
  ProcessId       int64   `json:"processId"`
  ProcessName     string    `json:"processName"`
  ParentProcessName string     `json:"parentProcessName"`
  Created         time.Time   `json:"created"`
  Updated         time.Time   `json:"updated"`
  UpdatedBy       string      `json:"updatedBy"`


}

type GetProcessByOrgIdQuery  struct {
  OrgId    int64
  Result *Process

}
