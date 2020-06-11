/*
 Copyright (c) 2015, Northeastern University
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
     * Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
     * Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.
     * Neither the name of the Northeastern University nor the
       names of its contributors may be used to endorse or promote products
       derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL Northeastern University BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

// Package scamper is a library to work with scamper control sockets
package scamper

import (
	"bytes"
	"fmt"
	"io"
	"strconv"
	"sync"

	dm "github.com/NEU-SNS/ReverseTraceroute/datamodel"
	"github.com/NEU-SNS/ReverseTraceroute/util"
)

// Cmd is a command that can run on scamper
type Cmd struct {
	ID          uint32
	Arg         interface{}
	userIDCache *string
}

var cmdFree = sync.Pool{
	New: func() interface{} { return new(bytes.Buffer) },
}

func (c Cmd) issuePing(w io.Writer, p *dm.PingMeasurement) error {
	ips, err := util.Int32ToIPString(p.Dst)
	if err != nil {
		return err
	}
	buf := cmdFree.Get().(*bytes.Buffer)
	defer cmdFree.Put(buf)
	buf.Reset()
	buf.WriteString("ping ")
	if p.RR {
		buf.WriteString("-R ")
	}
	if p.Spoof {
		buf.WriteString("-O spoof ")
		buf.WriteString("-S ")
		buf.WriteString(p.SAddr)
		buf.WriteByte(' ')
		buf.WriteString("-F 61681 ")
		buf.WriteString("-d 62195 ")
	}
	if p.Payload != "" {
		buf.WriteString("-B ")
		buf.WriteString(p.Payload)
		buf.WriteByte(' ')
	}
	if p.Count != "" {
		buf.WriteString("-c ")
		buf.WriteString(p.Count)
		buf.WriteByte(' ')
	}
	if p.IcmpSum != "" {
		buf.WriteString("-C ")
		buf.WriteString(p.IcmpSum)
		buf.WriteByte(' ')
	}
	if p.Wait != "" {
		buf.WriteString("-i ")
		buf.WriteString(p.Wait)
		buf.WriteByte(' ')
	}
	if p.Ttl != "" {
		buf.WriteString("-m ")
		buf.WriteString(p.Ttl)
		buf.WriteByte(' ')
	}
	if p.Mtu != "" {
		buf.WriteString("-M ")
		buf.WriteString(p.Mtu)
		buf.WriteByte(' ')
	}
	if p.ReplyCount != "" {
		buf.WriteString("-o ")
		buf.WriteString(p.ReplyCount)
		buf.WriteByte(' ')
	}
	if p.Pattern != "" {
		buf.WriteString("-p ")
		buf.WriteString(p.Pattern)
		buf.WriteByte(' ')
	}
	if p.Method != "" {
		buf.WriteString("-P ")
		buf.WriteString(p.Method)
		buf.WriteByte(' ')
	}
	if p.Size != "" {
		buf.WriteString("-s ")
		buf.WriteString(p.Size)
		buf.WriteByte(' ')
	}
	if p.Tos != "" {
		buf.WriteString("-z ")
		buf.WriteString(p.Tos)
		buf.WriteByte(' ')
	}
	if p.TimeStamp != "" {
		buf.WriteString("-T ")
		buf.WriteString(p.TimeStamp)
		buf.WriteByte(' ')
	}
	c.userIDCache = new(string)
	*c.userIDCache = p.UserId
	buf.WriteString("-U ")
	uid := strconv.FormatUint(uint64(c.ID), 10)
	buf.WriteString(uid)
	buf.WriteByte(' ')
	buf.WriteString(ips)
	buf.WriteByte('\n')
	_, err = w.Write(buf.Bytes())
	return err
}

func (c Cmd) issueTraceroute(w io.Writer, t *dm.TracerouteMeasurement) error {
	ips, err := util.Int32ToIPString(t.Dst)
	if err != nil {
		return err
	}
	buf := cmdFree.Get().(*bytes.Buffer)
	defer cmdFree.Put(buf)
	buf.Reset()
	buf.WriteString("trace ")

	if t.Confidence != "" {
		buf.WriteString("-c ")
		buf.WriteString(t.Confidence)
		buf.WriteByte(' ')
	}
	if t.Dport != "" {
		buf.WriteString("-d ")
		buf.WriteString(t.Dport)
		buf.WriteByte(' ')
	}
	if t.FirstHop != "" {
		buf.WriteString("-f ")
		buf.WriteString(t.FirstHop)
		buf.WriteByte(' ')
	}
	if t.GapLimit != "" {
		buf.WriteString("-g ")
		buf.WriteString(t.GapLimit)
		buf.WriteByte(' ')
	}
	if t.GapAction != "" {
		buf.WriteString("-G ")
		buf.WriteString(t.GapAction)
		buf.WriteByte(' ')
	}
	if t.MaxTtl != "" {
		buf.WriteString("-m ")
		buf.WriteString(t.MaxTtl)
		buf.WriteByte(' ')
	}
	if t.PathDiscov {
		buf.WriteString("-M ")
	}
	if t.Loops != "" {
		buf.WriteString("-l ")
		buf.WriteString(t.Loops)
		buf.WriteByte(' ')
	}
	if t.LoopAction != "" {
		buf.WriteString("-L ")
		buf.WriteString(t.LoopAction)
		buf.WriteByte(' ')
	}
	if t.Payload != "" {
		buf.WriteString("-p ")
		buf.WriteString(t.Payload)
		buf.WriteByte(' ')
	}
	buf.WriteString("-P ")
	if t.Method != "" {
		buf.WriteString(t.Method)
	} else {
		buf.WriteString("ICMP-paris")
	}
	buf.WriteByte(' ')
	if t.Attempts != "" {
		buf.WriteString("-q ")
		buf.WriteString(t.Attempts)
		buf.WriteByte(' ')
	}
	if t.SendAll {
		buf.WriteString("-Q ")
	}
	if t.Sport != "" {
		buf.WriteString("-s ")
		buf.WriteString(t.Sport)
		buf.WriteByte(' ')
	}
	if t.Tos != "" {
		buf.WriteString("-t ")
		buf.WriteString(t.Tos)
		buf.WriteByte(' ')
	}
	if t.TimeExceeded {
		buf.WriteString("-T ")
	}
	if t.Wait != "" {
		buf.WriteString("-w ")
		buf.WriteString(t.Wait)
		buf.WriteByte(' ')
	}
	if t.WaitProbe != "" {
		buf.WriteString("-W ")
		buf.WriteString(t.WaitProbe)
		buf.WriteByte(' ')
	}
	if t.GssEntry != "" {
		buf.WriteString("-z ")
		buf.WriteString(t.GssEntry)
		buf.WriteByte(' ')
	}
	if t.LssName != "" {
		buf.WriteString("-Z ")
		buf.WriteString(t.LssName)
		buf.WriteByte(' ')
	}
	c.userIDCache = new(string)
	*c.userIDCache = t.UserId
	buf.WriteString("-U ")
	uid := strconv.FormatUint(uint64(c.ID), 10)
	buf.WriteString(uid)
	buf.WriteByte(' ')
	buf.WriteString(ips)
	buf.WriteByte('\n')
	_, err = w.Write(buf.Bytes())
	return err
}

// IssueCommand write the command to w
func (c *Cmd) IssueCommand(w io.Writer) error {
	switch c.Arg.(type) {
	case *dm.PingMeasurement:
		return c.issuePing(w, c.Arg.(*dm.PingMeasurement))
	case *dm.TracerouteMeasurement:
		return c.issueTraceroute(w, c.Arg.(*dm.TracerouteMeasurement))
	default:
		return fmt.Errorf("Unknown arg type.")
	}
}
