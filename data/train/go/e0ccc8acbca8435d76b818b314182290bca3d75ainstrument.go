package client

import "time"

const (
	labelRepo      = "client"
	labelRepoToken = "token"
)

type countFunc func(store, repo, op string)
type observeFunc func(store, repo, op string, begin time.Time)

type instrumentRepo struct {
	errCount  countFunc
	opCount   countFunc
	opObserve observeFunc
	next      Repo
	store     string
}

// NewRepoInstrumentMiddleware wraps the next Repo with Prometheus
// instrumenation capabilities.
func NewRepoInstrumentMiddleware(
	errCount countFunc,
	opCount countFunc,
	opObserve observeFunc,
	store string,
) RepoMiddleware {
	return func(next Repo) Repo {
		return &instrumentRepo{
			errCount:  errCount,
			next:      next,
			opCount:   opCount,
			opObserve: opObserve,
			store:     store,
		}
	}
}

func (r *instrumentRepo) Lookup(id string) (client Client, err error) {
	defer func(begin time.Time) {
		r.track(begin, err, "Lookup")
	}(time.Now())

	return r.next.Lookup(id)
}

func (r *instrumentRepo) Store(id, name string) (client Client, err error) {
	defer func(begin time.Time) {
		r.track(begin, err, "Store")
	}(time.Now())

	return r.next.Store(id, name)
}

func (r *instrumentRepo) setup() (err error) {
	defer func(begin time.Time) {
		r.track(begin, err, "setup")
	}(time.Now())

	return r.next.setup()
}

func (r *instrumentRepo) teardown() (err error) {
	defer func(begin time.Time) {
		r.track(begin, err, "teardown")
	}(time.Now())

	return r.next.teardown()
}

func (r *instrumentRepo) track(begin time.Time, err error, op string) {
	if err != nil {
		r.errCount(r.store, labelRepo, op)
	}

	r.opCount(r.store, labelRepo, op)
	r.opObserve(r.store, labelRepo, op, begin)
}

type instrumentTokenRepo struct {
	errCount  countFunc
	opCount   countFunc
	opObserve observeFunc
	next      TokenRepo
	store     string
}

// NewTokenRepoInstrumentMiddleware wraps the next TokenRepo with Prometheus
// instrumenation capabilities.
func NewTokenRepoInstrumentMiddleware(
	errCount countFunc,
	opCount countFunc,
	opObserve observeFunc,
	store string,
) TokenRepoMiddleware {
	return func(next TokenRepo) TokenRepo {
		return &instrumentTokenRepo{
			errCount:  errCount,
			next:      next,
			opCount:   opCount,
			opObserve: opObserve,
			store:     store,
		}
	}
}

func (r *instrumentTokenRepo) Lookup(secret string) (token Token, err error) {
	defer func(begin time.Time) {
		r.track(begin, err, "Lookup")
	}(time.Now())

	return r.next.Lookup(secret)
}

func (r *instrumentTokenRepo) Store(clientID, secret string) (token Token, err error) {
	defer func(begin time.Time) {
		r.track(begin, err, "Store")
	}(time.Now())

	return r.next.Store(clientID, secret)
}

func (r *instrumentTokenRepo) setup() (err error) {
	defer func(begin time.Time) {
		r.track(begin, err, "setup")
	}(time.Now())

	return r.next.setup()
}

func (r *instrumentTokenRepo) teardown() (err error) {
	defer func(begin time.Time) {
		r.track(begin, err, "teardown")
	}(time.Now())

	return r.next.teardown()
}

func (r *instrumentTokenRepo) track(begin time.Time, err error, op string) {
	if err != nil {
		r.errCount(r.store, labelRepoToken, op)
	}

	r.opCount(r.store, labelRepoToken, op)
	r.opObserve(r.store, labelRepoToken, op, begin)
}
