package network

import "encoding/json"

type NodeMeta struct {
	Addr string
	Left bool
}

type NetMeta map[string]NodeMeta

func newNetMeta() NetMeta {
	return make(map[string]NodeMeta)
}

func newQuitNetMeta(id, addr string) NetMeta {
	netMeta := newNetMeta()
	netMeta[id] = NodeMeta{addr, true}
	return netMeta
}

func newJoinNetMeta(id, addr string) NetMeta {
	netMeta := newNetMeta()
	netMeta[id] = NodeMeta{addr, false}
	return netMeta
}

func newNetMetaFromJson(netMetaJson []byte) (NetMeta, error) {
	var netMeta NetMeta
	err := json.Unmarshal(netMetaJson, &netMeta)
	return netMeta, err
}

// return true if the update results in a change and false otherwise
func (netMeta NetMeta) update(id string, newNodeMeta NodeMeta) bool {
	if n, ok := netMeta[id]; !ok || (!n.Left && newNodeMeta.Left) {
		netMeta[id] = newNodeMeta
		return true
	}
	return false
}

// return the changes resulting from merge and whether changes occurred
func (netMeta NetMeta) merge(netMeta2 NetMeta) (NetMeta, bool) {
	delta := newNetMeta()
	for id, node := range netMeta2 {
		changed := netMeta.update(id, node)
		if changed {
			delta[id] = node
		}
	}
	if len(delta) == 0 {
		return nil, false
	}
	return delta, len(delta) != 0
}

func (netMeta NetMeta) toJson() []byte {
	netMetaJson, _ := json.Marshal(netMeta)
	return netMetaJson
}

func (netMeta NetMeta) toJsonPrettyPrint() []byte {
	metaJson, _ := json.MarshalIndent(netMeta, "", "    ")
	return metaJson
}

func (netMeta NetMeta) copy() NetMeta {
	newNetMeta := newNetMeta()
	for id, node := range netMeta {
		newNetMeta[id] = node
	}
	return newNetMeta
}

type NetMetaList []NodeMetaListElem

type NodeMetaListElem struct {
	Id   string
	Addr string
	Left bool
}

func (slice NetMetaList) Len() int {
	return len(slice)
}

func (slice NetMetaList) Less(i, j int) bool {
	return slice[i].Id < slice[j].Id
}

func (slice NetMetaList) Swap(i, j int) {
	slice[i], slice[j] = slice[j], slice[i]
}

func (netMeta NetMeta) ToList() NetMetaList {
	list := make(NetMetaList, 0, len(netMeta))
	for id, node := range netMeta {
		list = append(list, NodeMetaListElem{
			Id:   id,
			Addr: node.Addr,
			Left: node.Left,
		})
	}
	return list
}
