package tg_test

// This example creates a basic client that connects to a broker and checks for message containing greetings.
// If it finds a greeting message it will greet back the user (using the reply_to parameter)
func ExampleCreateBrokerClient() {
	CreateBrokerClient("localhost:7314", func(broker *Broker, message APIMessage) {
		// Check if it's a text message
		if message.Text != nil {
			// Check that it's a greeting
			if *(message.Text) == "hello" || *(message.Text) == "hi" {
				// Reply with a greeting!
				broker.SendTextMessage(message.Chat, "Hello!", message.MessageID)
			}
		}
	})
}
