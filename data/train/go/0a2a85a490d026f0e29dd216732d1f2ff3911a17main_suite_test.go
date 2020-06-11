package main_test

import (
	"os/exec"
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gexec"
)

func TestMysqlBroker(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "MySQL Broker Suite")
}

const brokerPackage = "github.com/pivotal-cf-experimental/cf-mysql-broker"

var brokerCmd *exec.Cmd

var _ = BeforeSuite(func() {
	var err error
	brokerBinPath, err := gexec.Build(brokerPackage, "-race")
	Expect(err).NotTo(HaveOccurred())

	brokerCmd = exec.Command(brokerBinPath)
})

var _ = AfterSuite(func() {
	gexec.CleanupBuildArtifacts()
})
