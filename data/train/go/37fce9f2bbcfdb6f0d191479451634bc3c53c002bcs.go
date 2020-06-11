package bcs

import (
	"fmt"
	"bytes"
	"crypto/hmac"
	"crypto/sha1"
	"encoding/base64"
	"net/url"
)

type BCS struct {
	//end without '/'
	host string
	accessKey string
	accessSecret string
}


func (bcs *BCS) sign(method string, bucket string, object string, time string, ip string, size string) string {

	var flag bytes.Buffer
	var ct bytes.Buffer

	flag.WriteString("MBO")
	ct.WriteString("Method="); ct.WriteString(method); ct.WriteString("\n")
	ct.WriteString("Bucket="); ct.WriteString(bucket); ct.WriteString("\n")
	ct.WriteString("Object="); ct.WriteString(object); ct.WriteString("\n")

	if time != "" {
		flag.WriteString("T")
		ct.WriteString("Time="); ct.WriteString(time); ct.WriteString("\n")
	}

	if ip != "" {
		flag.WriteString("I")
		ct.WriteString("Ip="); ct.WriteString(ip); ct.WriteString("\n")
	}

	if size != "" {
		flag.WriteString("S")
		ct.WriteString("Size="); ct.WriteString(size); ct.WriteString("\n")
	}

	cts := ct.String()
	ct.Reset()
	ct.WriteString(flag.String()); ct.WriteString("\n"); ct.WriteString(cts)


	h := func(key []byte, data []byte) string {
		hash := hmac.New(sha1.New, key)
		hash.Write(data)
		r := hash.Sum(nil)
		fmt.Println(len(r))

		return url.QueryEscape(base64.URLEncoding.EncodeToString(r))
	}
	fmt.Println(ct.String())
	s := h([]byte(bcs.accessSecret), ct.Bytes())

	var u bytes.Buffer

	u.WriteString(bcs.host)
	u.WriteString("/")
	u.WriteString(bucket)
	u.WriteString("/")
	u.WriteString(url.QueryEscape(object[1:]))
	u.WriteString("?sign=")
	u.WriteString(flag.String())
	u.WriteString(":")
	u.WriteString(bcs.accessKey)
	u.WriteString(":")
	u.WriteString(s)
	if time != "" {
		u.WriteString("&time="); u.WriteString(time)
	}

	if ip != "" {
		u.WriteString("&ip="); u.WriteString(ip)
	}

	if size != "" {
		u.WriteString("&size="); u.WriteString(size)
	}

	return u.String()
}
