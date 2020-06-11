

package main


type Director interface {
  Context() Context
  ClassManager() *ClassManager
  UserManager() *UserManager
  Init()
}

type AbstractDirector struct {
  Director
  context Context
  classManager *ClassManager
  userManager *UserManager
}

func NewDirector(c Context) Director {
  d := new(AbstractDirector)
  d.context = c
  d.classManager = NewClassManager(d)
  d.userManager = NewUserManager(d)
  return d
}

func (d *AbstractDirector) Context() Context {
  return d.context
}

func (d *AbstractDirector) ClassManager() *ClassManager {
  return d.classManager
}

func (d *AbstractDirector) UserManager() *UserManager {
  return d.userManager
}

func (d *AbstractDirector) Init() {
  c := d.classManager
  u := d.userManager

	c.Facade().Register()
	u.Facade().Register()
}

