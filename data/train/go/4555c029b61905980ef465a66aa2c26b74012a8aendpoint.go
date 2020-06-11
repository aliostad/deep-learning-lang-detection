package ovoclient

import (
	"bytes"
)

func createTopologyEndpoint(host string, port string) string {
	var buffer bytes.Buffer
	buffer.WriteString("http://")
	buffer.WriteString(host)
	buffer.WriteString(":")
	buffer.WriteString(port)
	buffer.WriteString("/ovo/cluster")
	return buffer.String()
}

func createTopologyNodeEndpoint(host string, port string) string {
	var buffer bytes.Buffer
	buffer.WriteString("http://")
	buffer.WriteString(host)
	buffer.WriteString(":")
	buffer.WriteString(port)
	buffer.WriteString("/ovo/cluster/me")
	return buffer.String()
}

func createKeysEndpoint(host string, port string) string {
	var buffer bytes.Buffer
	buffer.WriteString("http://")
	buffer.WriteString(host)
	buffer.WriteString(":")
	buffer.WriteString(port)
	buffer.WriteString("/ovo/keys")
	return buffer.String()
}

func createKeyStorageEndpoint(host string, port string) string {
	var buffer bytes.Buffer
	buffer.WriteString("http://")
	buffer.WriteString(host)
	buffer.WriteString(":")
	buffer.WriteString(port)
	buffer.WriteString("/ovo/keystorage")
	return buffer.String()
}

func createGetKeyStorageEndpoint(host string, port string, key string) string {
	var buffer bytes.Buffer
	buffer.WriteString("http://")
	buffer.WriteString(host)
	buffer.WriteString(":")
	buffer.WriteString(port)
	buffer.WriteString("/ovo/keystorage/")
	buffer.WriteString(key)
	return buffer.String()
}

func createGetAndRemoveEndpoint(host string, port string, key string) string {
	var buffer bytes.Buffer
	buffer.WriteString("http://")
	buffer.WriteString(host)
	buffer.WriteString(":")
	buffer.WriteString(port)
	buffer.WriteString("/ovo/keystorage/")
	buffer.WriteString(key)
	buffer.WriteString("/getandremove")
	return buffer.String()
}

func createUpdateValueIfEqualEndpoint(host string, port string, key string) string {
	var buffer bytes.Buffer
	buffer.WriteString("http://")
	buffer.WriteString(host)
	buffer.WriteString(":")
	buffer.WriteString(port)
	buffer.WriteString("/ovo/keystorage/")
	buffer.WriteString(key)
	buffer.WriteString("/updatevalueifequal")
	return buffer.String()
}

func createCountersEndpoint(host string, port string) string {
	var buffer bytes.Buffer
	buffer.WriteString("http://")
	buffer.WriteString(host)
	buffer.WriteString(":")
	buffer.WriteString(port)
	buffer.WriteString("/ovo/counters")
	return buffer.String()
}

func createCounterEndpoint(host string, port string, key string) string {
	var buffer bytes.Buffer
	buffer.WriteString("http://")
	buffer.WriteString(host)
	buffer.WriteString(":")
	buffer.WriteString(port)
	buffer.WriteString("/ovo/counters/")
	buffer.WriteString(key)
	return buffer.String()
}

func createDeleteValueIfEqualEndpoint(host string, port string, key string) string {
	var buffer bytes.Buffer
	buffer.WriteString("http://")
	buffer.WriteString(host)
	buffer.WriteString(":")
	buffer.WriteString(port)
	buffer.WriteString("/ovo/keystorage/")
	buffer.WriteString(key)
	buffer.WriteString("/deletevalueifequal")
	return buffer.String()
}
