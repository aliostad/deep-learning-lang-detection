package core

import (
  "os"
)

// World represent a minecraft world.
type World struct {
  Path           string
  mRegionManager *RegionManager
  mPlayerManager *PlayerManager
}

// NewWorld instantiate a world object.
// It returns a pointer to a world.
func NewWorld(pPath string) *World {
  world := new(World)
  world.Path = pPath
  world.mRegionManager = NewRegionManager(world.Path)
  world.mPlayerManager = NewPlayerManager(world.Path)
  return world
}

// PathValid ...
func (w *World) PathValid() bool {
  _, err := os.Stat(w.Path)
  return err == nil
}

// RegionManager get the region manager.
// It returns a pointer to the region manager.
func (w *World) RegionManager() *RegionManager {
  return w.mRegionManager
}

// PlayerManager ...
func (w *World) PlayerManager() *PlayerManager {
  return w.mPlayerManager
}
