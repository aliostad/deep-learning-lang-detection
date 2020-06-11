package integration_aws_test

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"testing"
	"time"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gbytes"
	"github.com/onsi/gomega/gexec"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/phayes/freeport"
	uuid "github.com/satori/go.uuid"

	"github.com/alphagov/paas-rds-broker/config"

	. "github.com/alphagov/paas-rds-broker/ci/helpers"
)

var (
	rdsBrokerPath    string
	rdsBrokerPort    int
	rdsBrokerUrl     string
	rdsBrokerSession *gexec.Session

	brokerAPIClient *BrokerAPIClient

	rdsBrokerConfig *config.Config

	rdsClient *RDSClient

	rdsSubnetGroupName *string
	ec2SecurityGroupID *string
)

func TestSuite(t *testing.T) {
	BeforeSuite(func() {
		var err error

		// Compile the broker
		cp, err := gexec.Build("github.com/alphagov/paas-rds-broker")
		Expect(err).ShouldNot(HaveOccurred())

		// Update config
		rdsBrokerConfig, err = config.LoadConfig("./config.json")
		Expect(err).ToNot(HaveOccurred())
		err = rdsBrokerConfig.Validate()
		Expect(err).ToNot(HaveOccurred())

		rdsBrokerConfig.RDSConfig.BrokerName = fmt.Sprintf("%s-%s",
			rdsBrokerConfig.RDSConfig.BrokerName,
			uuid.NewV4().String(),
		)

		awsSession := session.New(&aws.Config{
			Region: aws.String(rdsBrokerConfig.RDSConfig.Region)},
		)
		rdsSubnetGroupName, err = CreateSubnetGroup(rdsBrokerConfig.RDSConfig.DBPrefix, awsSession)
		Expect(err).ToNot(HaveOccurred())
		ec2SecurityGroupID, err = CreateSecurityGroup(rdsBrokerConfig.RDSConfig.DBPrefix, awsSession)
		Expect(err).ToNot(HaveOccurred())

		for serviceIndex := range rdsBrokerConfig.RDSConfig.Catalog.Services {
			for planIndex := range rdsBrokerConfig.RDSConfig.Catalog.Services[serviceIndex].Plans {
				plan := &rdsBrokerConfig.RDSConfig.Catalog.Services[serviceIndex].Plans[planIndex]
				plan.RDSProperties.DBSubnetGroupName = *rdsSubnetGroupName
				plan.RDSProperties.VpcSecurityGroupIds = []string{*ec2SecurityGroupID}
			}
		}

		configFile, err := ioutil.TempFile("", "rds-broker")
		Expect(err).ToNot(HaveOccurred())
		defer os.Remove(configFile.Name())

		configJSON, err := json.Marshal(rdsBrokerConfig)
		Expect(err).ToNot(HaveOccurred())
		Expect(ioutil.WriteFile(configFile.Name(), configJSON, 0644)).To(Succeed())
		Expect(configFile.Close()).To(Succeed())

		// start the broker in a random port
		rdsBrokerPort = freeport.GetPort()
		command := exec.Command(cp,
			fmt.Sprintf("-port=%d", rdsBrokerPort),
			fmt.Sprintf("-config=%s", configFile.Name()),
		)
		rdsBrokerSession, err = gexec.Start(command, GinkgoWriter, GinkgoWriter)
		Expect(err).ShouldNot(HaveOccurred())

		// Wait for it to be listening
		Eventually(rdsBrokerSession, 10*time.Second).Should(gbytes.Say(fmt.Sprintf("RDS Service Broker started on port %d", rdsBrokerPort)))

		rdsBrokerUrl = fmt.Sprintf("http://localhost:%d", rdsBrokerPort)

		brokerAPIClient = NewBrokerAPIClient(rdsBrokerUrl, rdsBrokerConfig.Username, rdsBrokerConfig.Password)
		rdsClient, err = NewRDSClient(rdsBrokerConfig.RDSConfig.Region, rdsBrokerConfig.RDSConfig.DBPrefix)

		Expect(err).ToNot(HaveOccurred())
	})

	AfterSuite(func() {
		awsSession := session.New(&aws.Config{
			Region: aws.String(rdsBrokerConfig.RDSConfig.Region)},
		)
		if ec2SecurityGroupID != nil {
			Expect(DestroySecurityGroup(ec2SecurityGroupID, awsSession)).To(Succeed())
		}
		if rdsSubnetGroupName != nil {
			Expect(DestroySubnetGroup(rdsSubnetGroupName, awsSession)).To(Succeed())
		}
		rdsBrokerSession.Kill()
	})

	RegisterFailHandler(Fail)
	RunSpecs(t, "RDS Broker Integration Suite")
}
