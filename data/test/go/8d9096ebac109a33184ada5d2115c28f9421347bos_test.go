package ios_test

import (
	. "github.com/onsi/ginkgo"

	"github.com/BooleanCat/igo/ios"
)

var _ = Describe("ios", func() {
	Describe("OS", func() {
		It("is implemented by Real", func() {
			var _ ios.OS = ios.New()
		})

		It("is implemented by Fake", func() {
			var _ ios.OS = ios.NewFake()
		})
	})

	Describe("Process", func() {
		It("is implemented by ProcessReal", func() {
			var _ ios.Process = ios.NewProcess()
		})

		It("is implemented by ProcessFake", func() {
			var _ ios.Process = ios.NewProcessFake()
		})
	})

	Describe("ProcessState", func() {
		It("is implemented by ProcessStateReal", func() {
			var _ ios.ProcessState = ios.NewProcessState()
		})

		It("is implemented by ProcessStateFake", func() {
			var _ ios.ProcessState = ios.NewProcessStateFake()
		})
	})
})
