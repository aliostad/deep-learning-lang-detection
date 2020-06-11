package fbmessenger_test

import (
	. "github.com/ekyoung/fbmessenger"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("MessageEntryHandlerDispatcher", func() {
	var (
		messageHandlerCalls        int
		deliveryHandlerCalls       int
		postbackHandlerCalls       int
		authenticationHandlerCalls int
	)

	messageHandler := func(entry *MessagingEntry) error {
		messageHandlerCalls++
		return nil
	}

	deliveryHandler := func(entry *MessagingEntry) error {
		deliveryHandlerCalls++
		return nil
	}

	postbackHandler := func(entry *MessagingEntry) error {
		postbackHandlerCalls++
		return nil
	}

	authenticationHandler := func(entry *MessagingEntry) error {
		authenticationHandlerCalls++
		return nil
	}

	BeforeEach(func() {
		messageHandlerCalls = 0
		deliveryHandlerCalls = 0
		postbackHandlerCalls = 0
		authenticationHandlerCalls = 0
	})

	It("should dispatch message callbacks to the message handler", func() {
		dispatcher := &CallbackDispatcher{
			MessageHandler: messageHandler,
		}

		dispatcher.Dispatch(createMessageCallback())

		Expect(messageHandlerCalls).To(Equal(1))
	})

	It("should dispatch delivery callbacks to the delivery handler", func() {
		dispatcher := &CallbackDispatcher{
			DeliveryHandler: deliveryHandler,
		}

		dispatcher.Dispatch(createDeliveryCallback())

		Expect(deliveryHandlerCalls).To(Equal(1))
	})

	It("should dispatch postback callbacks to the postback handler", func() {
		dispatcher := &CallbackDispatcher{
			PostbackHandler: postbackHandler,
		}

		dispatcher.Dispatch(createPostbackCallback())

		Expect(postbackHandlerCalls).To(Equal(1))
	})

	It("should dispatch authentication callbacks to the authentication handler", func() {
		dispatcher := &CallbackDispatcher{
			AuthenticationHandler: authenticationHandler,
		}

		dispatcher.Dispatch(createAuthenticationCallback())

		Expect(authenticationHandlerCalls).To(Equal(1))
	})

	It("should not dispatch callbacks when there is no registered handler", func() {
		dispatcher := &CallbackDispatcher{}

		dispatcher.Dispatch(createMessageCallback())
		dispatcher.Dispatch(createDeliveryCallback())
		dispatcher.Dispatch(createPostbackCallback())
		dispatcher.Dispatch(createAuthenticationCallback())

		Expect(messageHandlerCalls).To(Equal(0))
		Expect(deliveryHandlerCalls).To(Equal(0))
		Expect(postbackHandlerCalls).To(Equal(0))
		Expect(authenticationHandlerCalls).To(Equal(0))
	})
})

func createMessageCallback() *Callback {
	cb := createCallback()

	cb.Entries[0].Messaging = []*MessagingEntry{
		&MessagingEntry{
			Sender:    Principal{Id: "456"},
			Recipient: Principal{Id: "765"},
			Timestamp: 876,
			Message: &CallbackMessage{
				MessageId: "mid.3345",
				Sequence:  89,
				Text:      "Some text.",
			},
		},
	}

	return cb
}

func createDeliveryCallback() *Callback {
	cb := createCallback()

	cb.Entries[0].Messaging = []*MessagingEntry{
		&MessagingEntry{
			Sender:    Principal{Id: "456"},
			Recipient: Principal{Id: "765"},
			Delivery: &Delivery{
				MessageIds: []string{"mid.123", "mid.345"},
				Watermark:  234,
				Sequence:   87,
			},
		},
	}

	return cb
}

func createPostbackCallback() *Callback {
	cb := createCallback()

	cb.Entries[0].Messaging = []*MessagingEntry{
		&MessagingEntry{
			Sender:    Principal{Id: "456"},
			Recipient: Principal{Id: "765"},
			Timestamp: 876,
			Postback: &Postback{
				Payload: "USER_DEFINED_PAYLOAD",
			},
		},
	}

	return cb
}

func createAuthenticationCallback() *Callback {
	cb := createCallback()

	cb.Entries[0].Messaging = []*MessagingEntry{
		&MessagingEntry{
			Sender:    Principal{Id: "456"},
			Recipient: Principal{Id: "765"},
			Timestamp: 876,
			OptIn: &OptIn{
				Ref: "PASS_THROUGH_PARAM",
			},
		},
	}

	return cb
}

func createCallback() *Callback {
	return &Callback{
		Object: "page",
		Entries: []*Entry{
			&Entry{
				PageId: "123",
				Time:   345,
			},
		},
	}
}
