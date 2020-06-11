package rtmp

// SEE:
//	http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/NetConnection.html
//	http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/NetStream.html
// 	http://help.adobe.com/en_US/as3/dev/WS5b3ccc516d4fbf351e63e3d118a9b90204-7d4e.html
//

type NetConn struct {
}

func (*NetConn) Connect()      {}
func (*NetConn) Call()         {}
func (*NetConn) Close()        {}
func (*NetConn) CreateStream() {}

type NetStream struct {
}

func (*NetStream) Play()         {}
func (*NetStream) Play2()        {}
func (*NetStream) DeleteStream() {}
func (*NetStream) CloseStream()  {}
func (*NetStream) ReceiveAudio() {}
func (*NetStream) ReceiveVideo() {}
func (*NetStream) Publish()      {}
func (*NetStream) Seek()         {}
func (*NetStream) Pause()        {}
