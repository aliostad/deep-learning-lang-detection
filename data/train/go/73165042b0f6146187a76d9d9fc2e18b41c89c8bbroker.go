package integration

import (
	"os"
	"os/exec"
	"path/filepath"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gexec"
	"github.com/pivotal-cf/cf-redis-broker/brokerconfig"
	"github.com/pivotal-cf/cf-redis-broker/integration/helpers"
)

func LoadBrokerConfig(brokerFilename string) brokerconfig.Config {
	brokerConfigPath := helpers.AssetPath(brokerFilename)

	brokerConfig, err := brokerconfig.ParseConfig(brokerConfigPath)
	Ω(err).NotTo(HaveOccurred())

	return brokerConfig
}

func BuildBroker() string {
	return helpers.BuildExecutable("github.com/pivotal-cf/cf-redis-broker/cmd/broker")
}

func LaunchProcessWithBrokerConfig(executablePath string, brokerConfigName string) *gexec.Session {
	brokerConfigFile := helpers.AssetPath(brokerConfigName)

	os.Setenv("BROKER_CONFIG_PATH", brokerConfigFile)
	os.Setenv("SHARED_PID_DIR", filepath.FromSlash("/tmp/redis-pid-dir"))
	processCmd := exec.Command(executablePath)
	processCmd.Stdout = GinkgoWriter
	processCmd.Stderr = GinkgoWriter
	return runCommand(processCmd)
}

func runCommand(cmd *exec.Cmd) *gexec.Session {
	session, err := gexec.Start(cmd, GinkgoWriter, GinkgoWriter)
	Ω(err).NotTo(HaveOccurred())
	return session
}
