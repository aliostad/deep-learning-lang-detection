package models

import (
  "time"

)

type SubProcess struct {
  OrgId    int64
  SubProcessId       int64
  SubProcessName     string
  ProcessName     string
  Created         time.Time
  Updated         time.Time
  UpdatedBy       string
}
// ---------------------
// COMMANDS
type AddSubProcessCommand struct {
  OrgId    int64            `json:"-"`

  SubProcessName     string    `json:"subProcessName" binding:"Required"`
  ProcessName     string        `json:"processName" `
  UpdatedBy       string      `json:"updatedBy" `

}
type CreateSubProcessCommand struct {
  OrgId    int64
  SubProcessId       int64
  SubProcessName     string
  ProcessName     string
  UpdatedBy       string
  Result *SubProcess

}
type DeleteSubProcessCommand struct {
  OrgId int64
  SubProcessId int64
}
type GetSubProcessCommand struct {
  OrgId int64
  SubProcessId int64

}

type UpdateOrgSubProcessCommand struct {

  SubProcessId int64           `json:"-"`
  SubProcessName     string    `json:"subProcessName" binding:"Required"`
  ProcessName     string        `json:"processName" `
  UpdatedBy       string      `json:"updatedBy" `
}
// Typed errors

// ----------------------
// QUERIES

type GetSubProcessQuery struct {
  OrgId    int64
  SubProcessId  int64
  Result []*SubProcessDTO
}

type GetSubProcessByIdQuery struct {

  SubProcessId     int64
  Result *SubProcess
}
type GetSubProcessByMainProcessQuery struct {

  ProcessName     string
  Result []*SubProcessDTO
}
type GetSubProcessByNameQuery struct {

  OrgId    int64
  SubProcessId  int64
  Result []*SubProcessDTO
}
type GetSubProcessByProcessNameQuery struct {

  OrgId    int64
  SubProcessId  int64
  Result []*SubProcessDTO
}
// ----------------------
// Projections and DTOs

type SubProcessUser struct {

  SubProcessId       int64
  SubProcessName     string
  ProcessName     string
  UpdatedBy       string
  Updated         time.Time
}
type GetSubProcessByCodeQuery struct {
  SubProcessId int64

  Result *SubProcessDTO
}


type SubProcessDTO struct {
  OrgId    int64            `json:"orgId"`
  SubProcessId       int64   `json:"subProcessId"`
  SubProcessName     string    `json:"subProcessName"`
  ProcessName     string        `json:"processName" `
  Created         time.Time   `json:"created"`
  Updated         time.Time   `json:"updated"`
  UpdatedBy       string      `json:"updatedBy"`


}

type SubProcessDetailDTO struct {

  SubProcessId       int64   `json:"subProcessId"`
  SubProcessName     string    `json:"subProcessName"`
  ProcessName     string        `json:"processName" `
  UpdatedBy       string      `json:"updatedBy"`


}
type GetSubProcessByOrgIdQuery  struct {
  SubProcessId int64
  Result *SubProcess

}

type GetSubProcessProfileQuery struct {
  SubProcessId int64
  Result SubProcessDTO
}

type UpdateSubProcessCommand struct {

  SubProcessId       int64   `json:"-"`
  SubProcessName     string    `json:"subProcessName"`
  ProcessName     string        `json:"processName" `
  UpdatedBy       string      `json:"updatedBy"`
}


