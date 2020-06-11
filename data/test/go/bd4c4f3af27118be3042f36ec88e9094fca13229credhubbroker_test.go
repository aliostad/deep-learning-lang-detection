package credhubbroker_test

import (
	"context"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/pivotal-cf/brokerapi"
	apifakes "github.com/pivotal-cf/on-demand-service-broker/apiserver/fakes"
	"github.com/pivotal-cf/on-demand-service-broker/credhubbroker"
	credfakes "github.com/pivotal-cf/on-demand-service-broker/credhubbroker/fakes"
)

var _ = Describe("CredHub broker", func() {
	var (
		fakeBroker *apifakes.FakeCombinedBrokers
		ctx        context.Context
		instanceID string
		bindingID  string
		details    brokerapi.BindDetails
		credhubKey string
	)

	BeforeEach(func() {
		fakeBroker = new(apifakes.FakeCombinedBrokers)
		ctx = context.Background()
		instanceID = "ohai"
		bindingID = "rofl"
		details = brokerapi.BindDetails{
			ServiceID: "big-hybrid-cloud-of-things",
		}
		credhubKey = "/c/big-hybrid-cloud-of-things/ohai/rofl/credentials"
	})

	It("passes the return value through from the wrapped broker", func() {
		expectedBindingResponse := brokerapi.Binding{
			Credentials: "anything",
		}
		fakeBroker.BindReturns(expectedBindingResponse, nil)

		fakeCredStore := new(credfakes.FakeCredentialStore)
		credhubBroker := credhubbroker.New(fakeBroker, fakeCredStore)
		Expect(credhubBroker.Bind(ctx, instanceID, bindingID, details)).To(Equal(expectedBindingResponse))
	})

	It("stores credentials", func() {
		fakeCredStore := new(credfakes.FakeCredentialStore)
		creds := "justAString"
		bindingResponse := brokerapi.Binding{
			Credentials: creds,
		}
		fakeBroker.BindReturns(bindingResponse, nil)

		credhubBroker := credhubbroker.New(fakeBroker, fakeCredStore)
		credhubBroker.Bind(ctx, instanceID, bindingID, details)

		key, receivedCreds := fakeCredStore.SetArgsForCall(0)
		Expect(key).To(Equal(credhubKey))
		Expect(receivedCreds).To(Equal(creds))
	})
})
