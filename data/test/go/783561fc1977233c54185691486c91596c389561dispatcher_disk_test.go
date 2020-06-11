package cpi_test

import (
	"errors"
	"fmt"

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

	Context("Disk Operations", func() {
		Describe("create_disk", func() {
			var cloudProperties map[string]interface{}

			BeforeEach(func() {
				cloudProperties = map[string]interface{}{"key": "value"}
				methodName = "create_disk"

				arguments = []interface{}{
					128,
					cloudProperties,
					"vm-id-1",
				}
			})

			It("calls the correct method in the cloud object", func() {
				subject.Dispatch(methodName, arguments)
				Expect(cpiClient.CreateDiskCallCount()).To(Equal(1))
			})

			FIt("calls the cloud object method with the correct arguments", func() {
				subject.Dispatch(methodName, arguments)
				size, cloudProperties_, vmLocality := cpiClient.CreateDiskArgsForCall(0)
				Expect(size).To(Equal(128))
				fmt.Printf("----------- %#v\n", cloudProperties_)
				fmt.Printf("----------- %#v\n", cloudProperties)
				Expect(cloudProperties_).To(Equal(cloudProperties))
				Expect(vmLocality).To(Equal("vm-id-1"))
			})

			It("returns no error", func() {
				_, err := subject.Dispatch(methodName, arguments)
				Expect(err).ToNot(HaveOccurred())
			})

			It("returns the stemcell id as result", func() {
				cpiClient.CreateDiskReturns("disk-id-1", nil)
				result, _ := subject.Dispatch(methodName, arguments)
				Expect(result).To(Equal("disk-id-1"))
			})

			Context("when the cloud client fails", func() {
				var expectedError error

				BeforeEach(func() {
					expectedError = errors.New("failed here")
					cpiClient.CreateDiskReturns("", expectedError)
				})

				It("returns the error", func() {
					_, err := subject.Dispatch(methodName, arguments)
					Expect(err).To(MatchError("failed here"))
				})
			})
		})

		Describe("get_disks", func() {
			BeforeEach(func() {
				methodName = "get_disks"
				arguments = []interface{}{
					"vm-id-1",
				}
			})

			It("calls the correct method in the cloud object", func() {
				subject.Dispatch(methodName, arguments)
				Expect(cpiClient.GetDisksCallCount()).To(Equal(1))
			})

			It("calls the cloud object method with the correct arguments", func() {
				subject.Dispatch(methodName, arguments)
				vmID := cpiClient.GetDisksArgsForCall(0)
				Expect(vmID).To(Equal("vm-id-1"))
			})

			It("returns no error", func() {
				_, err := subject.Dispatch(methodName, arguments)
				Expect(err).ToNot(HaveOccurred())
			})

			It("returns the stemcell id as result", func() {
				cpiClient.GetDisksReturns([]string{"disk-id-1", "disk-id-2"}, nil)
				result, _ := subject.Dispatch(methodName, arguments)
				Expect(result).To(Equal([]string{"disk-id-1", "disk-id-2"}))
			})

			Context("when the cloud client fails", func() {
				var expectedError error

				BeforeEach(func() {
					expectedError = errors.New("failed here")
					cpiClient.GetDisksReturns(nil, expectedError)
				})

				It("returns the error", func() {
					_, err := subject.Dispatch(methodName, arguments)
					Expect(err).To(MatchError("failed here"))
				})
			})
		})

		Describe("has_disk", func() {
			BeforeEach(func() {
				methodName = "has_disk"

				arguments = []interface{}{
					"disk-id-1",
				}
			})

			It("calls the correct method in the cloud object", func() {
				subject.Dispatch(methodName, arguments)
				Expect(cpiClient.HasDiskCallCount()).To(Equal(1))
			})

			It("calls the cloud object method with the correct arguments", func() {
				subject.Dispatch(methodName, arguments)
				diskID := cpiClient.HasDiskArgsForCall(0)
				Expect(diskID).To(Equal("disk-id-1"))
			})

			It("returns no error", func() {
				_, err := subject.Dispatch(methodName, arguments)
				Expect(err).ToNot(HaveOccurred())
			})

			It("returns the true/false as result", func() {
				cpiClient.HasDiskReturns(false, nil)
				result, _ := subject.Dispatch(methodName, arguments)
				Expect(result).To(Equal(false))
			})

			Context("when the cloud client fails", func() {
				var expectedError error

				BeforeEach(func() {
					expectedError = errors.New("failed here")
					cpiClient.HasDiskReturns(true, expectedError)
				})

				It("returns the error", func() {
					_, err := subject.Dispatch(methodName, arguments)
					Expect(err).To(MatchError("failed here"))
				})
			})
		})

		Describe("delete_disk", func() {
			BeforeEach(func() {
				methodName = "delete_disk"
				arguments = []interface{}{
					"disk-id-1",
				}
			})

			It("calls the correct method in the cloud object", func() {
				subject.Dispatch(methodName, arguments)
				Expect(cpiClient.DeleteDiskCallCount()).To(Equal(1))
			})

			It("calls the cloud object method with the correct arguments", func() {
				subject.Dispatch(methodName, arguments)
				diskID := cpiClient.DeleteDiskArgsForCall(0)
				Expect(diskID).To(Equal("disk-id-1"))
			})

			It("returns no error", func() {
				_, err := subject.Dispatch(methodName, arguments)
				Expect(err).ToNot(HaveOccurred())
			})

			Context("when the cloud client fails", func() {
				var expectedError error

				BeforeEach(func() {
					expectedError = errors.New("failed here")
					cpiClient.DeleteDiskReturns(expectedError)
				})

				It("returns the error", func() {
					_, err := subject.Dispatch(methodName, arguments)
					Expect(err).To(MatchError("failed here"))
				})
			})
		})

		Describe("attach_disk", func() {
			BeforeEach(func() {
				methodName = "attach_disk"
				arguments = []interface{}{
					"vm-id-1",
					"disk-id-1",
				}
			})

			It("calls the correct method in the cloud object", func() {
				subject.Dispatch(methodName, arguments)
				Expect(cpiClient.AttachDiskCallCount()).To(Equal(1))
			})

			It("calls the cloud object method with the correct arguments", func() {
				subject.Dispatch(methodName, arguments)
				vmID, diskID := cpiClient.AttachDiskArgsForCall(0)
				Expect(vmID).To(Equal("vm-id-1"))
				Expect(diskID).To(Equal("disk-id-1"))
			})

			It("returns no error", func() {
				_, err := subject.Dispatch(methodName, arguments)
				Expect(err).ToNot(HaveOccurred())
			})

			Context("when the cloud client fails", func() {
				var expectedError error

				BeforeEach(func() {
					expectedError = errors.New("failed here")
					cpiClient.AttachDiskReturns(expectedError)
				})

				It("returns the error", func() {
					_, err := subject.Dispatch(methodName, arguments)
					Expect(err).To(MatchError("failed here"))
				})
			})
		})

		Describe("detach_disk", func() {
			BeforeEach(func() {
				methodName = "detach_disk"
				arguments = []interface{}{
					"vm-id-1",
					"disk-id-1",
				}
			})

			It("calls the correct method in the cloud object", func() {
				subject.Dispatch(methodName, arguments)
				Expect(cpiClient.DetachDiskCallCount()).To(Equal(1))
			})

			It("calls the cloud object method with the correct arguments", func() {
				subject.Dispatch(methodName, arguments)
				vmID, diskID := cpiClient.DetachDiskArgsForCall(0)
				Expect(vmID).To(Equal("vm-id-1"))
				Expect(diskID).To(Equal("disk-id-1"))
			})

			It("returns no error", func() {
				_, err := subject.Dispatch(methodName, arguments)
				Expect(err).ToNot(HaveOccurred())
			})

			Context("when the cloud client fails", func() {
				var expectedError error

				BeforeEach(func() {
					expectedError = errors.New("failed here")
					cpiClient.DetachDiskReturns(expectedError)
				})

				It("returns the error", func() {
					_, err := subject.Dispatch(methodName, arguments)
					Expect(err).To(MatchError("failed here"))
				})
			})
		})
	})
})
