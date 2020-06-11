package repository

import (
	"bytes"
)

var protocol = https

const (
	https = iota
	ssh
)

func UseHTTPS() {
	protocol = https
}

func UseSSH() {
	protocol = ssh
}

func specifyURL(domain, user, repo string) string {
	var buf bytes.Buffer
	switch protocol {
	case ssh:
		buf.WriteString("git@")
		buf.WriteString(domain)
		buf.WriteString(":")
	case https:
		fallthrough
	default:
		buf.WriteString("https://")
		buf.WriteString(domain)
		buf.WriteString("/")
	}
	buf.WriteString(user)
	buf.WriteString("/")
	buf.WriteString(repo)
	buf.WriteString(".git")
	return buf.String()
}
