package main

import (
	"fmt"
	"net/smtp"
	"strconv"
)

type emailManager struct {
	Login    string
	Password string
	Host     string
	Port     int
}

func NewEmailManager() *emailManager {
	manager := new(emailManager)
	manager.Login = GlobalConfig.Email.Login
	manager.Password = GlobalConfig.Email.Password
	manager.Host = GlobalConfig.Email.Host
	manager.Port = GlobalConfig.Email.Port
	return manager
}

func (manager emailManager) Send(to string, subject string, content string) {
	auth := smtp.PlainAuth("", manager.Login, manager.Password, manager.Host)
	recipients := []string{to}

	message := fmt.Sprintf("To: %s \r\n"+
		"Subject: %s !\r\n"+
		"\r\n"+
		"%s \r\n", to, subject, content)

	msg := []byte(message)
	hostString := manager.Host + ":" + strconv.Itoa(manager.Port)
	err := smtp.SendMail(hostString, auth, manager.Login, recipients, msg)
	failOnError(err, "Cannot send email")
}
