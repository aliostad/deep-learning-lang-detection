package net

import (
	"net"

	qlang "qlang.io/spec"
)

// Exports is the export table of this module.
//
var Exports = map[string]interface{}{
	"_name": "net",

	"FlagBroadcast":    net.FlagBroadcast,
	"FlagLoopback":     net.FlagLoopback,
	"FlagMulticast":    net.FlagMulticast,
	"FlagPointToPoint": net.FlagPointToPoint,
	"FlagUp":           net.FlagUp,
	"IPv4len":          net.IPv4len,
	"IPv6len":          net.IPv6len,

	"ErrWriteToConnected":        net.ErrWriteToConnected,
	"IPv4allrouter":              net.IPv4allrouter,
	"IPv4allsys":                 net.IPv4allsys,
	"IPv4bcast":                  net.IPv4bcast,
	"IPv4zero":                   net.IPv4zero,
	"IPv6interfacelocalallnodes": net.IPv6interfacelocalallnodes,
	"IPv6linklocalallnodes":      net.IPv6linklocalallnodes,
	"IPv6linklocalallrouters":    net.IPv6linklocalallrouters,
	"IPv6loopback":               net.IPv6loopback,
	"IPv6unspecified":            net.IPv6unspecified,
	"IPv6zero":                   net.IPv6zero,

	"interfaceAddrs": net.InterfaceAddrs,
	"interfaces":     net.Interfaces,
	"joinHostPort":   net.JoinHostPort,
	"lookupAddr":     net.LookupAddr,
	"lookupCNAME":    net.LookupCNAME,
	"lookupHost":     net.LookupHost,
	"lookupIP":       net.LookupIP,
	"lookupMX":       net.LookupMX,
	"lookupNS":       net.LookupNS,
	"lookupPort":     net.LookupPort,
	"lookupSRV":      net.LookupSRV,
	"lookupTXT":      net.LookupTXT,
	"splitHostPort":  net.SplitHostPort,

	"dial":           net.Dial,
	"dialTimeout":    net.DialTimeout,
	"fileConn":       net.FileConn,
	"pipe":           net.Pipe,
	"fileListener":   net.FileListener,
	"listen":         net.Listen,
	"filePacketConn": net.FilePacketConn,
	"listenPacket":   net.ListenPacket,

	"Dialer":             qlang.StructOf((*net.Dialer)(nil)),
	"IPAddr":             qlang.StructOf((*net.IPAddr)(nil)),
	"resolveIPAddr":      net.ResolveIPAddr,
	"IPConn":             qlang.StructOf((*net.IPConn)(nil)),
	"dialIP":             net.DialIP,
	"listenIP":           net.ListenIP,
	"IPNet":              qlang.StructOf((*net.IPNet)(nil)),
	"Interface":          qlang.StructOf((*net.Interface)(nil)),
	"interfaceByIndex":   net.InterfaceByIndex,
	"interfaceByName":    net.InterfaceByName,
	"MX":                 qlang.StructOf((*net.MX)(nil)),
	"NS":                 qlang.StructOf((*net.NS)(nil)),
	"SRV":                qlang.StructOf((*net.SRV)(nil)),
	"TCPAddr":            qlang.StructOf((*net.TCPAddr)(nil)),
	"resolveTCPAddr":     net.ResolveTCPAddr,
	"TCPConn":            qlang.StructOf((*net.TCPConn)(nil)),
	"dialTCP":            net.DialTCP,
	"TCPListener":        qlang.StructOf((*net.TCPListener)(nil)),
	"listenTCP":          net.ListenTCP,
	"UDPAddr":            qlang.StructOf((*net.UDPAddr)(nil)),
	"resolveUDPAddr":     net.ResolveUDPAddr,
	"UDPConn":            qlang.StructOf((*net.UDPConn)(nil)),
	"dialUDP":            net.DialUDP,
	"listenMulticastUDP": net.ListenMulticastUDP,
	"listenUDP":          net.ListenUDP,
	"UnixAddr":           qlang.StructOf((*net.UnixAddr)(nil)),
	"resolveUnixAddr":    net.ResolveUnixAddr,
	"UnixConn":           qlang.StructOf((*net.UnixConn)(nil)),
	"dialUnix":           net.DialUnix,
	"listenUnixgram":     net.ListenUnixgram,
	"UnixListener":       qlang.StructOf((*net.UnixListener)(nil)),
	"listenUnix":         net.ListenUnix,
}
