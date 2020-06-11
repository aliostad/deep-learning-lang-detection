package brokerintegration_test

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gbytes"
	"github.com/onsi/gomega/gexec"
	"github.com/pivotal-cf/cf-redis-broker/integration"
	"github.com/pivotal-cf/cf-redis-broker/integration/helpers"
)

var _ = Describe("Broker Integration", func() {
	var broker *gexec.Session

	BeforeEach(func() {
		broker = integration.LaunchProcessWithBrokerConfig(brokerExecutablePath, "broker.yml-colocated")
		Eventually(broker.Out).Should(gbytes.Say("shared Redis instance"))
	})

	AfterEach(func() {
		helpers.KillProcess(broker)
	})

	JustBeforeEach(func() {
		helpers.KillProcess(broker)
	})

	Context("when the Redis broker is shutdown", func() {
		It("logs a shutdown preparation message", func() {
			Expect(broker.Out).To(gbytes.Say("Starting Redis Broker shutdown"))
		})

		It("logs that it has identified zero shared instances", func() {
			Expect(broker.Out).To(gbytes.Say("0 shared Redis instances found"))
		})

		It("logs that it has identified zero dedicated instances", func() {
			Expect(broker.Out).To(gbytes.Say("0 dedicated Redis instances found"))
		})
	})
})
