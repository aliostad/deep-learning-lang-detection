package brokerintegration_test

import (
	"fmt"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gbytes"
	"github.com/onsi/gomega/gexec"
	. "github.com/st3v/glager"

	"github.com/pivotal-cf/cf-redis-broker/integration"
	"github.com/pivotal-cf/cf-redis-broker/integration/helpers"
)

var _ = Describe("starting the broker", func() {
	var (
		broker *gexec.Session
		config string
	)

	BeforeEach(func() {
		config = "broker.yml-colocated"
	})

	JustBeforeEach(func() {
		broker = integration.LaunchProcessWithBrokerConfig(brokerExecutablePath, config)
	})

	AfterEach(func() {
		helpers.KillProcess(broker)
	})

	It("logs a startup message", func() {
		Eventually(broker.Out).Should(gbytes.Say("Starting CF Redis broker"))
	})

	It("logs that it has identified zero shared instances", func() {
		Eventually(broker.Out).Should(gbytes.Say("0 shared Redis instances found"))
	})

	It("logs that it has identified zero dedicated instances", func() {
		statefilePath := brokerConfig.RedisConfiguration.Dedicated.StatefilePath
		Eventually(broker.Out).Should(gbytes.Say(fmt.Sprintf("statefile %s not found, generating instead", statefilePath)))
	})

	It("logs that it has identified zero dedicated instances", func() {
		Eventually(broker.Out).Should(gbytes.Say("0 dedicated Redis instances found"))
	})

	Context("when consistency checks are not configured to run", func() {
		It("does not verify consistency", func() {
			Consistently(broker.Out).ShouldNot(HaveLogged(
				Info(
					Action("redis-broker.consistency.keep-verifying"),
				),
			))
		})
	})

	Context("when consistency checks are configured to run every 5 seconds", func() {
		BeforeEach(func() {
			config = "broker.yml-consistency"
		})

		It("logs that consistency is being verified", func() {
			Eventually(broker.Out).Should(HaveLogged(
				Info(
					Action("redis-broker.consistency.keep-verifying"),
					Data("message", "started", "interval", "5s"),
				),
			))
		})
	})
})
