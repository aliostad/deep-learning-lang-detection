package cpi_test

import (
	"errors"

	"github.com/tscolari/bosh-c3pi/cloud"
	"github.com/tscolari/bosh-c3pi/cloud/fakes"
	"github.com/tscolari/bosh-c3pi/cpi"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("Dispatcher", func() {
	var cpiClient *fakes.FakeCloud
	var subject *cpi.Dispatcher
	var methodName string
	var arguments cpi.RequestArguments

	BeforeEach(func() {
		cpiClient = new(fakes.FakeCloud)
		subject = cpi.NewDispatcher(cpiClient, logger)
	})

	Context("VM Operations", func() {
		Describe("has_vm", func() {
			BeforeEach(func() {
				methodName = "has_vm"
				arguments = []interface{}{"12345"}
			})

			It("calls the correct method in the cloud object", func() {
				subject.Dispatch(methodName, arguments)
				Expect(cpiClient.HasVmCallCount()).To(Equal(1))
			})

			It("calls the cloud object method with the correct arguments", func() {
				subject.Dispatch(methodName, arguments)
				Expect(cpiClient.HasVmArgsForCall(0)).To(Equal("12345"))
			})

			It("returns no error", func() {
				_, err := subject.Dispatch(methodName, arguments)
				Expect(err).ToNot(HaveOccurred())
			})

			Context("when the VM exists", func() {
				BeforeEach(func() {
					cpiClient.HasVmReturns(true, nil)
				})

				It("returns a response with true", func() {
					result, _ := subject.Dispatch(methodName, arguments)
					Expect(result).To(Equal(true))
				})
			})

			Context("when the VM does not exist", func() {
				BeforeEach(func() {
					cpiClient.HasVmReturns(false, nil)
				})

				It("returns a response with true", func() {
					result, _ := subject.Dispatch(methodName, arguments)
					Expect(result).To(Equal(false))
				})
			})

			Context("when the cloud client fails", func() {
				var expectedError error

				BeforeEach(func() {
					expectedError = errors.New("failed here")
					cpiClient.HasVmReturns(true, expectedError)
				})

				It("returns the error", func() {
					_, err := subject.Dispatch(methodName, arguments)
					Expect(err).To(MatchError("failed here"))
				})
			})
		})

		Describe("set_vm_metadata", func() {
			BeforeEach(func() {
				methodName = "set_vm_metadata"
				arguments = []interface{}{
					"12345",
					map[string]interface{}{
						"test": "test1",
					},
				}
			})

			It("calls the correct method in the cloud object", func() {
				subject.Dispatch(methodName, arguments)
				Expect(cpiClient.SetVmMetadataCallCount()).To(Equal(1))
			})

			It("calls the cloud object method with the correct arguments", func() {
				subject.Dispatch(methodName, arguments)
				vmID, metadata := cpiClient.SetVmMetadataArgsForCall(0)
				Expect(vmID).To(Equal("12345"))
				Expect(metadata).To(Equal(cloud.Metadata{"test": "test1"}))
			})

			It("returns no error", func() {
				_, err := subject.Dispatch(methodName, arguments)
				Expect(err).ToNot(HaveOccurred())
			})

			It("returns no result", func() {
				result, _ := subject.Dispatch(methodName, arguments)
				Expect(result).To(BeNil())
			})

			Context("when the cloud client fails", func() {
				var expectedError error

				BeforeEach(func() {
					expectedError = errors.New("failed here")
					cpiClient.SetVmMetadataReturns(expectedError)
				})

				It("returns the error", func() {
					_, err := subject.Dispatch(methodName, arguments)
					Expect(err).To(MatchError("failed here"))
				})
			})
		})

		Describe("delete_vm", func() {
			BeforeEach(func() {
				methodName = "delete_vm"
				arguments = []interface{}{
					"12345",
				}
			})

			It("calls the correct method in the cloud object", func() {
				subject.Dispatch(methodName, arguments)
				Expect(cpiClient.DeleteVmCallCount()).To(Equal(1))
			})

			It("calls the cloud object method with the correct arguments", func() {
				subject.Dispatch(methodName, arguments)
				vmID := cpiClient.DeleteVmArgsForCall(0)
				Expect(vmID).To(Equal("12345"))
			})

			It("returns no error", func() {
				_, err := subject.Dispatch(methodName, arguments)
				Expect(err).ToNot(HaveOccurred())
			})

			It("returns no result", func() {
				result, _ := subject.Dispatch(methodName, arguments)
				Expect(result).To(BeNil())
			})

			Context("when the cloud client fails", func() {
				var expectedError error

				BeforeEach(func() {
					expectedError = errors.New("failed here")
					cpiClient.DeleteVmReturns(expectedError)
				})

				It("returns the error", func() {
					_, err := subject.Dispatch(methodName, arguments)
					Expect(err).To(MatchError("failed here"))
				})
			})
		})

		Describe("reboot_vm", func() {
			BeforeEach(func() {
				methodName = "reboot_vm"
				arguments = []interface{}{
					"12345",
				}
			})

			It("calls the correct method in the cloud object", func() {
				subject.Dispatch(methodName, arguments)
				Expect(cpiClient.RebootVmCallCount()).To(Equal(1))
			})

			It("calls the cloud object method with the correct arguments", func() {
				subject.Dispatch(methodName, arguments)
				vmID := cpiClient.RebootVmArgsForCall(0)
				Expect(vmID).To(Equal("12345"))
			})

			It("returns no error", func() {
				_, err := subject.Dispatch(methodName, arguments)
				Expect(err).ToNot(HaveOccurred())
			})

			It("returns no result", func() {
				result, _ := subject.Dispatch(methodName, arguments)
				Expect(result).To(BeNil())
			})

			Context("when the cloud client fails", func() {
				var expectedError error

				BeforeEach(func() {
					expectedError = errors.New("failed here")
					cpiClient.RebootVmReturns(expectedError)
				})

				It("returns the error", func() {
					_, err := subject.Dispatch(methodName, arguments)
					Expect(err).To(MatchError("failed here"))
				})
			})
		})

		Describe("create_vm", func() {
			var cloudProperties map[string]interface{}
			var networks map[string]interface{}
			var env map[string]interface{}

			BeforeEach(func() {

				cloudProperties = map[string]interface{}{"key": "value"}
				networks = map[string]interface{}{"net1": cloud.Network{IP: "10.10.10.1"}}
				env = map[string]interface{}{"VAR1": "value"}

				methodName = "create_vm"
				arguments = []interface{}{
					"agent-1",
					"stemcell-1",
					cloudProperties,
					networks,
					"disk-local",
					env,
				}
			})

			It("calls the correct method in the cloud object", func() {
				subject.Dispatch(methodName, arguments)
				Expect(cpiClient.CreateVmCallCount()).To(Equal(1))
			})

			It("calls the cloud object method with the correct arguments", func() {
				subject.Dispatch(methodName, arguments)
				agentID, stemcellID, cloudProperties_, networks_, diskLocality, env_ := cpiClient.CreateVmArgsForCall(0)

				Expect(agentID).To(Equal("agent-1"))
				Expect(stemcellID).To(Equal("stemcell-1"))
				Expect(cloudProperties_).To(Equal(cloudProperties))
				Expect(networks_).To(Equal(networks))
				Expect(diskLocality).To(Equal("disk-local"))
				Expect(env_).To(Equal(env))
			})

			It("returns no error", func() {
				_, err := subject.Dispatch(methodName, arguments)
				Expect(err).ToNot(HaveOccurred())
			})

			It("returns the correct vm-id as result", func() {
				cpiClient.CreateVmReturns("12345", nil)
				result, _ := subject.Dispatch(methodName, arguments)
				Expect(result).To(Equal("12345"))
			})

			Context("when the cloud client fails", func() {
				var expectedError error

				BeforeEach(func() {
					expectedError = errors.New("failed here")
					cpiClient.CreateVmReturns("", expectedError)
				})

				It("returns the error", func() {
					_, err := subject.Dispatch(methodName, arguments)
					Expect(err).To(MatchError("failed here"))
				})
			})
		})
	})
})
