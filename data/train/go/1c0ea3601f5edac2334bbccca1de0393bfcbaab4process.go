package models

import (
  "time"
  "errors"
)

type Process struct {
  OrgId    int64
  ProcessId       int64
  ProcessName     string
  Created         time.Time
  Updated         time.Time
  UpdatedBy       string
}
// ---------------------
// COMMANDS
type AddProcessCommand struct {
  OrgId    int64            `json:"-"`

  ProcessName     string    `json:"processName" binding:"Required"`
  UpdatedBy       string      `json:"updatedBy" `

}
type CreateProcessCommand struct {
  OrgId    int64
  ProcessId       int64
  ProcessName     string
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

type UpdateOrgProcessCommand struct {

  ProcessId int64           `json:"-"`
  ProcessName     string    `json:"processName" binding:"Required"`
  UpdatedBy       string      `json:"updatedBy" `
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
  ProcessId  int64
  Result []*ProcessDTO
}

type GetProcessByIdQuery struct {

  ProcessId     int64
  Result *Process
}

type GetProcessByNameQuery struct {

  OrgId    int64
  ProcessId  int64
  Result []*ProcessDTO
}
type GetProcessByProcessNameQuery struct {

  OrgId    int64
  ProcessId  int64
  Result []*ProcessDTO
}
// ----------------------
// Projections and DTOs

type ProcessUser struct {

  ProcessId       int64
  ProcessName     string
  UpdatedBy       string
  Updated         time.Time
}
type GetProcessByCodeQuery struct {
  ProcessId int64

  Result *ProcessDTO
}


type ProcessDTO struct {
  OrgId    int64            `json:"orgId"`
  ProcessId       int64   `json:"processId"`
  ProcessName     string    `json:"processName"`
  Created         time.Time   `json:"created"`
  Updated         time.Time   `json:"updated"`
  UpdatedBy       string      `json:"updatedBy"`


}

type ProcessDetailDTO struct {

  ProcessId       int64   `json:"processId"`
  ProcessName     string    `json:"processName"`
  UpdatedBy       string      `json:"updatedBy"`


}
type GetProcessByOrgIdQuery  struct {
  ProcessId int64
  Result *Process

}

type GetProcessProfileQuery struct {
  ProcessId int64
  Result ProcessDTO
}

type UpdateProcessCommand struct {

  ProcessId       int64   `json:"-"`
  ProcessName     string    `json:"processName"`
  UpdatedBy       string      `json:"updatedBy"`
}


