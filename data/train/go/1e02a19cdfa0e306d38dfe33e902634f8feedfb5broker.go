package broker

import (
	"context"
	"reflect"

	"github.com/cloudway/platform/auth"
	"github.com/cloudway/platform/auth/userdb"
	"github.com/cloudway/platform/container"
	"github.com/cloudway/platform/hub"
	"github.com/cloudway/platform/scm"

	// Load all plugings
	_ "github.com/cloudway/platform/auth/userdb/mongodb"
	_ "github.com/cloudway/platform/container/docker"
	_ "github.com/cloudway/platform/scm/bitbucket"
	_ "github.com/cloudway/platform/scm/mock"
)

// Broker maintains all external services.
type Broker struct {
	container.Engine
	Users *userdb.UserDatabase
	Authz *auth.Authenticator
	SCM   scm.SCM
	Hub   *hub.PluginHub
}

// UserBroker performs user specific operations.
type UserBroker struct {
	*Broker
	User userdb.User
	ctx  context.Context
}

func New(engine container.Engine) (broker *Broker, err error) {
	broker = new(Broker)
	broker.Engine = engine

	broker.Users, err = userdb.Open()
	if err != nil {
		return
	}

	broker.Authz, err = auth.NewAuthenticator(broker.Users)
	if err != nil {
		return
	}

	broker.SCM, err = scm.New()
	if err != nil {
		return
	}

	broker.Hub, err = hub.New()
	if err != nil {
		return
	}

	return broker, nil
}

func (br *Broker) NewUserBroker(user userdb.User, ctx context.Context) *UserBroker {
	return &UserBroker{
		Broker: br,
		User:   user,
		ctx:    ctx,
	}
}

func (br *UserBroker) Refresh() error {
	username := br.User.Basic().Name
	p := reflect.ValueOf(br.User).Elem()
	p.Set(reflect.Zero(p.Type()))
	return br.Users.Find(username, br.User)
}

func (br *UserBroker) Namespace() string {
	return br.User.Basic().Namespace
}
