package actor

import (
	"sync"

	"github.com/go-akka/akka"
	"github.com/go-akka/akka/dispatch"
	"github.com/go-akka/akka/dispatch/sysmsg"
)

type IDispatch interface {
	Init(sendSupervise bool, mailboxType akka.MailboxType)
	InitWithFailure(err error)
	Mailbox() (mailbox akka.Mailbox)
	HasMessages() (has bool)
	NumberOfMessages() int
	IsTerminated() (yes bool)
	Start()
}

var (
	_ IDispatch = (*ActorCellDispatch)(nil)
)

type ActorCellDispatch struct {
	*ActorCell

	mailboxLocker sync.Mutex
}

func newActorCellDispatch(cell *ActorCell) IDispatch {
	return &ActorCellDispatch{ActorCell: cell}
}

func (p *ActorCellDispatch) Init(sendSupervise bool, mailboxType akka.MailboxType) {

	mbox := p.Dispatcher().CreateMailbox(p, mailboxType)

	p.swapMailbox(mbox)
	p.mailbox.SetActor(p)

	createMessage := &sysmsg.Create{}
	p.mailbox.SystemEnqueue(p.Self(), createMessage)

	if sendSupervise {
		p.parent.SendSystemMessage(&sysmsg.Supervise{p.Self(), false})
	}

	return
}

func (p *ActorCellDispatch) InitWithFailure(err error) {
	mbox := p.Dispatcher().CreateMailbox(p, dispatch.NewUnboundedMailbox())

	p.swapMailbox(mbox)
	p.mailbox.SetActor(p)

	createMessage := &sysmsg.Create{}
	p.mailbox.SystemEnqueue(p.Self(), createMessage)

	return
}

func (p *ActorCellDispatch) Mailbox() (mailbox akka.Mailbox) {
	return p.mailbox
}

func (p *ActorCellDispatch) HasMessages() (has bool) {
	return p.mailbox.HasMessages()
}

func (p *ActorCellDispatch) NumberOfMessages() int {
	return p.mailbox.NumberOfMessages()
}

func (p *ActorCellDispatch) IsTerminated() (yes bool) {
	return p.mailbox.IsClosed()
}

func (p *ActorCellDispatch) Start() {
	p.dispitcher.Attach(p)
}

func (p *ActorCellDispatch) swapMailbox(mailbox akka.Mailbox) {
	p.mailboxLocker.Lock()
	defer p.mailboxLocker.Unlock()

	p.mailbox = mailbox
}
