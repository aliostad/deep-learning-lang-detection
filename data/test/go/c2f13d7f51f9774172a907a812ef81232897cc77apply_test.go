package middleware

import (
	"context"
	"github.com/nheyn/go-redux/store"
	"testing"
)

func TestApplyWillPassTheStoreToTheMiddleware(t *testing.T) {
	var mwStore *store.Store
	mwGen := func(s *store.Store) Func {
		mwStore = s
		return nil
	}

	testStore := store.New(store.State{}, Apply(mwGen))

	if mwStore != testStore {
		t.Error("The middleware did not recive the store it was applied to.")
	}
}

func TestApplyCallsMiddlewareWhenDispatchIsCalled(t *testing.T) {
	mwActions := []interface{}{}
	mwGen := func(_ *store.Store) Func {
		return func(ctx context.Context, action interface{}, next Next) error {
			mwActions = append(mwActions, action)

			return next(ctx, action)
		}
	}

	testStore := store.New(store.State{}, Apply(mwGen))

	testActions := []interface{}{
		"testAction0",
		"testAction1",
		"testAction2",
	}
	for _, testAction := range testActions {
		err := testStore.Dispatch(context.Background(), testAction)
		if err != nil {
			t.Fatal(err)
		}
	}

	if len(mwActions) != len(testActions) {
		t.Error("The middleware was called", len(mwActions), "times but should have been called", len(testActions), "times")
	}

	for i, mwAction := range mwActions {
		if mwAction != testActions[i] {
			t.Error("The", i, "call to Dispatch was given", mwAction, "but should have been given", testActions[i])
		}
	}
}

func TestWrapWillAddMiddlewareToPerformDispatch(t *testing.T) {
	var inMwAction interface{}
	outMwAction := "mw action"
	mw := func(ctx context.Context, action interface{}, next Next) error {
		inMwAction = action

		return next(ctx, outMwAction)
	}

	var dispatchAction interface{}
	initalDispatch := func(_ context.Context, s store.State, action interface{}) (store.State, error) {
		dispatchAction = action

		return s, nil
	}
	wrappedDispatch := wrapPerformDispatch(initalDispatch, mw)

	testAction := "initial action"
	_, err := wrappedDispatch(context.Background(), store.State{}, testAction)
	if err != nil {
		t.Fatal(err)
	}

	if inMwAction != testAction {
		t.Error("The middleware recived", inMwAction, "but it should have been", testAction)
	}

	if dispatchAction != outMwAction {
		t.Error("The initial dispatch function recived", dispatchAction, "but it should have been", outMwAction)
	}
}
