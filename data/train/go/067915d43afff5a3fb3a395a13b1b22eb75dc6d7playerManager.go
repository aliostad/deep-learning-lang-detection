package game

import (
    "sync"
)

type playerManager struct {
	players map[string]*Player
    rwLocker sync.RWMutex
}

var manager *playerManager

func GetPlayerManagerInstance() *playerManager {
    if manager == nil {
        manager = new(playerManager)
        manager.players = make(map[string]*Player);
    }
    return manager
}

func (manager *playerManager) GetPlayerCount() int {
    manager.rwLocker.RLock()
    defer manager.rwLocker.RUnlock()
    return len(manager.players)
}

func (manager *playerManager) AddPlayer(player *Player) {
    manager.rwLocker.Lock()
    defer manager.rwLocker.Unlock()
    manager.players[player.GetName()] = player
}

func (manager *playerManager) RemovePlayer(name string) {
    manager.rwLocker.Lock()
    defer manager.rwLocker.Unlock()
    delete (manager.players, name)
}

func (manager *playerManager) GetPlayer(name string) *Player {
    manager.rwLocker.RLock()
    defer manager.rwLocker.RUnlock()
    return manager.players[name]
}

func (manager *playerManager) GetAllPlayer() []*Player {
    manager.rwLocker.RLock()
    defer manager.rwLocker.RUnlock()
    var players []*Player
    for _, player := range manager.players {
        players = append(players, player)
    }
    return players
}

func (manager *playerManager) RemoveAllPlayer() {
    manager.rwLocker.Lock()
    defer manager.rwLocker.Unlock()
    for k := range manager.players {
        delete(manager.players, k)
    }
}