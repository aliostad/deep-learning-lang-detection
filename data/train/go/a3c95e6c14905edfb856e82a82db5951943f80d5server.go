package divsd

import (
	"fmt"
	"sync"
	"github.com/inercia/divs/divsd/nat"
)

// The DiVS server starts the nodes manager (for the p2p network) and the devices
// manager (for the TAP device)
type Server struct {
	config *Config

	nodesManager *NodesManager
	devManager   *DevManager

	mutex sync.RWMutex
}

// Creates a new server.
func New(config *Config) (s *Server, err error) {
	// Initialize the device manager
	devManager, err := NewDevManager(config)
	if err != nil {
		return nil, err
	}

	// Initialize the nodes manager
	nodesManager, err := NewNodesManager(config)
	if err != nil {
		return nil, err
	}

	nodesManager.SetDevManager(devManager)
	devManager.SetNodesManager(nodesManager)

	s = &Server{
		config:       config,
		devManager:   devManager,
		nodesManager: nodesManager,
	}

	return s, nil
}

// Starts the server.
func (s *Server) ListenAndServe() error {
	// obtain a externally-reachable IP/port for memberlist management
	defaultExternalAddr := fmt.Sprintf("%s:%d", s.config.Global.Host, s.config.Global.Port)
	membersExternalAddr, err := nat.NewExternalUDPAddr(defaultExternalAddr)
	if membersExternalAddr.Port == 0 {
		log.Fatalf("FATAL: external port obtained is 0")
	}

	// start the peers manager
	if err = s.nodesManager.Start(membersExternalAddr); err != nil {
		log.Fatalf("Error when initialing peers manager: %s", err)
	}

	// and the devices manager
	if err = s.devManager.Start(); err != nil {
		log.Fatalf("Error when initialing tun/tap device manager: %s", err)
	}

	if err := s.nodesManager.WaitForNodesForever(); err != nil {
		return err
	}
	return nil
}
