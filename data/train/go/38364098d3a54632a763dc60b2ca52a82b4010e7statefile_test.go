package brokerintegration_test

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/pborman/uuid"
	"github.com/pivotal-cf/cf-redis-broker/integration"
	"github.com/pivotal-cf/cf-redis-broker/integration/helpers"
)

var _ = Describe("Provision dedicated instance", func() {

	var instanceID string

	BeforeEach(func() {
		instanceID = uuid.NewRandom().String()
		brokerClient.ProvisionInstance(instanceID, "dedicated")
	})

	AfterEach(func() {
		brokerClient.DeprovisionInstance(instanceID)
	})

	Context("when the broker is restarted", func() {
		BeforeEach(func() {
			helpers.KillProcess(brokerSession)
			brokerSession = integration.LaunchProcessWithBrokerConfig(brokerExecutablePath, "broker.yml")
			Ω(helpers.ServiceAvailable(brokerPort)).Should(BeTrue())
		})

		It("retains state", func() {
			debugInfo := getDebugInfo()

			Ω(debugInfo.Allocated.Count).Should(Equal(1))
			Ω(len(debugInfo.Allocated.Clusters)).Should(Equal(1))

			host := debugInfo.Allocated.Clusters[0].Hosts[0]
			Ω(host).Should(MatchRegexp(`127\.0\.0\.(1|01|001)`))

			Ω(debugInfo.Pool.Clusters).ShouldNot(ContainElement([]string{host}))
		})
	})

	Context("when the broker is restarted with a new node", func() {
		BeforeEach(func() {
			helpers.KillProcess(brokerSession)
			brokerSession = integration.LaunchProcessWithBrokerConfig(brokerExecutablePath, "broker.yml-extra-node")
			Ω(helpers.ServiceAvailable(brokerPort)).Should(BeTrue())
		})

		AfterEach(func() {
			helpers.KillProcess(brokerSession)
			brokerSession = integration.LaunchProcessWithBrokerConfig(brokerExecutablePath, "broker.yml")
			Ω(helpers.ServiceAvailable(brokerPort)).Should(BeTrue())
		})

		It("retains state, and adds the extra node", func() {
			debugInfo := getDebugInfo()

			Ω(debugInfo.Allocated.Count).Should(Equal(1))
			Ω(len(debugInfo.Allocated.Clusters)).Should(Equal(1))

			host := debugInfo.Allocated.Clusters[0].Hosts[0]
			Ω(host).Should(MatchRegexp(`127\.0\.0\.(1|01|001)`))

			Ω(debugInfo.Pool.Clusters).ShouldNot(ContainElement([]string{host}))
			Ω(debugInfo.Pool.Clusters).Should(ContainElement([]string{"127.0.0.2"}))
		})

	})
})
