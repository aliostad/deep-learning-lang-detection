package servicebroker_test

import (
	testapi "github.com/nttlabs/cli/cf/api/fakes"
	. "github.com/nttlabs/cli/cf/commands/servicebroker"
	"github.com/nttlabs/cli/cf/configuration/core_config"
	"github.com/nttlabs/cli/cf/models"
	testcmd "github.com/nttlabs/cli/testhelpers/commands"
	testconfig "github.com/nttlabs/cli/testhelpers/configuration"
	. "github.com/nttlabs/cli/testhelpers/matchers"
	testreq "github.com/nttlabs/cli/testhelpers/requirements"
	testterm "github.com/nttlabs/cli/testhelpers/terminal"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("delete-service-broker command", func() {
	var (
		ui                  *testterm.FakeUI
		configRepo          core_config.ReadWriter
		brokerRepo          *testapi.FakeServiceBrokerRepo
		requirementsFactory *testreq.FakeReqFactory
	)

	BeforeEach(func() {
		ui = &testterm.FakeUI{Inputs: []string{"y"}}
		brokerRepo = &testapi.FakeServiceBrokerRepo{}
		configRepo = testconfig.NewRepositoryWithDefaults()
		requirementsFactory = &testreq.FakeReqFactory{LoginSuccess: true}
	})

	runCommand := func(args ...string) {
		cmd := NewDeleteServiceBroker(ui, configRepo, brokerRepo)
		testcmd.RunCommand(cmd, args, requirementsFactory)
	}

	Describe("requirements", func() {
		It("fails with usage when called without a broker's name", func() {
			runCommand()
			Expect(ui.FailedWithUsage).To(BeTrue())
		})

		It("fails requirements when not logged in", func() {
			requirementsFactory.LoginSuccess = false
			runCommand("-f", "my-broker")
			Expect(testcmd.CommandDidPassRequirements).To(BeFalse())
		})
	})

	Context("when the service broker exists", func() {
		BeforeEach(func() {
			brokerRepo.FindByNameServiceBroker = models.ServiceBroker{
				Name: "service-broker-to-delete",
				Guid: "service-broker-to-delete-guid",
			}
		})

		It("deletes the service broker with the given name", func() {
			runCommand("service-broker-to-delete")

			Expect(brokerRepo.FindByNameName).To(Equal("service-broker-to-delete"))
			Expect(brokerRepo.DeletedServiceBrokerGuid).To(Equal("service-broker-to-delete-guid"))
			Expect(ui.Prompts).To(ContainSubstrings([]string{"Really delete the service-broker service-broker-to-delete"}))

			Expect(ui.Outputs).To(ContainSubstrings(
				[]string{"Deleting service broker", "service-broker-to-delete", "my-user"},
				[]string{"OK"},
			))
		})

		It("does not prompt when the -f flag is provided", func() {
			runCommand("-f", "service-broker-to-delete")

			Expect(brokerRepo.FindByNameName).To(Equal("service-broker-to-delete"))
			Expect(brokerRepo.DeletedServiceBrokerGuid).To(Equal("service-broker-to-delete-guid"))

			Expect(ui.Prompts).To(BeEmpty())
			Expect(ui.Outputs).To(ContainSubstrings(
				[]string{"Deleting service broker", "service-broker-to-delete", "my-user"},
				[]string{"OK"},
			))
		})
	})

	Context("when the service broker does not exist", func() {
		BeforeEach(func() {
			brokerRepo.FindByNameNotFound = true
		})

		It("warns the user", func() {
			ui.Inputs = []string{}
			runCommand("-f", "service-broker-to-delete")

			Expect(brokerRepo.FindByNameName).To(Equal("service-broker-to-delete"))
			Expect(brokerRepo.DeletedServiceBrokerGuid).To(Equal(""))
			Expect(ui.Outputs).To(ContainSubstrings(
				[]string{"Deleting service broker", "service-broker-to-delete"},
				[]string{"OK"},
			))

			Expect(ui.WarnOutputs).To(ContainSubstrings([]string{"service-broker-to-delete", "does not exist"}))
		})
	})
})
