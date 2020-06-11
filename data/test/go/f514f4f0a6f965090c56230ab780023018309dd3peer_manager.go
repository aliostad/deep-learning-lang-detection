package peer_manager

import (
	"github.com/bbpcr/Yomato/peer"

	"sync"
)

type PeerManager struct {
	connectedPeers    map[string]*peer.Peer
	disconnectedPeers map[string]*peer.Peer
	alivePeers        map[string]*peer.Peer
	cdLocker          sync.Mutex
	aLocker           sync.Mutex
}

func (manager *PeerManager) SetPeerAsConnected(p *peer.Peer) {
	manager.cdLocker.Lock()
	defer manager.cdLocker.Unlock()
	delete(manager.disconnectedPeers, p.IP)
	manager.connectedPeers[p.IP] = p
}

func (manager *PeerManager) SetPeerAsAlive(p *peer.Peer) {
	manager.aLocker.Lock()
	defer manager.aLocker.Unlock()
	manager.alivePeers[p.IP] = p
}

func (manager *PeerManager) SetPeerAsDisconnected(p *peer.Peer) {
	manager.cdLocker.Lock()
	defer manager.cdLocker.Unlock()
	delete(manager.connectedPeers, p.IP)
	manager.disconnectedPeers[p.IP] = p
}

func (manager *PeerManager) Exists(p *peer.Peer) bool {

	manager.cdLocker.Lock()
	defer manager.cdLocker.Unlock()
	_, isConnected := manager.connectedPeers[p.IP]
	_, isDisconnected := manager.disconnectedPeers[p.IP]
	return isConnected || isDisconnected
}

func (manager *PeerManager) CountDownloadingPeers() int {

	manager.cdLocker.Lock()
	defer manager.cdLocker.Unlock()
	downloadingNum := 0
	for _, connectedPeer := range manager.connectedPeers {
		if connectedPeer.Downloading {
			downloadingNum++
		}
	}
	return downloadingNum
}

func (manager *PeerManager) CountConnectedPeers() int {
	manager.cdLocker.Lock()
	defer manager.cdLocker.Unlock()
	return len(manager.connectedPeers)
}

func (manager *PeerManager) CountAlivePeers() int {
	manager.cdLocker.Lock()
	defer manager.cdLocker.Unlock()
	return len(manager.alivePeers)
}

func (manager *PeerManager) CountDisconnectedPeers() int {
	manager.cdLocker.Lock()
	defer manager.cdLocker.Unlock()
	return len(manager.disconnectedPeers)
}

func (manager *PeerManager) CountAllPeers() int {
	manager.cdLocker.Lock()
	defer manager.cdLocker.Unlock()
	return len(manager.connectedPeers) + len(manager.disconnectedPeers)
}

func (manager *PeerManager) GetDisconnectedPeers() []*peer.Peer {

	manager.cdLocker.Lock()
	defer manager.cdLocker.Unlock()
	disconnectedPeersList := make([]*peer.Peer, len(manager.disconnectedPeers))
	index := 0
	for _, disconnectedPeer := range manager.disconnectedPeers {
		disconnectedPeersList[index] = disconnectedPeer
		index++
	}
	return disconnectedPeersList
}

func (manager *PeerManager) GetAlivePeers() []*peer.Peer {

	manager.aLocker.Lock()
	defer manager.aLocker.Unlock()
	alivePeersList := make([]*peer.Peer, len(manager.alivePeers))
	index := 0
	for _, alivePeer := range manager.alivePeers {
		alivePeersList[index] = alivePeer
		index++
	}
	return alivePeersList
}

func (manager *PeerManager) GetConnectedPeers() []*peer.Peer {

	manager.cdLocker.Lock()
	defer manager.cdLocker.Unlock()
	connectedPeersList := make([]*peer.Peer, len(manager.connectedPeers))
	index := 0
	for _, connectedPeer := range manager.connectedPeers {
		connectedPeersList[index] = connectedPeer
		index++
	}
	return connectedPeersList
}

func New() *PeerManager {
	manager := &PeerManager{
		connectedPeers:    make(map[string]*peer.Peer),
		disconnectedPeers: make(map[string]*peer.Peer),
		alivePeers:        make(map[string]*peer.Peer),
	}
	return manager
}
