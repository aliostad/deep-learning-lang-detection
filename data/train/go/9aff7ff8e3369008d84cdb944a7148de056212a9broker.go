// Copyleft (ɔ) 2017 The Caliopen contributors.
// Use of this source code is governed by a GNU AFFERO GENERAL PUBLIC
// license (AGPL) that can be found in the LICENSE file.

// package email_broker handles codec/decodec between external emails and Caliopen message format
package email_broker

import (
	"errors"
	obj "github.com/CaliOpen/Caliopen/src/backend/defs/go-objects"
	"github.com/CaliOpen/Caliopen/src/backend/main/go.backends"
	"github.com/CaliOpen/Caliopen/src/backend/main/go.backends/index/elasticsearch"
	"github.com/CaliOpen/Caliopen/src/backend/main/go.backends/store/cassandra"
	log "github.com/Sirupsen/logrus"
	"github.com/gocql/gocql"
	"github.com/nats-io/go-nats"
)

type (
	EmailBroker struct {
		Store             backends.LDAStore
		Index             backends.LDAIndex
		NatsConn          *nats.Conn
		Connectors        EmailBrokerConnectors
		Config            LDAConfig
		natsSubscriptions []*nats.Subscription
	}

	EmailBrokerConnectors struct {
		IncomingSmtp  chan *SmtpEmail
		OutcomingSmtp chan *SmtpEmail
	}

	SmtpEmail struct {
		EmailMessage *obj.EmailMessage
		Response     chan *DeliveryAck
	}

	natsOrder struct {
		Order     string `json:"order"`
		MessageId string `json:"message_id"`
		UserId    string `json:"user_id"`
	}

	natsAck struct {
		Error   string `json:"error,omitempty"`
		Message string `json:"message"`
	}

	DeliveryAck struct {
		EmailMessage *obj.EmailMessage `json:"-"`
		Err          bool              `json:"error"`
		Response     string            `json:"message,omitempty"`
	}
)

var (
	broker *EmailBroker
)

func Initialize(conf LDAConfig) (broker *EmailBroker, connectors EmailBrokerConnectors, err error) {
	var e error
	broker = &EmailBroker{}
	broker.Config = conf
	switch conf.StoreName {
	case "cassandra":
		c := store.CassandraConfig{
			Hosts:       conf.StoreConfig.Hosts,
			Keyspace:    conf.StoreConfig.Keyspace,
			Consistency: gocql.Consistency(conf.StoreConfig.Consistency),
			SizeLimit:   conf.StoreConfig.SizeLimit,
		}
		if conf.StoreConfig.ObjectStore == "s3" {
			c.WithObjStore = true
			c.Endpoint = conf.StoreConfig.OSSConfig.Endpoint
			c.AccessKey = conf.StoreConfig.OSSConfig.AccessKey
			c.SecretKey = conf.StoreConfig.OSSConfig.SecretKey
			c.RawMsgBucket = conf.StoreConfig.OSSConfig.Buckets["raw_messages"]
			c.AttachmentBucket = conf.StoreConfig.OSSConfig.Buckets["temporary_attachments"]
			c.Location = conf.StoreConfig.OSSConfig.Location
		}
		b, e := store.InitializeCassandraBackend(c)
		if e != nil {
			err = e
			log.WithError(err).Warnf("EmailBroker : initalization of %s backend failed", conf.StoreName)
			return
		}

		broker.Store = backends.LDAStore(b) // type conversion to LDA interface
	case "BOBcassandra":
	// NotImplemented… yet ! ;-)
	default:
		log.Warn("EmailBroker : unknown store backend: %s", conf.StoreName)
		err = errors.New("EmailBroker : unknown store backend")
		return
	}

	switch conf.IndexName {
	case "elasticsearch":
		c := index.ElasticSearchConfig{
			Urls: conf.IndexConfig.Urls,
		}
		i, e := index.InitializeElasticSearchIndex(c)
		if e != nil {
			err = e
			log.WithError(err).Warnf("EmailBroker : initalization of %s backend failed", conf.IndexName)
			return
		}

		broker.Index = backends.LDAIndex(i) // type conversion to LDA interface
	}

	broker.NatsConn, e = nats.Connect(conf.NatsURL)
	if e != nil {
		err = e
		log.WithError(err).Warn("EmailBroker : initalization of NATS connexion failed")
		return
	}
	if conf.BrokerType == "smtp" {
		broker.Connectors.IncomingSmtp = make(chan *SmtpEmail)
		broker.Connectors.OutcomingSmtp = make(chan *SmtpEmail)

		e = broker.startIncomingSmtpAgent()
		if e != nil {
			err = e
			log.WithError(err).Warn("EmailBroker : failed to start incoming smtp agent")
			return
		}
		for i := 0; i < conf.NatsListeners; i++ {
			e = broker.startOutcomingSmtpAgent()
			if e != nil {
				err = e
				log.WithError(err).Warn("EmailBroker : failed to start outcoming smtp agent")
				return
			}
		}

		connectors = broker.Connectors
	}

	log.WithField("EmailBroker", conf.BrokerType).Info("EmailBroker started.")
	return
}

func (broker *EmailBroker) ShutDown() {
	for _, sub := range broker.natsSubscriptions {
		sub.Unsubscribe()
	}
	broker.NatsConn.Close()
	log.WithField("EmailBroker", "Nats subscriptions & connexion closed").Info()
	broker.Store.Close()
	log.WithField("EmailBroker", "Store client closed").Info()
	broker.Index.Close()
	log.WithField("EmailBroker", "Index client closed").Info()
}
