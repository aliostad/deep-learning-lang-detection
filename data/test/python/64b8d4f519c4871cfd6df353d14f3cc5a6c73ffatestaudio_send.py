# This file (c) Copyright 1998 - 2002 The MITRE Corporation
# 
# This file is part of the Galaxy Communicator system. It is licensed
# under the conditions described in the file LICENSE in the root 
# directory of the Galaxy Communicator system.

import os, sys, string

sys.path.insert(0, os.path.join(os.environ["GC_HOME"],
				"contrib", "MITRE", "templates"))

import GC_py_init

import Galaxy, GalaxyIO

# The Python out broker can't fake streaming, because
# there's no timer loop. 

# The broker method is one of the strings "original_env",
# "original_comm", "proxy_obj", "proxy_stream", "proxy_original".

def Welcome(env, dict):
    try:
	file = dict[":audiofile"]
    except KeyError:
	sys.stderr.write("No filename provided\n")
	return dict
    try:
	broker_method = dict[":broker_method"]
    except KeyError:
	broker_method = None
    fp = open(file, "r")
    a = Galaxy.BinaryObject(Galaxy.GAL_BINARY)
    # Get length. Position 0 relative to file end (2).
    fp.seek(0, 2)
    l = fp.tell()
    # Back to the beginning
    fp.seek(0, 0)
    a.fromfile(fp, l)
    fp.close()
    f = Galaxy.Frame("main", Galaxy.GAL_CLAUSE)
    if broker_method in [None, "original_env", "original_comm"]:
	b = GalaxyIO.BrokerDataOut(env.conn, 10)
	b.PopulateFrame(f, ":binary_host", ":binary_port")
	b.Write(a)
	b.DataDone()
    elif broker_method in ["proxy_obj", "proxy_stream", "proxy_original"]:
	p = GalaxyIO.BrokerProxyOut(env, 10, type = Galaxy.GAL_BINARY)
	p.Write(a)
	p.DataDone()
	f[":binary_proxy"] = p
    env.WriteFrame(f)
    return None

def Notify(env, dict):
    print "Audio send: %s" % dict[":notification"]

def main():
    s = GalaxyIO.Server(sys.argv, "testaudio_send", default_port = 12345)
    s.AddDispatchFunction("reinitialize", Welcome)
    s.AddDispatchFunction("notify", Notify)
    s.RunServer()

main()
