package pscs_test

import (
	"github.com/enaml-ops/enaml"
	"github.com/enaml-ops/omg-product-bundle/products/p-scs/enaml-gen/register-service-broker"

	pscs "github.com/enaml-ops/omg-product-bundle/products/p-scs/plugin"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("regsiter broker partition", func() {
	Context("when initialized with a complete configuration", func() {
		var ig *enaml.InstanceGroup

		const (
			controlNetworkName       = "foundry-net"
			controlSystemDomain      = "sys.example.com"
			controlBrokerUser        = "broker"
			controlBrokerPass        = "brokerpass"
			controlWorkerSecret      = "workersecret"
			controlWorkerPassword    = "workerpassword"
			controlInstancesPassword = "instancespassword"
			controlDashboardSecret   = "dashbaordsecret"
			controlEncryptionKey     = "encryptionkey"
			controlCFAdminPass       = "cfadmin"
			controlUAAAdminSecret    = "uaaadminsecret"
			controlAZ                = "az1"
			controlVMType            = "small"
		)

		BeforeEach(func() {
			cfg := &pscs.Config{
				Network:               controlNetworkName,
				SystemDomain:          controlSystemDomain,
				AppDomains:            []string{"apps1.example.com", "apps2.example.com"},
				BrokerUsername:        controlBrokerUser,
				BrokerPassword:        controlBrokerPass,
				SkipSSLVerify:         true,
				WorkerClientSecret:    controlWorkerSecret,
				WorkerPassword:        controlWorkerPassword,
				InstancesPassword:     controlInstancesPassword,
				BrokerDashboardSecret: controlDashboardSecret,
				EncryptionKey:         controlEncryptionKey,
				CFAdminPassword:       controlCFAdminPass,
				UAAAdminClientSecret:  controlUAAAdminSecret,
				AZs:                   []string{controlAZ},
				VMType:                controlVMType,
			}
			ig = pscs.NewRegisterBroker(cfg)
		})

		It("should configure the instance group", func() {
			Ω(ig.Name).Should(Equal("register-service-broker"))
			Ω(ig.Stemcell).Should(Equal(pscs.StemcellAlias))
			Ω(ig.Lifecycle).Should(Equal("errand"))
			Ω(ig.Instances).Should(Equal(1))
			Ω(ig.AZs).Should(ConsistOf(controlAZ))
			Ω(ig.VMType).Should(Equal(controlVMType))
			Ω(ig.Networks).Should(HaveLen(1))
			Ω(ig.Networks[0].Name).Should(Equal(controlNetworkName))
			Ω(ig.Networks[0].Default).Should(ConsistOf("dns", "gateway"))
			Ω(ig.Networks[0].StaticIPs).Should(BeNil())
		})

		It("should configure the register-service-broker job", func() {
			job := ig.GetJobByName("register-service-broker")
			Ω(job).ShouldNot(BeNil())

			props := job.Properties.(*register_service_broker.RegisterServiceBrokerJob)
			Ω(props.Domain).Should(Equal(controlSystemDomain))
			Ω(props.AppDomains).Should(ConsistOf("apps1.example.com", "apps2.example.com"))
			Ω(props.Ssl).ShouldNot(BeNil())
			Ω(props.Ssl.SkipCertVerify).Should(BeTrue())

			Ω(props.SpringCloudBroker).ShouldNot(BeNil())
			Ω(props.SpringCloudBroker.Broker).ShouldNot(BeNil())
			Ω(props.SpringCloudBroker.Broker.User).Should(Equal(controlBrokerUser))
			Ω(props.SpringCloudBroker.Broker.Password).Should(Equal(controlBrokerPass))

			Ω(props.SpringCloudBroker.Cf).ShouldNot(BeNil())
			Ω(props.SpringCloudBroker.Cf.AdminUser).Should(Equal("admin"))
			Ω(props.SpringCloudBroker.Cf.AdminPassword).Should(Equal(controlCFAdminPass))

			Ω(props.SpringCloudBroker.Uaa).ShouldNot(BeNil())
			Ω(props.SpringCloudBroker.Uaa.AdminClientId).Should(Equal("admin"))
			Ω(props.SpringCloudBroker.Uaa.AdminClientSecret).Should(Equal(controlUAAAdminSecret))
		})
	})
})
