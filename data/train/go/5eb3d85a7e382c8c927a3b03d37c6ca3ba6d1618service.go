package email

import (
	"bytes"
	"log"
	"net/smtp"

	"github.com/discoviking/website/server/message"
)

type Service struct {
	from string
	to   string
}

func NewService(from, to string) *Service {
	return &Service{
		from: from,
		to:   to,
	}
}

func (s *Service) Send(m message.Message) error {
	log.Printf("Send Email from %v to %v", m.Email, s.to)

	// Build email mesasge as described in net/smtp docs.
	b := bytes.Buffer{}

	b.WriteString("From: ")
	b.WriteString(m.Sender + " <" + m.Email + ">")
	b.WriteString("\r\n")

	b.WriteString("Sender: ")
	b.WriteString(s.from)
	b.WriteString("\r\n")

	b.WriteString("To: ")
	b.WriteString(s.to)
	b.WriteString("\r\n")

	b.WriteString("Reply-to: ")
	b.WriteString(m.Sender + " <" + m.Email + ">")
	b.WriteString("\r\n")

	b.WriteString("Subject: ")
	b.WriteString("Message from " + m.Sender + " via webform")
	b.WriteString("\r\n")

	// Separate body from headers by empty line.
	b.WriteString("\r\n")

	b.WriteString("Name: " + m.Sender + "\n")
	b.WriteString("Email: " + m.Email + "\n")
	b.WriteString("Message: \n\n")
	b.WriteString(m.Message)
	b.WriteString("\r\n")

	msg := b.String()
	log.Print(msg)

	// Send using local mail server.
	err := smtp.SendMail("localhost:smtp", nil, s.from, []string{s.to}, []byte(msg))

	return err
}
