package esendex

import (
	"encoding/xml"
	"time"
)

type MessageType string

const (
	SMS   MessageType = "SMS"
	Voice MessageType = "Voice"
)

// Message is a message to send.
type Message struct {
	To           string
	From         string
	MessageType  MessageType
	Lang         string
	Validity     int
	CharacterSet string
	Retries      int
	Body         string
}

// SendResponse gives the batchid for the sent batch and lists the details of
// each message sent.
type SendResponse struct {
	BatchID  string
	Messages []SendResponseMessage
}

// SendResponseMessage gives the details for a single sent message.
type SendResponseMessage struct {
	URI string
	ID  string
}

// Send dispatches a list of messages.
func (c *AccountClient) Send(messages []Message) (*SendResponse, error) {
	body := messageDispatchRequest{
		AccountReference: c.reference,
		Message:          make([]messageDispatchRequestMessage, len(messages)),
	}

	return c.doSend(body, messages)
}

// SendFrom dispatches a list of messages and overrides the default originator.
func (c *AccountClient) SendFrom(from string, messages []Message) (*SendResponse, error) {
	body := messageDispatchRequest{
		AccountReference: c.reference,
		From:             from,
		Message:          make([]messageDispatchRequestMessage, len(messages)),
	}

	return c.doSend(body, messages)
}

// SendAt schedules a list of messages for dispatch.
func (c *AccountClient) SendAt(sendAt time.Time, messages []Message) (*SendResponse, error) {
	body := messageDispatchRequest{
		AccountReference: c.reference,
		SendAt:           &sendAt,
		Message:          make([]messageDispatchRequestMessage, len(messages)),
	}

	return c.doSend(body, messages)
}

func (c *AccountClient) doSend(body messageDispatchRequest, messages []Message) (*SendResponse, error) {
	for i, message := range messages {
		body.Message[i] = messageDispatchRequestMessage{
			To:           message.To,
			From:         message.From,
			MessageType:  string(message.MessageType),
			Lang:         message.Lang,
			Validity:     message.Validity,
			CharacterSet: message.CharacterSet,
			Retries:      message.Retries,
			Body:         message.Body,
		}
	}

	req, err := c.newRequest("POST", "/v1.0/messagedispatcher", &body)
	if err != nil {
		return nil, err
	}

	var v messageDispatchResponse
	if _, err = c.do(req, &v); err != nil {
		return nil, err
	}

	response := &SendResponse{
		BatchID:  v.BatchID,
		Messages: make([]SendResponseMessage, len(v.MessageHeader)),
	}

	for i, message := range v.MessageHeader {
		response.Messages[i] = SendResponseMessage{
			URI: message.URI,
			ID:  message.ID,
		}
	}

	return response, nil
}

type messageDispatchRequest struct {
	XMLName          xml.Name                        `xml:"messages"`
	AccountReference string                          `xml:"accountreference"`
	SendAt           *time.Time                      `xml:"sendat"`
	From             string                          `xml:"from,omitempty"`
	Message          []messageDispatchRequestMessage `xml:"message"`
}

type messageDispatchRequestMessage struct {
	To           string `xml:"to"`
	From         string `xml:"from,omitempty"`
	MessageType  string `xml:"type,omitempty"`
	Lang         string `xml:"lang,omitempty"`
	Validity     int    `xml:"validity,omitempty"`
	CharacterSet string `xml:"characterset,omitempty"`
	Retries      int    `xml:"retries,omitempty"`
	Body         string `xml:"body"`
}

type messageDispatchResponse struct {
	XMLName       xml.Name `xml:"http://api.esendex.com/ns/ messageheaders"`
	BatchID       string   `xml:"batchid,attr"`
	MessageHeader []struct {
		URI string `xml:"uri,attr"`
		ID  string `xml:"id,attr"`
	} `xml:"messageheader"`
}
