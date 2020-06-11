package lxi

import (
	"bufio"
	"fmt"
	"net"
	"strings"
)

// DP832 .
type Conn struct {
	conn net.Conn
	Addr string // tcp address to device
}

// Instrument .
type Instrument struct {
	Manufacturer string
	Model        string
	Serial       string
	Version      string
}

func (d *Conn) Command(commands ...string) (string, error) {
	command := strings.Join(commands, ":")
	_, err := fmt.Fprintf(d.conn, fmt.Sprintf("%s\n", command)) //
	if err != nil {
		return "", err
	}
	result, err := bufio.NewReader(d.conn).ReadString('\n')
	if err != nil {
		return "", err
	}
	result = strings.TrimRight(result, "\n")
	// log.Println(result)
	return result, nil
}

func (d *Conn) Connect() error {
	if d.conn == nil {
		conn, err := net.Dial("tcp", d.Addr)
		if err != nil {
			return err
		}
		d.conn = conn
	}
	_, err := d.IDN()
	if err != nil {
		return err
	}
	return nil
}

func (d *Conn) IDN() (Instrument, error) {
	var i Instrument
	s, err := d.Command("*IDN?")
	if err != nil {
		return i, err
	}
	a := strings.Split(s, ",")
	i.Manufacturer = a[0]
	i.Model = a[1]
	i.Serial = a[2]
	i.Version = a[3]
	return i, nil
}
