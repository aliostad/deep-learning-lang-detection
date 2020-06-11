package cord

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

type mockHandler struct {
	mock.Mock
}

func (m *mockHandler) Name() string {
	return "hello"
}

func (m *mockHandler) Invoke(b []byte) error {
	return m.Called(b).Error(0)
}

func TestHandlerCallsOn(t *testing.T) {
	e := newEmitter()
	h := &mockHandler{}
	e.On(h)

	h.On("Invoke", []byte{1, 2, 3}).Return(nil)
	assert.Nil(t, e.Dispatch("hello", []byte{1, 2, 3}))
	assert.Nil(t, e.Dispatch("goodbye", []byte{4, 5, 6}))
	h.AssertExpectations(t)
}

func TestHandlerCallsOnOnce(t *testing.T) {
	e := newEmitter()
	h := &mockHandler{}
	e.Once(h)

	h.On("Invoke", []byte{1, 2, 3}).Return(nil)
	assert.Nil(t, e.Dispatch("hello", []byte{1, 2, 3}))
	assert.Nil(t, e.Dispatch("hello", []byte{4, 5, 6}))
	h.AssertExpectations(t)
}

func TestHandlerBubblesError(t *testing.T) {
	e := newEmitter()
	h := &mockHandler{}
	e.Once(h)

	h.On("Invoke", []byte{1, 2, 3}).Return(nil)
	assert.Nil(t, e.Dispatch("hello", []byte{1, 2, 3}))
	assert.Nil(t, e.Dispatch("hello", []byte{4, 5, 6}))
	h.AssertExpectations(t)
}

func TestHandlerRemoves(t *testing.T) {
	e := newEmitter()
	h := &mockHandler{}
	e.On(h)
	e.Off(h)

	assert.Nil(t, e.Dispatch("hello", []byte{1, 2, 3}))
	h.AssertExpectations(t)
}
