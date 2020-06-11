// Copyright (C) 2016-Present Pivotal Software, Inc. All rights reserved.
// This program and the accompanying materials are made available under the terms of the under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

package upgrade_all_service_instances_test

import (
	"fmt"
	"time"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gbytes"
	"github.com/onsi/gomega/gexec"
	"github.com/pivotal-cf/on-demand-service-broker/integration_tests/helpers"
	"github.com/pivotal-cf/on-demand-service-broker/mockhttp"
	"github.com/pivotal-cf/on-demand-service-broker/mockhttp/mockbroker"
)

var _ = Describe("running the tool to upgrade all service instances", func() {
	const (
		brokerUsername = "broker username"
		brokerPassword = "broker password"
	)

	var (
		odb         *mockhttp.Server
		validParams []string
	)

	BeforeEach(func() {
		odb = mockbroker.New()
		odb.ExpectedBasicAuth(brokerUsername, brokerPassword)
		validParams = []string{
			"-brokerUsername", brokerUsername,
			"-brokerPassword", brokerPassword,
			"-brokerUrl", odb.URL,
			"-pollingInterval", "1",
		}
	})

	AfterEach(func() {
		odb.VerifyMocks()
		odb.Close()
	})

	Context("when there is one service instance", func() {
		It("exits successfully with one instance upgraded message", func() {
			operationData := `{"BoshTaskID":1,"OperationType":"upgrade"}`
			instanceID := "service-instance-id"
			odb.VerifyAndMock(
				mockbroker.ListInstances().RespondsOKWith(fmt.Sprintf(`[{"instance_id": "%s"}]`, instanceID)),
				mockbroker.UpgradeInstance(instanceID).RespondsAcceptedWith(operationData),
				mockbroker.LastOperation(instanceID, operationData).RespondWithOperationInProgress(),
				mockbroker.LastOperation(instanceID, operationData).RespondWithOperationSucceeded(),
			)

			runningTool := helpers.StartBinaryWithParams(binaryPath, validParams)

			Eventually(runningTool, 5*time.Second).Should(gexec.Exit(0))
			Expect(runningTool).To(gbytes.Say("Sleep interval until next attempt: 1s"))
			Expect(runningTool).To(gbytes.Say("Number of successful upgrades: 1"))
		})
	})

	Context("when the upgrade errors", func() {
		It("exits non-zero with the error message", func() {
			odb.VerifyAndMock(
				mockbroker.ListInstances().RespondsUnauthorizedWith(""),
			)

			runningTool := helpers.StartBinaryWithParams(binaryPath, validParams)

			Eventually(runningTool).Should(gexec.Exit(1))
			Expect(runningTool).To(gbytes.Say("error listing service instances: HTTP response status: 401 Unauthorized"))
		})
	})

	Context("when the upgrade tool is misconfigured", func() {
		It("fails with blank brokerUsername", func() {
			runningTool := helpers.StartBinaryWithParams(binaryPath, []string{"-brokerUsername", "", "-brokerPassword", brokerPassword, "-brokerUrl", odb.URL, "-pollingInterval", "1"})

			Eventually(runningTool).Should(gexec.Exit(1))
			Expect(runningTool).To(gbytes.Say("the brokerUsername, brokerPassword and brokerUrl are required to function"))
		})

		It("fails with blank brokerPassword", func() {
			runningTool := helpers.StartBinaryWithParams(binaryPath, []string{"-brokerUsername", brokerUsername, "-brokerPassword", "", "-brokerUrl", odb.URL, "-pollingInterval", "1"})

			Eventually(runningTool).Should(gexec.Exit(1))
			Expect(runningTool).To(gbytes.Say("the brokerUsername, brokerPassword and brokerUrl are required to function"))
		})

		It("fails with blank brokerUrl", func() {
			runningTool := helpers.StartBinaryWithParams(binaryPath, []string{"-brokerUsername", brokerUsername, "-brokerPassword", brokerPassword, "-brokerUrl", "", "-pollingInterval", "1"})

			Eventually(runningTool).Should(gexec.Exit(1))
			Expect(runningTool).To(gbytes.Say("the brokerUsername, brokerPassword and brokerUrl are required to function"))
		})

		It("fails with blank pollingInterval", func() {
			runningTool := helpers.StartBinaryWithParams(binaryPath, []string{"-brokerUsername", brokerUsername, "-brokerPassword", brokerPassword, "-brokerUrl", odb.URL, "-pollingInterval", ""})

			Eventually(runningTool).Should(gexec.Exit(2))
			Expect(runningTool.Err).To(gbytes.Say("invalid value"))
		})

		It("fails with pollingInterval of zero", func() {
			runningTool := helpers.StartBinaryWithParams(binaryPath, []string{"-brokerUsername", brokerUsername, "-brokerPassword", brokerPassword, "-brokerUrl", odb.URL, "-pollingInterval", "0"})

			Eventually(runningTool).Should(gexec.Exit(1))
			Expect(runningTool).To(gbytes.Say("the pollingInterval must be greater than zero"))
		})

		It("fails with pollingInterval less than zero", func() {
			runningTool := helpers.StartBinaryWithParams(binaryPath, []string{"-brokerUsername", brokerUsername, "-brokerPassword", brokerPassword, "-brokerUrl", odb.URL, "-pollingInterval", "-123"})

			Eventually(runningTool).Should(gexec.Exit(1))
			Expect(runningTool).To(gbytes.Say("the pollingInterval must be greater than zero"))
		})

		It("fails without brokerUsername flag", func() {
			runningTool := helpers.StartBinaryWithParams(binaryPath, []string{"-brokerPassword", "bar", "-brokerUrl", "bar", "-pollingInterval", "1"})

			Eventually(runningTool).Should(gexec.Exit(1))
			Expect(runningTool).To(gbytes.Say("the brokerUsername, brokerPassword and brokerUrl are required to function"))
		})

		It("fails without brokerPassword flag", func() {
			runningTool := helpers.StartBinaryWithParams(binaryPath, []string{"-brokerUsername", "bar", "-brokerUrl", "bar", "-pollingInterval", "1"})

			Eventually(runningTool).Should(gexec.Exit(1))
			Expect(runningTool).To(gbytes.Say("the brokerUsername, brokerPassword and brokerUrl are required to function"))
		})

		It("fails without brokerUrl flag", func() {
			runningTool := helpers.StartBinaryWithParams(binaryPath, []string{"-brokerUsername", "bar", "-brokerPassword", "bar", "-pollingInterval", "1"})

			Eventually(runningTool).Should(gexec.Exit(1))
			Eventually(runningTool).Should(gbytes.Say("the brokerUsername, brokerPassword and brokerUrl are required to function"))
		})

		It("fails without pollingInterval flag", func() {
			runningTool := helpers.StartBinaryWithParams(binaryPath, []string{"-brokerUsername", "bar", "-brokerPassword", "bar", "-brokerUrl", "bar"})

			Eventually(runningTool).Should(gexec.Exit(1))
			Eventually(runningTool).Should(gbytes.Say("the pollingInterval must be greater than zero"))
		})
	})
})
