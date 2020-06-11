package main

import (
	"html/template"
	"path/filepath"
	"testing"
)

func TestNewWiki(t *testing.T) {
	if _, err := NewWiki("/Users/sevki/Code/go/src/sevki.org/dispatch/wiki/test"); err != nil {
		t.Error(err)
	}
}

func TestNewTemplates(t *testing.T) {
	path := "/Users/sevki/Code/go/src/sevki.org/dispatch/wiki/test"

	root := filepath.Join(path, "root.tmpl")
	parse := func(name string) (*template.Template, error) {
		t := template.New("").Funcs(funcMap)
		return t.ParseFiles(root, filepath.Join(path, name))
	}

	_, err := parse("home.tmpl")
	if err != nil {
		t.Error(err)
	}
}
