package brokerintegration_test

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gbytes"
	"github.com/onsi/gomega/gexec"
	"github.com/pivotal-cf/cf-redis-broker/integration"
)

var _ = Describe("broker cmd", func() {
	It("fails with non zero status code if unable to bind to required port", func() {
		newBrokerSession := integration.LaunchProcessWithBrokerConfig(brokerExecutablePath, "broker.yml")
		Eventually(newBrokerSession).Should(gexec.Exit())
		Expect(newBrokerSession.ExitCode()).NotTo(Equal(0))
	})

	It("logs a useful error message if unable to bind to require port", func() {
		newBrokerSession := integration.LaunchProcessWithBrokerConfig(brokerExecutablePath, "broker.yml")
		Eventually(newBrokerSession).Should(gexec.Exit())
		Eventually(newBrokerSession.Err).Should(gbytes.Say("bind: address already in use"))
	})
})
