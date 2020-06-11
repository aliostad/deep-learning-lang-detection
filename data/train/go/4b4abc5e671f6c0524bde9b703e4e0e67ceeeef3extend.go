package main

import(
	"fmt"
)

type User struct{
	name string
	age byte
}

func (user User) ToString() string{
	return fmt.Sprintf("%+v",user)
}

func (user User) AddAge(){ //BugFix
	user.age ++ 
}

type Manager struct{
	User
	title string
}

func (manager Manager) AddAge() {
	manager.age = manager.age + 10
}

func main() {
	var user User
	var manager Manager

	user.name = "Tom"
	user.age = 30

	manager.name = "Jim"
	manager.age = 40
	manager.title = "CTO"

	fmt.Println(user.ToString())
	fmt.Println(manager.ToString())

	user.AddAge()
	manager.AddAge()

	fmt.Println(user.ToString())
	fmt.Println(manager.ToString())
}