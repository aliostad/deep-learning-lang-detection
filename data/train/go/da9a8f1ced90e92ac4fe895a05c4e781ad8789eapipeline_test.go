package septum

import (
	"errors"
	"testing"
)

func TestNewPipeline(t *testing.T) {
	step := new(teststep)
	p := NewPipeline(step.Process)

	e := newTestEvent()
	err := p.Process(e)

	if err != step.processResult {
		t.Error("Pipeline.Process errored: ", err)
	}

	if 1 != step.processCalled {
		t.Error("Pipeline didn't process first step")
	}
}

func TestPipelineError(t *testing.T) {
	step1 := new(teststep)
	step1.processResult = errors.New("Error!")
	step2 := new(teststep)
	p := NewPipeline(step1.Process)
	p.Append(step2.Process)

	e := newTestEvent()
	err := p.Process(e)

	if err != step1.processResult {
		t.Error("Pipeline.Process returned unexpected error: ", err)
	}

	if 1 != step1.processCalled {
		t.Error("Pipeline didn't process first step")
	}

	if 0 != step2.processCalled {
		t.Error("Pipeline processed second step")
	}
}

func TestPipelineFilteredError(t *testing.T) {
	step1 := new(teststep)
	step1.filterResult = true
	step1.processResult = errors.New("Error!")

	step2 := new(teststep)
	step2.filterResult = true

	p := NewPipelineFiltered(step1.Filter, step1.Process)
	p.AppendFiltered(step2.Filter, step2.Process)

	e := newTestEvent()
	err := p.Process(e)

	if err != step1.processResult {
		t.Error("Pipeline.Process returned unexpected error: ", err)
	}

	if 1 != step1.filterCalled {
		t.Error("Pipeline didn't filter first step")
	}

	if 1 != step1.processCalled {
		t.Error("Pipeline didn't process first step")
	}

	if 0 != step2.filterCalled {
		t.Error("Pipeline called Filter for second step")
	}

	if 0 != step2.processCalled {
		t.Error("Pipeline called Process for second step")
	}
}

func TestNewFilteredPipeline(t *testing.T) {
	step := new(teststep)
	step.filterResult = false
	p := NewPipelineFiltered(step.Filter, step.Process)

	e := newTestEvent()
	err := p.Process(e)

	if err != nil {
		t.Error("Pipeline.Process errored: ", err)
	}

	if 1 != step.filterCalled {
		t.Error("Pipeline didn't filter first event")
	}

	if 0 != step.processCalled {
		t.Error("Pipeline didn't ignore first event")
	}

	step.filterResult = true
	err = p.Process(e)

	if 2 != step.filterCalled {
		t.Error("Pipeline didn't filter second event")
	}

	if 1 != step.processCalled {
		t.Error("Pipeline didn't process second event")
	}

	if err != step.processResult {
		t.Error("Pipeline.Process errored: ", err)
	}
}

type (
	teststep struct {
		filterCalled  int
		filterResult  bool
		processCalled int
		processResult error
	}
)

func (s *teststep) Filter(e *Event) bool {
	s.filterCalled += 1
	return s.filterResult
}

func (s *teststep) Process(e *Event) error {
	s.processCalled += 1
	return s.processResult
}
