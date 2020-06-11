package pods

import (
	"encoding/json"
	"errors"
	"io/ioutil"
	"path"
)

type NetInfo struct {
	NetName    string
	IfName     string
	Ip         string
	PluginPath string
}

var (
	ErrPodNoNet = errors.New("rkt-inspect: Net not found")
)

func GetPodNetInfo(root string, uuid string, netName string) (NetInfo, error) {
	var netInfo NetInfo
	netInfoPath := path.Join(getPodDir(root, uuid, ""), "net-info.json")
	netInfoRaw, err := ioutil.ReadFile(netInfoPath)
	if err != nil {
		return netInfo, err
	}

	var netInfos []NetInfo
	err = json.Unmarshal(netInfoRaw, &netInfos)
	if err != nil {
		panic(err)
	}

	for _, netInfo = range netInfos {
		if netInfo.NetName == netName {
			return netInfo, nil
		}
	}

	return netInfo, ErrPodNoNet
}
