package game

import (
    "sync"
)

type gameManager struct {
    rwLocker  sync.RWMutex
    games map[int]*game
}

var managerInstance *gameManager

func GetGameManagerInstance() *gameManager {
    if managerInstance == nil {
        managerInstance = new(gameManager)
        managerInstance.games = make(map[int]*game)
    }
    
    return managerInstance
}

func (manager *gameManager) AddGame(game *game) {
    manager.rwLocker.Lock()
    defer manager.rwLocker.Unlock()
    manager.games[game.GetId()] = game
}

func (manager *gameManager) GetGame(id int) *game {
    manager.rwLocker.RLock()
    defer manager.rwLocker.RUnlock()
    return manager.games[id]
}

func (manager *gameManager) GetGameCount() int {
    manager.rwLocker.RLock()
    defer manager.rwLocker.RUnlock()
    return len(manager.games)
}