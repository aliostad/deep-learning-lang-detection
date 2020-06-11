package task

import "fmt"

type Task struct {
	ID    int64
	Title string
	Done  bool
}

func NewTask(title string) (*Task, error) {
	if title == "" {
		return nil, fmt.Errorf("Empty title")
	}
	return &Task{0, title, false}, nil
}

type TaskManager struct {
	tasks  []*Task
	lastID int64
}

func NewTaskManager() *TaskManager {
	return &TaskManager{}
}

func (taskManager *TaskManager) Save(task *Task) error {
	if task.ID == 0 {
		taskManager.lastID++
		task.ID = taskManager.lastID
		taskManager.tasks = append(taskManager.tasks, cloneTask(task))
		return nil
	}

	for i, t := range taskManager.tasks {
		if t.ID == task.ID {
			taskManager.tasks[i] = cloneTask(task)
			return nil
		}
	}
	return fmt.Errorf("Unknown task")
}

func (taskManager *TaskManager) GetAll() []*Task {
	return taskManager.tasks
}

func (taskManager *TaskManager) Find(ID int64) (*Task, bool) {
	for _, task := range taskManager.tasks {
		if task.ID == ID {
			return cloneTask(task), true
		}
	}
	return nil, false
}

func cloneTask(task *Task) *Task {
	copy := *task
	return &copy
}
