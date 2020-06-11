package importer

import (
	"time"

	ledgertools "github.com/ginabythebay/ledger-tools"
	"github.com/ginabythebay/ledger-tools/gmail"
	"github.com/ginabythebay/ledger-tools/rules"
	"github.com/pkg/errors"
)

// Rule inputs
const (
	instrumentKey = "Instrument"
	payeeKey      = "Payee"
)

// Rule outputs
const (
	costAccountKey    = "CostAccount"
	paymentAccountKey = "PaymentAccount"
)

var (
	validInputs = []string{instrumentKey, payeeKey}
	validOuputs = []string{costAccountKey, paymentAccountKey}
)

type Parser func(msg ledgertools.Message) (*Parsed, error)

// GmailImporter knows to query gmail for messages and how to
// parse them.
type GmailImporter struct {
	Queries []gmail.QuerySet
	Parsers []Parser
}

func NewGmailImporter(queries []gmail.QuerySet, parsers []Parser) GmailImporter {
	return GmailImporter{queries, parsers}
}

// MsgImporter knows how to import messages
type MsgImporter struct {
	rs         *rules.RuleSet
	allParsers []Parser
}

// NewMsgImporter creates a new MsgImporter
func NewMsgImporter(ruleConfig []byte, allParsers []Parser) (*MsgImporter, error) {
	rs, err := rules.From(ruleConfig, validInputs, validOuputs)
	if err != nil {
		return nil, errors.Wrap(err, "reading rule config")
	}
	return &MsgImporter{rs, allParsers}, nil
}

// ImportMessage imports an email message and produces a Transaction.
// nil will be returned if the email message is of a type we don't
// recognize
func (mi *MsgImporter) ImportMessage(msg ledgertools.Message) (*ledgertools.Transaction, error) {

	var parsed *Parsed
	var err error
	for _, parser := range mi.allParsers {
		parsed, err = parser(msg)
		if err != nil {
			return nil, errors.Wrapf(err, "%s", parser)
		}
		if parsed != nil {
			break
		}
	}
	if parsed == nil {
		return nil, nil
	}

	result, err := parsed.transaction(mi.rs)
	if err != nil {
		return nil, errors.Wrap(err, "transaction")
	}
	return result, nil
}

// Parsed represents parsed data that we can convert to a Transaction with the help of a RuleSet.
type Parsed struct {
	Date        time.Time
	CheckNumber string // may not be set
	Payee       string
	Comments    []string // These should not contain the leading ; character

	Amount            string
	PaymentInstrument string
}

// NewParsed Creates a new Parsed entry
func NewParsed(date time.Time, checkNumber, payee string, comments []string, amount, paymentInstrument string) *Parsed {
	return &Parsed{date, checkNumber, payee, comments, amount, paymentInstrument}
}

func (p Parsed) transaction(rs *rules.RuleSet) (*ledgertools.Transaction, error) {
	var costAccount, paymentAccount string
	mappings := rs.Apply(
		rules.Input(instrumentKey, p.PaymentInstrument),
		rules.Input(payeeKey, p.Payee))

	if costAccount = mappings.Get(costAccountKey); costAccount == "" {
		return nil, errors.Errorf("Unable to determine %q for payee %q.  rs=%#v", costAccountKey, p.Payee, rs)
	}
	if paymentAccount = mappings.Get(paymentAccountKey); paymentAccount == "" {
		return nil, errors.Errorf("Unable to determine %q for instrument %q.  rs=%#v", paymentAccountKey, p.PaymentInstrument, rs)
	}

	return ledgertools.SyntheticTransaction(
		p.Date,
		p.CheckNumber,
		p.Payee,
		p.Comments,
		p.Amount,
		costAccount,
		paymentAccount,
	)
}
