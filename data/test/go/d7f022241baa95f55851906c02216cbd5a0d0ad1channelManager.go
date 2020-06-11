package system

import (
	"sync"
	//    "errors"
	"../util"
)
//description
// manager request channel
// method1 ---> now
// method2 ---> sync.pool manager channel
type ChannelManager struct {
	channels []Channel
	mapSrc   map[string]*Channel
	mapDst   map[string]*Channel
	mutex    *sync.Mutex
}

//description
// channelManger init
func (channelManager *ChannelManager) Init() {
	channelManager.channels = make([]Channel, 0)
	channelManager.mapSrc = make(map[string]*Channel)
	channelManager.mapDst = make(map[string]*Channel)
	channelManager.mutex = new(sync.Mutex)
}


// description
// get src length
func (channelManager *ChannelManager) GetChannelsLen() int {
    return len(channelManager.channels)
}

//description
// delte map
func deleteMap(_map map[string]*Channel, url string) {
	_, ok := _map[url]
	if ok {
		delete(_map, url)
	}
}

//description
// channelManager clean
func (channelManager *ChannelManager) Clean() {
	for _, channel := range channelManager.channels {
		deleteMap(channelManager.mapSrc, channel.SrcUrl())
		deleteMap(channelManager.mapDst, channel.DstUrl())
		channel.Close()
	}
	channelManager.channels = channelManager.channels[:0]
}

//description
// channelManager add channel
func (channelManager *ChannelManager) Put(channel *Channel) {
	channelManager.mutex.Lock()
	channelManager.channels = append(channelManager.channels, *channel)
	channelManager.mapSrc[channel.SrcUrl()] = channel
	channelManager.mapDst[channel.DstUrl()] = channel
	defer channelManager.mutex.Unlock()
}

// description
// channelManager del channel
func (channelManager *ChannelManager) Delete(channel *Channel) {
	channelManager.mutex.Lock()
	index := util.SliceIndex(channelManager.channels, *channel)
	if index >= 0 {
		//change slice value
		channelManager.channels = append(channelManager.channels[:index], channelManager.channels[index+1:]...)
		deleteMap(channelManager.mapSrc, channel.SrcUrl())
		deleteMap(channelManager.mapDst, channel.SrcUrl())
	}
	defer channelManager.mutex.Unlock()

}

// description
func (channelManager *ChannelManager) GetChannels() []Channel {
	return channelManager.channels
}
