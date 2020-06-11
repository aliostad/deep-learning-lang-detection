package task

import "fmt"

type Todo struct {
	ID    int64
	Title string
	Done  bool
}

func NewTodo(title string) (*Todo, error) {
	if title == "" {
		return nil, fmt.Errorf("Empty title")
	}
	return &Todo{0, title, false}, nil
}

type TodoManager struct {
	tasks  []*Todo
	lastID int64
}

func NewTodoManager() *TodoManager {
	return &TodoManager{}
}

func (todoManager *TodoManager) save(task *Todo) error {
	if task.ID == 0 {
		todoManager.lastID++
		task.ID = todoManager.lastID
		todoManager.tasks = append(todoManager.tasks, cloneTask(task))
		return nil
	}

	for i, t := range todoManager.tasks {
		if t.ID == task.ID {
			todoManager.tasks[i] = cloneTask(task)
			return nil
		}
	}
	return fmt.Errorf("Unknown task")
}

func (todoManager *TodoManager) GetAll() []*Todo {
	return todoManager.tasks
}

func (todoManager *TodoManager) Find(ID int64) (*Todo, bool) {
	for _, task := range todoManager.tasks {
		if task.ID == ID {
			return cloneTask(task), true
		}
	}
	return nil, false
}

func cloneTask(task *Todo) *Todo {
	copy := *task
	return &copy
}
