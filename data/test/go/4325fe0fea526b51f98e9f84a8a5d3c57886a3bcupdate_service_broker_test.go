package servicebroker_test

import (
	testapi "github.com/nttlabs/cli/cf/api/fakes"
	. "github.com/nttlabs/cli/cf/commands/servicebroker"
	"github.com/nttlabs/cli/cf/configuration/core_config"
	"github.com/nttlabs/cli/cf/models"
	testcmd "github.com/nttlabs/cli/testhelpers/commands"
	testconfig "github.com/nttlabs/cli/testhelpers/configuration"
	testreq "github.com/nttlabs/cli/testhelpers/requirements"
	testterm "github.com/nttlabs/cli/testhelpers/terminal"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"

	. "github.com/nttlabs/cli/testhelpers/matchers"
)

var _ = Describe("update-service-broker command", func() {
	var (
		ui                  *testterm.FakeUI
		requirementsFactory *testreq.FakeReqFactory
		configRepo          core_config.ReadWriter
		serviceBrokerRepo   *testapi.FakeServiceBrokerRepo
	)

	BeforeEach(func() {
		configRepo = testconfig.NewRepositoryWithDefaults()

		ui = &testterm.FakeUI{}
		requirementsFactory = &testreq.FakeReqFactory{}
		serviceBrokerRepo = &testapi.FakeServiceBrokerRepo{}
	})

	runCommand := func(args ...string) {
		testcmd.RunCommand(NewUpdateServiceBroker(ui, configRepo, serviceBrokerRepo), args, requirementsFactory)
	}

	Describe("requirements", func() {
		It("fails with usage when invoked without exactly four args", func() {
			requirementsFactory.LoginSuccess = true

			runCommand("arg1", "arg2", "arg3")
			Expect(ui.FailedWithUsage).To(BeTrue())
		})

		It("fails when not logged in", func() {
			runCommand("heeeeeeey", "yooouuuuuuu", "guuuuuuuuys", "ヾ(＠*ー⌒ー*@)ノ")
			Expect(testcmd.CommandDidPassRequirements).To(BeFalse())
		})
	})

	Context("when logged in", func() {
		BeforeEach(func() {
			requirementsFactory.LoginSuccess = true
			broker := models.ServiceBroker{}
			broker.Name = "my-found-broker"
			broker.Guid = "my-found-broker-guid"
			serviceBrokerRepo.FindByNameServiceBroker = broker
		})

		It("updates the service broker with the provided properties", func() {
			runCommand("my-broker", "new-username", "new-password", "new-url")

			Expect(serviceBrokerRepo.FindByNameName).To(Equal("my-broker"))

			Expect(ui.Outputs).To(ContainSubstrings(
				[]string{"Updating service broker", "my-found-broker", "my-user"},
				[]string{"OK"},
			))

			expectedServiceBroker := models.ServiceBroker{}
			expectedServiceBroker.Name = "my-found-broker"
			expectedServiceBroker.Username = "new-username"
			expectedServiceBroker.Password = "new-password"
			expectedServiceBroker.Url = "new-url"
			expectedServiceBroker.Guid = "my-found-broker-guid"

			Expect(serviceBrokerRepo.UpdatedServiceBroker).To(Equal(expectedServiceBroker))
		})
	})
})
