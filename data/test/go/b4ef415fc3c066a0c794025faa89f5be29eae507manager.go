package lib

import "errors"

type MusicManager struct {
	musics []Music
}

func NewMusicManager() *MusicManager {
	return &MusicManager{make([]Music, 0)}
}

func (manager *MusicManager) Len() int {
	return len(manager.musics)
}

func (manager *MusicManager) Get(index int) (music *Music, err error) {
	if index < 0 || index >= len(manager.musics) {
		return nil, errors.New("Index out of range!")
	}
	return &manager.musics[index], nil
}

func (manager *MusicManager) Find(name string) *Music {

	if len(manager.musics) <= 0 {
		return nil
	}
	for _, music := range manager.musics {
		if music.Name == name {
			return &music
		}

	}
	return nil
}

func (manager *MusicManager) Add(music *Music) {
	manager.musics = append(manager.musics, *music)
}

func (manager *MusicManager) Remove(name string) *Music {

	if name == "" || len(manager.musics) == 0 {
		return nil
	}
	if manager.Find(name) == nil {
		return nil
	}
	index := -1
	for i, music := range manager.musics {
		if music.Name == name {
			index = i
			break
		}
	}
	if index == -1 {
		return nil
	}
	removedMusic := &manager.musics[index]
	if index < len(manager.musics)-1 {
		manager.musics = append(manager.musics[:index-1], manager.musics[index+1:]...)
	} else if index == 0 {
		manager.musics = make([]Music, 0)
	} else {
		manager.musics = manager.musics[:index-1]
	}
	return removedMusic
}
