package slice

import (
	"fmt"
	"strings"

	"ncache/backend"
	"ncache/backend/command"
	"ncache/backend/hashkit"
	"ncache/backend/nodes"
	"ncache/config"
	"ncache/protocol"
)

type sliceMode int

const (
	// Implemented as twemproxy
	KeyDispatch sliceMode = 1 << iota
	// Connect to proxy, differential procedure handled by proxy
	Polling
)

type HashFunc func([]byte) uint32
type DispatchFunc func([]hashkit.Continuum, uint32) uint32
type BuildFunc func(backend.Backend) ([]hashkit.Continuum, error)
type Slice struct {
	conf       config.SliceConf
	name       string
	nodes      []*nodes.Node
	mode       sliceMode
	hash       HashFunc
	weight     []int
	aliasName  []string
	dispatch   DispatchFunc
	build      BuildFunc
	continuums []hashkit.Continuum
}

func NewSlice(conf config.SliceConf) (slice *Slice, err error) {
	slice = &Slice{conf: conf}
	nodesConf, err := config.GetNodesConf(conf)
	if err != nil {
		return nil, err
	}

	slice.weight = conf.Weights
	slice.aliasName = conf.NodeNames
	switch conf.Hash {
	case "crc32a":
		slice.hash = hashkit.HashCrc32a
	default:
		return nil, fmt.Errorf("Not support hash method %s", conf.Hash)
	}

	switch conf.Distribution {
	case "ketama":
		slice.dispatch = hashkit.KetamaDispatch
		slice.build = hashkit.KetamaUpdate
	case "random":
		slice.dispatch = hashkit.RandomDispatch
		slice.build = hashkit.RandomUpdate
	default:
		return nil, fmt.Errorf("Not supprot dispatch method %s", conf.Distribution)
	}

	if conf.Distribution == "random" {
		slice.mode = Polling
	} else {
		slice.mode = KeyDispatch
	}

	nodeList := make([]*nodes.Node, len(nodesConf))
	for i, nodeConf := range nodesConf {
		temp := nodeConf
		node, err := nodes.NewNode(&temp)
		if err != nil {
			return nil, err
		}
		nodeList[i] = node
	}
	slice.nodes = nodeList
	slice.continuums, err = slice.build(slice)
	if err != nil {
		return nil, err
	}
	return slice, nil
}

func (c *Slice) Proc(msg *protocol.Msg) (ackMsg *protocol.Msg, err error) {
	// In mod Polling, connect to proxy, differential procedure handled by proxy
	// All commands will be considered as single key command
	if c.mode == Polling {
		return command.KeyProc(c, msg)
	}
	methodByte, _ := msg.GetArray()[0].GetValueBytes()
	method := strings.ToUpper(string(methodByte))
	switch method {
	case "MSET":
		ackMsg, err = command.MsetProc(c, msg)
	case "MGET":
		ackMsg, err = command.MgetProc(c, msg)
	case "DEL":
		ackMsg, err = command.DelProc(c, msg)
	case "EXISTS":
		ackMsg, err = command.ExistsProc(c, msg)
	default:
		ackMsg, err = command.KeyProc(c, msg)
	}
	return ackMsg, err
}
func (s *Slice) GetNodeIndexByKey(key []byte) uint32 {
	hash := s.hash(key)
	return s.dispatch(s.continuums, hash)
}

func (s *Slice) GetNodeByIndex(index uint32) *nodes.Node {
	return s.nodes[int(index)]
}

func (s *Slice) GetNodes() []*nodes.Node {
	return s.nodes
}

func (s *Slice) GetConf() interface{} {
	return s.conf
}
