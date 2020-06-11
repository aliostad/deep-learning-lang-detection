package tasks

import "fmt"

type Task struct {
	ID 	int
	Content string // task contents
	IsDone 	bool // whether task is finished, or not.
}

type TaskManager struct {
	Total int
	Tasks []Task
}

func NewTaskManager() *TaskManager {
	taskManager := new(TaskManager)
	taskManager.Total = 0
	taskManager.Tasks = make([]Task, 100)

	return taskManager
}

func GetTaskLen(manager *TaskManager) int {
	return manager.Total
}

func CreateTask(c string, manager *TaskManager) {
	if(manager.Total == 0) {
		manager.Tasks[0].ID = 0

	} else {
		manager.Tasks[manager.Total].ID = GetTaskLen(manager)
	}
	manager.Tasks[manager.Total].Content = c
	manager.Tasks[manager.Total].IsDone = false

	manager.Total += 1
}

func CloseTask(id int, manager *TaskManager) {
	task := GetTask(id, manager)
	task.IsDone = true
}

func GetTask(id int, manager *TaskManager) *Task {
	var t *Task

	for i := 0; i <= id; i++ {
		t = &manager.Tasks[i]
	}

	return t
}

func PrintTasks(manager *TaskManager) {
	for i := 0; i < manager.Total; i++ {
		if(!manager.Tasks[i].IsDone) {
			fmt.Println(manager.Tasks[i].ID, manager.Tasks[i].Content)
		}
	}
}
