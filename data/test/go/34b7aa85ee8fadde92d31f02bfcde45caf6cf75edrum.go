// Package drum is supposed to implement the decoding of .splice drum machine files.
// See golang-challenge.com/go-challenge1/ for more information
package drum

import (
	"encoding/binary"
	"math"
)

//testing a github commit thing
func decode(buff []byte, limit int64) Pattern {

	pattern := Pattern{
		Version: string(buff[14:45]),
		Tempo:   math.Float32frombits(binary.LittleEndian.Uint32(buff[46:54])),
	}

	index := 50
	for index < int(limit)-21 {
		var t Track
		index, t = getTracks(buff, index)
		pattern.Tracks = append(pattern.Tracks, t)
	}
	return pattern
}

func getTrackId(buff []byte, index int) (int, int) {
	trackId := int(buff[index])
	index += 4
	return index, trackId
}

func getTracks(buff []byte, index int) (int, Track) {
	track := Track{}
	index, track.Id = getTrackId(buff, index)
	index, track.Instrument = getTrackInstrument(buff, index)

	for i := 0; i < 16; i++ {
		if i%4 == 0 {
			track.Beat += "|"
		}
		if buff[index+i] == 01 {
			track.Beat += "x"
		} else {
			track.Beat += "-"
		}
	}
	track.Beat += "|"
	index += 16

	return index, track
}

func getTrackInstrument(buff []byte, index int) (int, string) {
	stringLen := int(buff[index])
	index2 := index + 1 + stringLen
	instrument := string(buff[index+1 : index2])
	return index2, instrument
}
