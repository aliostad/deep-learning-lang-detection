package net

import "net"

var DialTCP = net.DialTCP
var DialUDP = net.DialUDP
var DialUnix = net.DialUnix

var Listen = net.Listen
var ListenTCP = net.ListenTCP
var ListenUDP = net.ListenUDP

var FileConn = net.FileConn

var LookupIP = net.LookupIP
var ParseIP = net.ParseIP

var SplitHostPort = net.SplitHostPort

var CIDRMask = net.CIDRMask

type Addr = net.Addr
type Conn = net.Conn

type TCPAddr = net.TCPAddr
type TCPConn = net.TCPConn

type UDPAddr = net.UDPAddr
type UDPConn = net.UDPConn

type UnixAddr = net.UnixAddr
type UnixConn = net.UnixConn

type IP = net.IP
type IPMask = net.IPMask
type IPNet = net.IPNet

const IPv4len = net.IPv4len
const IPv6len = net.IPv6len

type Error = net.Error
type AddrError = net.AddrError

type Dialer = net.Dialer
type Listener = net.Listener
type TCPListener = net.TCPListener
type UnixListener = net.UnixListener
