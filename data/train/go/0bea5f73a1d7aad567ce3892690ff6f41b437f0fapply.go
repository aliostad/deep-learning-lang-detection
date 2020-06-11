package middleware

import (
	"context"
	"github.com/nheyn/go-redux/store"
)

// Apply returns the configuration function that can be passed store.New(...). It will wrap the Store's
// .PerformDispatch function with the given middleware.
// Ex)
//	someMiddleware := func(s *Store) middleware.Func {
//		return func(ctx context.Context, action interface{}, next middleware.Next) error {
//			// ...middleware code goes here...
//
//			return next(ctx, action)
//		}
//	}
func Apply(mwGens ...func(s *store.Store) Func) func(*store.Store) {
	return func(s *store.Store) {
		mws := make([]Func, 0, len(mwGens))
		for _, mwFunc := range mwGens {
			mw := mwFunc(s)
			mws = append(mws, mw)
		}

		initialPerformDispatch := s.PerformDispatch
		s.PerformDispatch = wrapPerformDispatch(initialPerformDispatch, mws...)
	}
}

// Wraps the call to the given dispatch func with the given middleware.
func wrapPerformDispatch(dispatch store.PerformDispatch, mws ...Func) store.PerformDispatch {
	mw := composeFuncs(mws...)

	return func(initialCtx context.Context, st store.State, initialAction interface{}) (store.State, error) {
		updatedSt := store.State{}
		err := mw(initialCtx, initialAction, createBaseNext(dispatch, st, &updatedSt))
		if err != nil {
			return nil, err
		}

		return updatedSt, nil
	}
}
