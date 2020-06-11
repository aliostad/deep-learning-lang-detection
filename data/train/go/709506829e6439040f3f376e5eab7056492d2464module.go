package log

import (
	"fmt"
	"time"
)

var Targets = map[string]Handler{}

// Module is a basic Log, with an attached tag and context
type Module struct {
	tag string
	ctx Context
}

func New(tag string, ctx Context) Log {
	return &Module{
		tag: tag,
		ctx: ctx,
	}
}

func (m *Module) Dispatch(lvl Level, msg string) {
	record := record{
		when: time.Now(),
		lvl:  lvl,
		tag:  m.tag,
		msg:  msg,
		ctx:  m.ctx,
	}

	for _, handler := range Targets {
		handler.Handle(record)
	}
}

func (m *Module) Tag() string {
	return m.tag
}

func (m *Module) Ctx() Context {
	return m.ctx
}

func (m *Module) Info(format string, args ...interface{}) {
	msg := fmt.Sprintf(format, args...)
	m.Dispatch(LvlInfo, msg)
}

func (m *Module) Error(format string, args ...interface{}) {
	msg := fmt.Sprintf(format, args...)
	m.Dispatch(LvlError, msg)
}

func (m *Module) Debug(format string, args ...interface{}) {
	msg := fmt.Sprintf(format, args...)
	m.Dispatch(LvlDebug, msg)
}

func (m *Module) Notice(format string, args ...interface{}) {
	msg := fmt.Sprintf(format, args...)
	m.Dispatch(LvlNotice, msg)
}

func (m *Module) Child(tag string, ctx Context) Log {
	if ctx == nil {
		ctx = m.ctx
	}
	return New(m.tag+"/"+tag, ctx)
}
