// Restish Dispatch tests
package restish

import (
	"github.com/llewekam/assertion"
	"testing"
)

// Verify Request dispatches to the Create() function and response is OK
func TestRequestCreate(test *testing.T) {
	var resource *Resource
	var status StatusCode
	var dispatch *Dispatch
	var stubController *ControllerStub

	assert := assertion.Assertion{test}
	resource = NewResource("/url")

	// Verify we dispatch to Create
	stubController = &ControllerStub{assertion.NewStub()}
	dispatch = NewDispatch(stubController)
	resource, status = dispatch.Request(resource, ActionCreate)

	assert.AssertEqual(StatusTeapot, status, "Status is not StatusTeapot")
	assert.AssertStubCall(stubController, "Create", 1)
	assert.AssertStubCall(stubController, "Read", 0)
	assert.AssertStubCall(stubController, "Update", 0)
	assert.AssertStubCall(stubController, "Delete", 0)
}

// Verify Request dispatches to the Read() function and response is OK
func TestRequestRead(test *testing.T) {
	var resource *Resource
	var status StatusCode
	var dispatch *Dispatch
	var stubController *ControllerStub

	assert := assertion.Assertion{test}
	resource = NewResource("/url")

	// Verify we dispatch to Read
	stubController = &ControllerStub{assertion.NewStub()}
	dispatch = NewDispatch(stubController)
	resource, status = dispatch.Request(resource, ActionRead)

	assert.AssertEqual(StatusTeapot, status, "Status is not StatusTeapot")
	assert.AssertStubCall(stubController, "Create", 0)
	assert.AssertStubCall(stubController, "Read", 1)
	assert.AssertStubCall(stubController, "Update", 0)
	assert.AssertStubCall(stubController, "Delete", 0)
}

// Verify Request dispatches to the Update() function and response is OK
func TestRequestUpdate(test *testing.T) {
	var resource *Resource
	var status StatusCode
	var dispatch *Dispatch
	var stubController *ControllerStub

	assert := assertion.Assertion{test}
	resource = NewResource("/url")

	// Verify we dispatch to Update
	stubController = &ControllerStub{assertion.NewStub()}
	dispatch = NewDispatch(stubController)
	resource, status = dispatch.Request(resource, ActionUpdate)

	assert.AssertEqual(StatusTeapot, status, "Status is not StatusTeapot")
	assert.AssertStubCall(stubController, "Create", 0)
	assert.AssertStubCall(stubController, "Read", 0)
	assert.AssertStubCall(stubController, "Update", 1)
	assert.AssertStubCall(stubController, "Delete", 0)
}

// Verify Request dispatches to the Create() function and response is OK
func TestRequestDelete(test *testing.T) {
	var resource *Resource
	var status StatusCode
	var dispatch *Dispatch
	var stubController *ControllerStub

	assert := assertion.Assertion{test}
	resource = NewResource("/url")

	// Verify we dispatch to Delete
	stubController = &ControllerStub{assertion.NewStub()}
	dispatch = NewDispatch(stubController)
	resource, status = dispatch.Request(resource, ActionDelete)

	assert.AssertEqual(StatusTeapot, status, "Status is not StatusTeapot")
	assert.AssertStubCall(stubController, "Create", 0)
	assert.AssertStubCall(stubController, "Read", 0)
	assert.AssertStubCall(stubController, "Update", 0)
	assert.AssertStubCall(stubController, "Delete", 1)
}
