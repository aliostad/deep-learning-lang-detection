package streamer

type Streamer struct {
	Name      string
	AuthRPC   AuthRPC
	SocialRPC SocialRPC
	ContentRPC ContentRPC
	/*

		oAuthRPC OAuthRPC
	*/
}

type StreamerManager struct {
	Sm map[string]Streamer
}

var streamerManager *StreamerManager

func GetStreamerManager() *StreamerManager {
	if streamerManager == nil {
		streamerManager = &StreamerManager{}
		streamerManager.Sm = make(map[string]Streamer)
	}
	return streamerManager
}

func (streamerMan *StreamerManager) RegisterStreamer(name string, s Streamer) {
	streamerMan.Sm[name] = s
}

func (streamerMan *StreamerManager) Get(name string) Streamer {
	return streamerMan.Sm[name]
}
