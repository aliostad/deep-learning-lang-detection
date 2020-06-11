package controllers

import (
	"fmt"
    // "time"
	"log"
	// "net/http"
	// "strconv"
	// "strings"
	// "regexp"

	"github.com/coopernurse/gorp"
	// "github.com/go-martini/martini"
	// "github.com/martini-contrib/render"
	// "github.com/martini-contrib/sessions"
	//"github.com/martini-contrib/binding"

	// "config"
	model "models"
	// utils "utils"
)

func CreateTodoProcess(db *gorp.DbMap, todo *model.Todo, user *model.User, agent string) error {
    process := model.Process{}
    process.TodoID = todo.ID
    process.CreatorID = user.ID
    process.Action = 1
    process.UserAgent = agent
    process.Content = fmt.Sprintf("%d", todo.ID)
    log.Printf("Todo process: %s", todo.String())

    return db.Insert(&process);
}

func UpdateTodoProcess(db *gorp.DbMap, todo *model.Todo, user *model.User, content string, agent string) error {
    process := model.Process{}
    process.TodoID = todo.ID
    process.CreatorID = user.ID
    process.Content = content
    process.Action = 7
    process.UserAgent = agent
    log.Printf("Todo process: %s", todo.String())

    return db.Insert(&process);
}

func ModifyPriorityProcess(db *gorp.DbMap, todo *model.Todo, user *model.User, priority int8, agent string) error {
    process := model.Process{}
    process.TodoID = todo.ID
    process.CreatorID = user.ID
    process.Content = fmt.Sprintf("%d", priority)
    process.Action = 6
    process.UserAgent = agent
    log.Printf("Todo process: %s", todo.String())

    return db.Insert(&process);
}

func ModifyLimitProcess(db *gorp.DbMap, todo *model.Todo, user *model.User, limit int64, agent string) error {
    process := model.Process{}
    process.TodoID = todo.ID
    process.CreatorID = user.ID
    process.Content = fmt.Sprintf("%d", limit)
    process.Action = 5
    process.UserAgent = agent
    log.Printf("Todo process: %s", todo.String())

    return db.Insert(&process);
}

func AddPartnerProcess(db *gorp.DbMap, todo *model.Todo, user *model.User, pid int, agent string) error {
    process := model.Process{}
    process.TodoID = todo.ID
    process.CreatorID = user.ID
    process.Content = fmt.Sprintf("%d", pid)
    process.Action = 2
    process.UserAgent = agent
    log.Printf("Todo process: %s", todo.String())

    return db.Insert(&process);
}

