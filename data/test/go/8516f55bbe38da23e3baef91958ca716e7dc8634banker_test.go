package process_test

import (
	"testing"

	"github.com/elanq/daily_tools/banker/process"
	"github.com/stretchr/testify/suite"
)

type BankerSuite struct {
	suite.Suite
	bankerProcess *process.Banker
}

func TestBankerSuite(t *testing.T) {
	suite.Run(t, new(BankerSuite))
}

func (b *BankerSuite) SetupSuite() {
	b.bankerProcess = process.NewBanker()
}

func (b *BankerSuite) TestNewBanker() {
	b.Assert().NotNil(b.bankerProcess, "Process shouldn't be nil")
	b.Assert().NotNil(b.bankerProcess.BankerHandler, "Handler should'nt be nil")
	b.Assert().NotNil(b.bankerProcess.Reader, "Reader should'nt be nil")
	b.Assert().NotNil(b.bankerProcess.MongoDriver, "DB Driver should'nt be nil")
	b.Assert().NotNil(b.bankerProcess.Router, "Router should'nt be nil")

}
