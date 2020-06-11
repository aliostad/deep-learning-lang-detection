package services

/// Initializes the broker
/// IAM Requirements
///   - sts:GetCallerIdentity

import (
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-sdk-go/service/sts"
)

type Broker struct {
	s         *session.Session
	accountId string
}

func NewBroker(s *session.Session) *Broker {
	if s == nil {
		s = session.New()
	}
	return &Broker{
		s: s,
	}
}

func (b *Broker) Init() error {
	out, err := b.STS().GetCallerIdentity(&sts.GetCallerIdentityInput{})
	if err != nil {
		return err
	}
	b.accountId = *out.Account
	return nil
}

func (b *Broker) Region() string {
	return *b.s.Config.Region
}

func (b *Broker) AccountId() string {
	return b.accountId
}

func (b *Broker) EC2() *ec2.EC2 {
	return ec2.New(b.s)
}

func (b *Broker) STS() *sts.STS {
	return sts.New(b.s)
}
