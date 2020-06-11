package gotemp

import (
	"container/list"
	"fmt"
	"text/template"
)

type Template struct {
	Name, Description, Data                 string
	Inputs, InputDependencies, Dependencies []string
}

type TemplateLoader interface {
	LoadTemplate(name string) (Template, error)
}

func LoadTemplates(name string, loader TemplateLoader) (*template.Template, error) {
	load_tracker := map[string]bool{name: true}
	var load_queue list.List
	load_queue.Init()
	load_queue.PushBack(name)

	t := template.New(name).Funcs(builtins)
	for e := load_queue.Front(); e != nil; e = e.Next() {
		template_name := e.Value.(string)
		new_template, err := loader.LoadTemplate(template_name)
		if err != nil {
			return nil, err
		}

		if _, err := t.Parse(new_template.Data); err != nil {
			return nil, err
		}

		if t.Lookup(template_name) == nil {
			return nil, fmt.Errorf(`template "%s"load failed.`, template_name)
		}

		for _, new_name := range new_template.Dependencies {
			if !load_tracker[new_name] {
				load_tracker[new_name] = true
				load_queue.PushBack(new_name)
			}
		}
	}

	return t, nil
}

func loadInputTemplate(name string, loader TemplateLoader) (Template, error) {
	t, err := loader.LoadTemplate(name)
	if err != nil {
		return Template{}, nil
	}

	load_tracker := map[string]bool{name: true}
	var load_queue list.List
	for _, new_name := range t.InputDependencies {
		if !load_tracker[new_name] {
			load_tracker[new_name] = true
			load_queue.PushBack(new_name)
		}
	}

	for e := load_queue.Front(); e != nil; e = e.Next() {
		template_name := e.Value.(string)
		new_template, err := loader.LoadTemplate(template_name)

		if err != nil {
			return Template{}, err
		}

		t.Inputs = append(t.Inputs, new_template.Inputs...)
		for _, new_name := range new_template.InputDependencies {
			if !load_tracker[new_name] {
				load_tracker[new_name] = true
				load_queue.PushBack(new_name)
			}
		}
	}

	return t, nil
}
