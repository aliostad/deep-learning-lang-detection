package config

import (
	"encoding/json"
	"os"
	"runtime"
)

type etcdAuth struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

type etcdTLS struct {
	CACert string `json:"caCert"`
}

// ConfigurationInfo contains the config file's content
type ConfigurationInfo struct {
	MachineName string            `json:"machineName"`
	Arch        string            `json:"arch"`
	Tags        map[string]string `json:"tags"`
	BindPath    string            `json:"bindPath"`
	EtcdAddress string            `json:"etcdAddress"`
	PublicIP    string            `json:"publicIP"`
	Zone        string            `json:"zone"`
	EtcdAuth    etcdAuth          `json:"etcdAuth"`
	EtcdTLS     etcdTLS           `json:"etcdTLS"`
}

func newConfigurationInfo() ConfigurationInfo {
	config := ConfigurationInfo{}
	config.MachineName, _ = os.Hostname()
	config.BindPath = "/var/run/dispatch.socket"
	config.EtcdAddress = "http://127.0.0.1:2379"
	config.Zone = "dc"
	config.Arch = runtime.GOARCH
	return config
}

// GetConfiguration reads the configuration from config.json and returns it
func GetConfiguration() ConfigurationInfo {
	returnConfig := newConfigurationInfo()
	data, err := os.Open("config.json")
	if err == nil { // Only read when available
		jsonParser := json.NewDecoder(data)
		jsonParser.Decode(&returnConfig)
	}
	readEnv(&returnConfig)
	return returnConfig
}

func readEnv(conf *ConfigurationInfo) {
	if name := os.Getenv("DISPATCH_MACHINENAME"); name != "" {
		conf.MachineName = name
	}
	if bindpath := os.Getenv("DISPATCH_BINDPATH"); bindpath != "" {
		conf.BindPath = bindpath
	}
	if etcdaddress := os.Getenv("DISPATCH_ETCDADDRESS"); etcdaddress != "" {
		conf.EtcdAddress = etcdaddress
	}
	if publicip := os.Getenv("DISPATCH_PUBLICIP"); publicip != "" {
		conf.PublicIP = publicip
	}
	if zone := os.Getenv("DISPATCH_ZONE"); zone != "" {
		conf.Zone = zone
	}
	if username := os.Getenv("DISPATCH_ETCD_USERNAME"); username != "" {
		conf.EtcdAuth.Username = username
	}
	if password := os.Getenv("DISPATCH_ETCD_PASSWORD"); password != "" {
		conf.EtcdAuth.Password = password
	}
	if ca := os.Getenv("DISPATCH_ETCD_CA"); ca != "" {
		conf.EtcdTLS.CACert = ca
	}
}
