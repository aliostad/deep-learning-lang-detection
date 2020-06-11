package pscs_test

import (
	"github.com/enaml-ops/enaml"
	"github.com/enaml-ops/omg-product-bundle/products/p-scs/enaml-gen/deploy-service-broker"
	pscs "github.com/enaml-ops/omg-product-bundle/products/p-scs/plugin"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("deploy broker partition", func() {
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
			ig = pscs.NewDeployServiceBroker(cfg)
		})

		It("should configure the instance group", func() {
			Ω(ig.Name).Should(Equal("deploy-service-broker"))
			Ω(ig.Lifecycle).Should(Equal("errand"))
			Ω(ig.Stemcell).Should(Equal(pscs.StemcellAlias))
			Ω(ig.Instances).Should(Equal(1))
			Ω(ig.AZs).Should(ConsistOf(controlAZ))
			Ω(ig.VMType).Should(Equal(controlVMType))
			Ω(ig.Networks).Should(HaveLen(1))
			Ω(ig.Networks[0].Name).Should(Equal(controlNetworkName))
			Ω(ig.Networks[0].Default).Should(ConsistOf("dns", "gateway"))
			Ω(ig.Networks[0].StaticIPs).Should(BeNil())
		})

		It("should configure the deploy-service-broker job", func() {
			job := ig.GetJobByName("deploy-service-broker")
			Ω(job).ShouldNot(BeNil())

			props := job.Properties.(*deploy_service_broker.DeployServiceBrokerJob)
			Ω(props.Domain).Should(Equal(controlSystemDomain))
			Ω(props.AppDomains).Should(ConsistOf("apps1.example.com", "apps2.example.com"))
			Ω(props.Ssl).ShouldNot(BeNil())
			Ω(props.Ssl.SkipCertVerify).Should(BeTrue())

			Ω(props.SpringCloudBroker).ShouldNot(BeNil())
			Ω(props.SpringCloudBroker.Broker).ShouldNot(BeNil())
			Ω(props.SpringCloudBroker.Broker.User).Should(Equal(controlBrokerUser))
			Ω(props.SpringCloudBroker.Broker.Password).Should(Equal(controlBrokerPass))
			Ω(props.SpringCloudBroker.Broker.MaxInstances).Should(Equal(100))

			Ω(props.SpringCloudBroker.Worker).ShouldNot(BeNil())
			Ω(props.SpringCloudBroker.Worker.ClientSecret).Should(Equal(controlWorkerSecret))
			Ω(props.SpringCloudBroker.Worker.User).Should(Equal("admin"))
			Ω(props.SpringCloudBroker.Worker.Password).Should(Equal(controlWorkerPassword))

			Ω(props.SpringCloudBroker.Instances).ShouldNot(BeNil())
			Ω(props.SpringCloudBroker.Instances.InstancesUser).Should(Equal("p-spring-cloud-services"))
			Ω(props.SpringCloudBroker.Instances.InstancesPassword).Should(Equal(controlInstancesPassword))

			Ω(props.SpringCloudBroker.BrokerDashboardSecret).Should(Equal(controlDashboardSecret))
			Ω(props.SpringCloudBroker.EncryptionKey).Should(Equal(controlEncryptionKey))

			Ω(props.SpringCloudBroker.Cf).ShouldNot(BeNil())
			Ω(props.SpringCloudBroker.Cf.AdminUser).Should(Equal("admin"))
			Ω(props.SpringCloudBroker.Cf.AdminPassword).Should(Equal(controlCFAdminPass))

			Ω(props.SpringCloudBroker.Uaa).ShouldNot(BeNil())
			Ω(props.SpringCloudBroker.Uaa.AdminClientId).Should(Equal("admin"))
			Ω(props.SpringCloudBroker.Uaa.AdminClientSecret).Should(Equal(controlUAAAdminSecret))
		})
	})
})
