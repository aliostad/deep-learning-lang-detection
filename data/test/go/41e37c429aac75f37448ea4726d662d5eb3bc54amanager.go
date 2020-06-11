package httpsession

import (
	"net/http"
	"sync"
	"time"
)

const (
	DefaultMaxAge = 30 * time.Minute
)

type Manager struct {
	store                  Store
	maxAge                 time.Duration
	Path                   string
	generator              IdGenerator
	transfer               Transfer
	beforeReleaseListeners map[BeforeReleaseListener]bool
	afterCreatedListeners  map[AfterCreatedListener]bool
	lock                   sync.Mutex
}

func Default() *Manager {
	store := NewMemoryStore(DefaultMaxAge)
	key := string(GenRandKey(16))
	return NewManager(store,
		NewSha1Generator(key),
		NewCookieTransfer("SESSIONID", DefaultMaxAge, false, "/"))
}

func NewManager(store Store, gen IdGenerator, transfer Transfer) *Manager {
	return &Manager{
		store:     store,
		generator: gen,
		transfer:  transfer,
	}
}

func (manager *Manager) SetMaxAge(maxAge time.Duration) {
	manager.maxAge = maxAge
	manager.transfer.SetMaxAge(maxAge)
	manager.store.SetMaxAge(maxAge)
}

func (manager *Manager) Session(req *http.Request, rw http.ResponseWriter) *Session {
	manager.lock.Lock()
	defer manager.lock.Unlock()

	id, err := manager.transfer.Get(req)
	if err != nil {
		// TODO:
		println("error:", err.Error())
		return nil
	}

	if !manager.generator.IsValid(id) {
		id = manager.generator.Gen(req)
		manager.transfer.Set(req, rw, id)
		manager.store.Add(id)

		session := NewSession(id, manager.maxAge, manager)
		// is exist?
		manager.afterCreated(session)
		return session
	}
	return NewSession(id, manager.maxAge, manager)
}

func (manager *Manager) Invalidate(rw http.ResponseWriter, session *Session) {
	manager.beforeReleased(session)
	manager.store.Clear(session.id)
	manager.transfer.Clear(rw)
}

func (manager *Manager) afterCreated(session *Session) {
	for listener, _ := range manager.afterCreatedListeners {
		listener.OnAfterCreated(session)
	}
}

func (manager *Manager) beforeReleased(session *Session) {
	for listener, _ := range manager.beforeReleaseListeners {
		listener.OnBeforeRelease(session)
	}
}

func (manager *Manager) Run() error {
	return manager.store.Run()
}
