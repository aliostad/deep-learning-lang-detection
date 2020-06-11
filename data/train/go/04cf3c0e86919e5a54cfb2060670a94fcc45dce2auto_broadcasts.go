package xmmsclient

// auto-generated

import (
	"bytes"
)

type IntBroadcast struct {
	result chan reply
}

type StringBroadcast struct {
	result chan reply
}

type DictBroadcast struct {
	result chan reply
}

func (b *IntBroadcast) Next() (XmmsInt, error) {
	__reply := <- b.result
	if __reply.err != nil {
		return -1, __reply.err
	}
	__buffer := bytes.NewBuffer(__reply.payload)
	__value, __err := tryDeserialize(__buffer)
	if __err != nil {
		return -1, __err
	}
	return __value.(XmmsInt), nil
}

func (b *StringBroadcast) Next() (XmmsString, error) {
	__reply := <- b.result
	if __reply.err != nil {
		return "", __reply.err
	}
	__buffer := bytes.NewBuffer(__reply.payload)
	__value, __err := tryDeserialize(__buffer)
	if __err != nil {
		return "", __err
	}
	return __value.(XmmsString), nil
}

func (b *DictBroadcast) Next() (XmmsDict, error) {
	__reply := <- b.result
	if __reply.err != nil {
		return XmmsDict{}, __reply.err
	}
	__buffer := bytes.NewBuffer(__reply.payload)
	__value, __err := tryDeserialize(__buffer)
	if __err != nil {
		return XmmsDict{}, __err
	}
	return __value.(XmmsDict), nil
}


// This broadcast is triggered when the daemon is shutting down.
func (c *Client) BroadcastMainQuit() IntBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(0)})
	return IntBroadcast{__chan}
}

// This broadcast is triggered when the playlist changes.
func (c *Client) BroadcastPlaylistChanged() DictBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(1)})
	return DictBroadcast{__chan}
}

// This broadcast is triggered when the position in the playlist changes.
func (c *Client) BroadcastPlaylistCurrentPos() DictBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(2)})
	return DictBroadcast{__chan}
}

// This broadcast is triggered when another playlist is loaded.
func (c *Client) BroadcastPlaylistLoaded() StringBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(3)})
	return StringBroadcast{__chan}
}

// This broadcast is triggered when the value of any config property changes.
func (c *Client) BroadcastConfigValueChanged() DictBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(4)})
	return DictBroadcast{__chan}
}

// This broadcast is triggered when the playback status changes.
func (c *Client) BroadcastPlaybackStatus() IntBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(5)})
	return IntBroadcast{__chan}
}

// This broadcast is triggered when the playback volume changes.
func (c *Client) BroadcastPlaybackVolumeChanged() DictBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(6)})
	return DictBroadcast{__chan}
}

// This broadcast is triggered when the played song's media ID changes.
func (c *Client) BroadcastPlaybackCurrentId() IntBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(7)})
	return IntBroadcast{__chan}
}

// This broadcast is triggered when an entry is added to the medialib.
func (c *Client) BroadcastMedialibEntryAdded() IntBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(9)})
	return IntBroadcast{__chan}
}

// This broadcast is triggered when the properties of a medialib entry are changed.
func (c *Client) BroadcastMedialibEntryChanged() IntBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(10)})
	return IntBroadcast{__chan}
}

// This broadcast is triggered when a medialib entry is removed.
func (c *Client) BroadcastMedialibEntryRemoved() IntBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(11)})
	return IntBroadcast{__chan}
}

// This broadcast is triggered when a collection is changed.
func (c *Client) BroadcastCollectionChanged() DictBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(12)})
	return DictBroadcast{__chan}
}

// This broadcast is triggered when the status of the mediainfo reader changes.
func (c *Client) BroadcastMediainfoReaderStatus() IntBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(13)})
	return IntBroadcast{__chan}
}

// This broadcast carries client-to-client messages.
func (c *Client) BroadcastCourierMessage() DictBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(15)})
	return DictBroadcast{__chan}
}

// This broadcast is emitted when a client's services are ready.
func (c *Client) BroadcastCourierReady() IntBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(16)})
	return IntBroadcast{__chan}
}

// This broadcast is emitted when a new client connects.
func (c *Client) BroadcastIpcManagerClientConnected() IntBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(17)})
	return IntBroadcast{__chan}
}

// This broadcast is emitted when a client disconnects.
func (c *Client) BroadcastIpcManagerClientDisconnected() IntBroadcast {
	__chan := c.dispatch(0, 33, XmmsList{XmmsInt(18)})
	return IntBroadcast{__chan}
}
