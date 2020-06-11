package whitetree_test

import (
	"errors"
	"testing"

	"github.com/bcho/whitetree"
)

func TestDispatchDefault(t *testing.T) {
	handlerRvChan := make(chan whitetree.TaskContext, 1)
	task := whitetree.NewTaskContext([]byte("dispatch_test"))
	parsers := whitetree.ParserPackage{
		"foo": fooParser,
	}
	handlers := whitetree.HandlerPackage{
		"foo": makeFooHandler(handlerRvChan),
	}

	if err := whitetree.Dispatch(*task, parsers, handlers); err != nil {
		t.Error(err)
	}
	rv := <-handlerRvChan
	if string(rv.Data) != string(task.Data) {
		t.Errorf("wrong handler execute result: %q", rv)
	}
}

func TestDispatchShouldReturnHandlerNotFound(t *testing.T) {
	task := whitetree.NewTaskContext([]byte("dispatch_test"))
	parsers := whitetree.ParserPackage{}
	handlers := whitetree.HandlerPackage{
		"foo": nil,
	}

	err := whitetree.Dispatch(*task, parsers, handlers)
	if err != whitetree.ErrHandlerNotFound {
		t.Errorf("should return ErrHandlerNotFound: %q", err)
	}
}

func TestDispatchShouldReturnParserError(t *testing.T) {
	task := whitetree.NewTaskContext([]byte("dispatch_test"))

	testErr := errors.New("test error")
	errParser := func(whitetree.TaskContext) (whitetree.HandlerId, error) {
		return "", testErr
	}

	parsers := whitetree.ParserPackage{
		"foo": errParser,
	}
	handlers := whitetree.HandlerPackage{}

	err := whitetree.Dispatch(*task, parsers, handlers)
	if err != testErr {
		t.Errorf("should return parser's error: %q", err)
	}
}

func TestDispatchShouldReturnHandlerError(t *testing.T) {
	task := whitetree.NewTaskContext([]byte("dispatch_test"))
	parsers := whitetree.ParserPackage{
		"foo": fooParser,
	}

	testErr := errors.New("test error")
	errHandler := func(whitetree.TaskContext) error {
		return testErr
	}

	handlers := whitetree.HandlerPackage{
		"foo": errHandler,
	}

	err := whitetree.Dispatch(*task, parsers, handlers)
	if err != testErr {
		t.Errorf("should return handler's error: %q", err)
	}
}

func fooParser(whitetree.TaskContext) (whitetree.HandlerId, error) {
	return "foo", nil
}

func makeFooHandler(rv chan whitetree.TaskContext) whitetree.Handler {
	return func(t whitetree.TaskContext) error {
		rv <- t
		return nil
	}
}
