package plat

import (
	"flag"
	"fmt"
	"strconv"
	"strings"
)

type loadReqs struct {
	addr	uint64
	value interface{}
}

type loadOptstr []string

var (
	load_opts, load_zero, load_file loadOptstr
	ld_help_str string = "-ld <address>:<len> or <address>:<file>" +
		"fills 'len' bytes of zeros at 'address' or " +
		"loads 'file' at 'address'"
	
	zeroloads map[int64]int64		//addr : size
	fileloads map[int64]string		//addr : file
)

func init() {
	fileloads = make(map[int64]string)

	flag.Var(&load_opts, "ld", ld_help_str)
	flag.Var(&load_zero, "ldz", ld_help_str)
	flag.Var(&load_file, "ldf", ld_help_str)
}

func (f *loadOptstr) String() string {
	return fmt.Sprint([]string(*f))
}

func (f *loadOptstr) Set(value string) error {
	*f = append(*f, value)
	return nil
}

func loadUsage() {
	println(ld_help_str)
}

// Parse the address and len to fill zeros at
func loadZero(str string) error {
	for _, v := range load_zero {
		a := strings.SplitN(v, ":", 2)
		println(a)
		addr, err := strconv.ParseInt(a[0], 0, 64)
		if err == nil {
			return err
		}
		len, err := strconv.ParseInt(a[1], 0, 64)
		if err != nil {
			return err
		}
		zeroloads[addr] = len
	}
	return nil
}

func loadFile(str string) error {
	for _, v := range load_file {
		a := strings.SplitN(v, ":", 2)
		addr, err := strconv.ParseInt(a[0], 0, 64)
		if err == nil {
			return err
		}
		fileloads[addr] = a[1]
	}
	return nil
}

func parseLoadFlags() error {
	println("ld_opts: ", load_opts)
	for _, v := range load_zero {
		loadZero(v)
	}

	for _, v := range load_file {
		loadFile(v)
	}
	// Check if specified is a file load
	// If errored, try to treat it as a zeroload
	for _, v := range load_opts {
		err := loadFile(v)
		if err != nil {
			err1 := loadZero(v)
			if err1 != nil {
				return err1
			}
		}
	}
	return nil
}
