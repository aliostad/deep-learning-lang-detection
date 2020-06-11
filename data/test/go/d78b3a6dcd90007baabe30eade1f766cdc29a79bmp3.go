package mp3

import (
	"errors"
	"fmt"
	"log"
)

//解析MP3头，从MP3头中提取必要的MP3格式信息
//MP3头,四个字节
type MP3Header struct {
	version     byte
	layer       byte
	bitrate     byte
	samplerate  byte
	channelMode byte

	Bitrate    int
	SampleRate int
	Channel    int
}

func ParseMP3Header(data []byte) (header *MP3Header, err error) {
	header = &MP3Header{}
	if len(data) < 4 {
		return nil, errors.New("no enough mp3 header data")
	}
	//sync
	if data[0] != 0xff || (data[1]&0xe0) != 0xe0 {
		return nil, errors.New("invalid mp3 sync data")
	}
	header.version = ((data[1] & 0x18) >> 3)
	header.layer = ((data[1] & 0x6) >> 1)
	header.bitrate = ((data[2] & 0xf0) >> 4)
	header.samplerate = ((data[2] & 0xc) >> 2)
	header.channelMode = ((data[3] & 0xc0) >> 6)
	//计算比特率和采样率和声道
	//bitrate
	switch header.version {
	//MPEG2.5
	case 0:
		switch header.layer {
		//layer 3
		case 1:
			switch header.bitrate {
			case 0:
				header.Bitrate = 0
			case 1:
				header.Bitrate = 8
			case 2:
				header.Bitrate = 16
			case 3:
				header.Bitrate = 24
			case 4:
				header.Bitrate = 32
			case 5:
				header.Bitrate = 40
			case 6:
				header.Bitrate = 48
			case 7:
				header.Bitrate = 56
			case 8:
				header.Bitrate = 64
			case 9:
				header.Bitrate = 80
			case 10:
				header.Bitrate = 96
			case 11:
				header.Bitrate = 112
			case 12:
				header.Bitrate = 128
			case 13:
				header.Bitrate = 144
			case 14:
				header.Bitrate = 160
			case 15:
				header.Bitrate = 0
			}
		//layer 2
		case 2:
			switch header.bitrate {
			case 0:
				header.Bitrate = 0
			case 1:
				header.Bitrate = 8
			case 2:
				header.Bitrate = 16
			case 3:
				header.Bitrate = 24
			case 4:
				header.Bitrate = 32
			case 5:
				header.Bitrate = 40
			case 6:
				header.Bitrate = 48
			case 7:
				header.Bitrate = 56
			case 8:
				header.Bitrate = 64
			case 9:
				header.Bitrate = 80
			case 10:
				header.Bitrate = 96
			case 11:
				header.Bitrate = 112
			case 12:
				header.Bitrate = 128
			case 13:
				header.Bitrate = 160
			case 14:
				header.Bitrate = 384
			case 15:
				header.Bitrate = 0
			}
		//layer 1
		case 3:
			switch header.bitrate {
			case 0:
				header.Bitrate = 0
			case 1:
				header.Bitrate = 32
			case 2:
				header.Bitrate = 48
			case 3:
				header.Bitrate = 56
			case 4:
				header.Bitrate = 64
			case 5:
				header.Bitrate = 80
			case 6:
				header.Bitrate = 96
			case 7:
				header.Bitrate = 112
			case 8:
				header.Bitrate = 128
			case 9:
				header.Bitrate = 144
			case 10:
				header.Bitrate = 160
			case 11:
				header.Bitrate = 176
			case 12:
				header.Bitrate = 192
			case 13:
				header.Bitrate = 224
			case 14:
				header.Bitrate = 256
			case 15:
				header.Bitrate = 0
			}
		}
	//MPEG2
	case 2:
		switch header.layer {
		//layer 3
		case 1:
			switch header.bitrate {
			case 0:
				header.Bitrate = 0
			case 1:
				header.Bitrate = 8
			case 2:
				header.Bitrate = 16
			case 3:
				header.Bitrate = 24
			case 4:
				header.Bitrate = 32
			case 5:
				header.Bitrate = 64
			case 6:
				header.Bitrate = 80
			case 7:
				header.Bitrate = 56
			case 8:
				header.Bitrate = 64
			case 9:
				header.Bitrate = 128
			case 10:
				header.Bitrate = 160
			case 11:
				header.Bitrate = 112
			case 12:
				header.Bitrate = 128
			case 13:
				header.Bitrate = 256
			case 14:
				header.Bitrate = 320
			case 15:
				header.Bitrate = 0
			}
		//layer 2
		case 2:
			switch header.bitrate {
			case 0:
				header.Bitrate = 0
			case 1:
				header.Bitrate = 32
			case 2:
				header.Bitrate = 48
			case 3:
				header.Bitrate = 56
			case 4:
				header.Bitrate = 64
			case 5:
				header.Bitrate = 80
			case 6:
				header.Bitrate = 96
			case 7:
				header.Bitrate = 112
			case 8:
				header.Bitrate = 128
			case 9:
				header.Bitrate = 160
			case 10:
				header.Bitrate = 192
			case 11:
				header.Bitrate = 224
			case 12:
				header.Bitrate = 256
			case 13:
				header.Bitrate = 320
			case 14:
				header.Bitrate = 384
			case 15:
				header.Bitrate = 0
			}
		//layer 1
		case 3:
			switch header.bitrate {
			case 0:
				header.Bitrate = 0
			case 1:
				header.Bitrate = 32
			case 2:
				header.Bitrate = 64
			case 3:
				header.Bitrate = 96
			case 4:
				header.Bitrate = 128
			case 5:
				header.Bitrate = 160
			case 6:
				header.Bitrate = 192
			case 7:
				header.Bitrate = 224
			case 8:
				header.Bitrate = 256
			case 9:
				header.Bitrate = 288
			case 10:
				header.Bitrate = 320
			case 11:
				header.Bitrate = 352
			case 12:
				header.Bitrate = 384
			case 13:
				header.Bitrate = 416
			case 14:
				header.Bitrate = 448
			case 15:
				header.Bitrate = 0
			}
		}
	//MPEG1
	case 3:
		switch header.layer {
		//layer 3
		case 1:
			switch header.bitrate {
			case 0:
				header.Bitrate = 0
			case 1:
				header.Bitrate = 32
			case 2:
				header.Bitrate = 40
			case 3:
				header.Bitrate = 48
			case 4:
				header.Bitrate = 56
			case 5:
				header.Bitrate = 64
			case 6:
				header.Bitrate = 80
			case 7:
				header.Bitrate = 96
			case 8:
				header.Bitrate = 112
			case 9:
				header.Bitrate = 128
			case 10:
				header.Bitrate = 160
			case 11:
				header.Bitrate = 192
			case 12:
				header.Bitrate = 224
			case 13:
				header.Bitrate = 256
			case 14:
				header.Bitrate = 320
			case 15:
				header.Bitrate = 0
			}
		//layer 2
		case 2:
			switch header.bitrate {
			case 0:
				header.Bitrate = 0
			case 1:
				header.Bitrate = 32
			case 2:
				header.Bitrate = 48
			case 3:
				header.Bitrate = 56
			case 4:
				header.Bitrate = 64
			case 5:
				header.Bitrate = 80
			case 6:
				header.Bitrate = 96
			case 7:
				header.Bitrate = 112
			case 8:
				header.Bitrate = 128
			case 9:
				header.Bitrate = 160
			case 10:
				header.Bitrate = 192
			case 11:
				header.Bitrate = 224
			case 12:
				header.Bitrate = 256
			case 13:
				header.Bitrate = 320
			case 14:
				header.Bitrate = 384
			case 15:
				header.Bitrate = 0
			}
		//layer 1
		case 3:
			switch header.bitrate {
			case 0:
				header.Bitrate = 0
			case 1:
				header.Bitrate = 32
			case 2:
				header.Bitrate = 64
			case 3:
				header.Bitrate = 96
			case 4:
				header.Bitrate = 128
			case 5:
				header.Bitrate = 160
			case 6:
				header.Bitrate = 192
			case 7:
				header.Bitrate = 224
			case 8:
				header.Bitrate = 256
			case 9:
				header.Bitrate = 288
			case 10:
				header.Bitrate = 320
			case 11:
				header.Bitrate = 352
			case 12:
				header.Bitrate = 384
			case 13:
				header.Bitrate = 416
			case 14:
				header.Bitrate = 448
			case 15:
				header.Bitrate = 0
			}
		}
	}

	//samplerate
	switch header.version {
	//MPEG2.5
	case 0:
		switch header.samplerate {
		case 0:
			header.SampleRate = 11025
		case 1:
			header.SampleRate = 12000
		case 2:
			header.SampleRate = 8000
		}
		//MPEG2
	case 2:
		switch header.samplerate {
		case 0:
			header.SampleRate = 22050
		case 1:
			header.SampleRate = 24000
		case 2:
			header.SampleRate = 16000
		}
		//MPEG1
	case 3:
		switch header.samplerate {
		case 0:
			header.SampleRate = 44100
		case 1:
			header.SampleRate = 48000
		case 2:
			header.SampleRate = 32000
		}
	default:
		log.Println(fmt.Sprintf("invlaid mp3 version:%d", header.version))
	}
	//channel
	if header.channelMode == 3 {
		header.Channel = 1
	} else {
		header.Channel = 2
	}
	return
}
