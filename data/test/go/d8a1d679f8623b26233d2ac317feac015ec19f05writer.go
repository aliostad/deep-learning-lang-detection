
package mp4

import (
	"github.com/go-av/av"
	"os"
	"io"
	"fmt"
	"bytes"
)

/*
Usage:

m := mp4.Create("xx", "fps", 24, "samplerate", 44100)
m.WriteH264(data)
m.WriteAAC(data)
m.WritePacket(&mp4.Packet{...})
m.Close()

m.SaveAs()

*/

func (m *mp4) writeFTYP(w io.Writer) {
	WriteTag(w, "ftyp", func (w io.Writer) {
		WriteString(w, "isom")
		WriteInt(w, 1, 4) // minor
		WriteString(w, "isomavc1")
	})
}

func (m *mp4) writeTKHD(w io.Writer, t *mp4trk) {
	WriteTag(w, "tkhd", func (w io.Writer) {
		WriteInt(w, 0, 1) // version
		WriteInt(w, 0xf, 3) // flags (track enabled)
		WriteInt(w, 0, 4) // create time
		WriteInt(w, 0, 4) // modify time
		WriteInt(w, 0, 4) // track id
		WriteInt(w, 0, 4) // reserved

		WriteInt(w, t.dur, 4) // duration
		WriteInt(w, 0, 4) // reserved
		WriteInt(w, 0, 4) // reserved
		WriteInt(w, 0, 2) // layer

		switch t.codec {
		case av.H264:
			WriteInt(w, 1, 2) // alternate group
			WriteInt(w, 0, 2) // alternate group
		case av.AAC:
			WriteInt(w, 2, 2) // alternate group
			WriteInt(w, 0x100, 2) // volume
		default:
			WriteInt(w, 0, 2) // alternate group
			WriteInt(w, 0, 2) // 
		}

		WriteInt(w, 0, 2) // reserved

		/* Matrix structure */
		WriteInt(w, 0x00010000, 4) /* reserved */
		WriteInt(w, 0x0, 4) /* reserved */
		WriteInt(w, 0x0, 4) /* reserved */
		WriteInt(w, 0x0, 4) /* reserved */
		WriteInt(w, 0x00010000, 4) /* reserved */
		WriteInt(w, 0x0, 4) /* reserved */
		WriteInt(w, 0x0, 4) /* reserved */
		WriteInt(w, 0x0, 4) /* reserved */
		WriteInt(w, 0x40000000, 4) /* reserved */

		WriteInt(w, 0, 4) // reserved (width)
		WriteInt(w, 0, 4) // reserved (height)
	})
}

func (m *mp4) writeMDHD(w io.Writer, t *mp4trk) {
	WriteTag(w, "mdhd", func (w io.Writer) {
		WriteInt(w, 0, 1) // version
		WriteInt(w, 0, 3) // flags

		WriteInt(w, 0, 4) // create time
		WriteInt(w, 0, 4) // modify time

		WriteInt(w, t.timeScale, 4) // time scale
		WriteInt(w, t.dur, 4) // duration
		WriteInt(w, 0, 2) // language
		WriteInt(w, 0, 2) // quality
	})
}

func (m *mp4) writeHDLR(w io.Writer, t *mp4trk) {
	WriteTag(w, "hdlr", func (w io.Writer) {
		WriteInt(w, 0, 1) // version
		WriteInt(w, 0, 3) // flags

		var hdlrtype, desc string
		switch t.codec {
		case av.H264:
			hdlrtype = "vide"
			desc = "VideoHandler"
		case av.AAC:
			hdlrtype = "soun"
			desc = "SoundHandler"
		}

		w.Write([]byte{0,0,0,0}) // handler 
		WriteString(w, hdlrtype) // handler type
		WriteInt(w, 0, 4) // reserved
		WriteInt(w, 0, 4) // reserved
		WriteInt(w, 0, 4) // reserved

		WriteInt(w, len(desc), 1) // len
		WriteString(w, desc) // str
	})
}

func (m *mp4) writeVMHD(w io.Writer, t *mp4trk) {
	WriteTag(w, "vmhd", func (w io.Writer) {
		WriteInt(w, 1, 1) // version
		WriteInt(w, 0, 3) // flags
		WriteInt(w, 0, 8) // resverd
	})
}

func (m *mp4) writeSMHD(w io.Writer, t *mp4trk) {
	WriteTag(w, "smhd", func (w io.Writer) {
		WriteInt(w, 1, 1) // version
		WriteInt(w, 0, 3) // flags
		WriteInt(w, 0, 4) // resverd
	})
}

func (m *mp4) writeDINF(w io.Writer, t *mp4trk) {
	WriteTag(w, "dref", func (w io.Writer) {
		WriteInt(w, 0, 4) // version & flags
		WriteInt(w, 1, 4) // entry count
		WriteTag(w, "url ", func (w io.Writer) {
			WriteInt(w, 1, 4) // version & flags
		})
	})
}

func (m *mp4) writeVideoTag(w io.Writer, t *mp4trk) {
	WriteTag(w, "avc1", func (w io.Writer) {
		WriteInt(w, 0, 4) // resv
		WriteInt(w, 0, 2) // resv
		WriteInt(w, 1, 2) // data-ref index
		WriteInt(w, 0, 2) // codec stream version
		WriteInt(w, 0, 2) // codec stream reversion
		WriteInt(w, 0, 4) // resv
		WriteInt(w, 0, 4) // resv
		WriteInt(w, 0, 4) // resv

		WriteInt(w, 720, 2) // width 
		WriteInt(w, 576, 2) // height

    WriteInt(w, 0x00480000, 4) /* Horizontal resolution 72dpi */
    WriteInt(w, 0x00480000, 4) /* Vertical resolution 72dpi */
    WriteInt(w, 0, 4) /* Data size (= 0) */
    WriteInt(w, 1, 2) /* Frame count (= 1) */

		WriteInt(w, 4, 1) // strlen
		b := make([]byte, 31)
		w.Write(b)

		WriteInt(w, 0x18, 2) // resv
		WriteInt(w, 0xffff, 2) // resv

		WriteTag(w, "avcC", func (w io.Writer) {
			w.Write(t.extra)
		})
	})
}

func WriteDescr(w io.Writer, tag int, cb func (w io.Writer)) {
	var b bytes.Buffer
	cb(&b)
	size := b.Len()+5
	WriteInt(w, tag, 1)
	for i := 3; i >= 1; i-- {
		WriteInt(w, (size>>uint(7*i))|0x80, 1)
	}
	WriteInt(w, size&0x7f, 1)
	w.Write(b.Bytes())
}

func (m *mp4) writeESDS(w io.Writer, t *mp4trk) {
	WriteTag(w, "esds", func (w io.Writer) {
		WriteInt(w, 0, 4) // version
		WriteDescr(w, 3, func (w io.Writer) {
			WriteInt(w, 0, 2) // track id
			WriteInt(w, 0, 1) // flags
			WriteDescr(w, 4, func (w io.Writer) {
				bufsize := 1000
				switch t.codec {
				case av.H264:
					WriteInt(w, 0x21, 1)
					WriteInt(w, 0x11, 1) // video stream
					WriteInt(w, bufsize, 3)
					WriteInt(w, 50*1000, 4) // bitrate
				case av.AAC:
					WriteInt(w, 0x40, 1)
					WriteInt(w, 0x15, 1) // audio stream
					WriteInt(w, bufsize, 3)
					WriteInt(w, 20*1000, 4) // max bitrate
				}
				WriteInt(w, 0, 4) // min bitrate (vbr)
				WriteDescr(w, 5, func (w io.Writer) {
					w.Write(t.extra)
				})
			})
			WriteDescr(w, 6, func (w io.Writer) {
				WriteInt(w, 0x2, 1)
			})
		})
	})
}

func (m *mp4) writeAudioTag(w io.Writer, t *mp4trk) {
	WriteTag(w, "mp4a", func (w io.Writer) {
		WriteInt(w, 0, 4) // resv
		WriteInt(w, 0, 2) // resv
		WriteInt(w, 1, 2) // data-ref index

		WriteInt(w, 0, 2) // codec stream version
		WriteInt(w, 0, 2) // codec stream reversion
		WriteInt(w, 0, 4) // resv

		WriteInt(w, 2, 2) // resv
		WriteInt(w, 16, 2) // resv
		WriteInt(w, 0, 2) // resv
		WriteInt(w, 0, 2) // packet size
		WriteInt(w, 44100, 2) // sample rate
		WriteInt(w, 0, 2) // resv
		m.writeESDS(w, t)
	})
}

func (m *mp4) writeSTSD(w io.Writer, t *mp4trk) {
	WriteTag(w, "stsd", func (w io.Writer) {
		WriteInt(w, 0, 4) // version & flags
		WriteInt(w, 1, 4) // entry count
		switch t.codec {
		case av.H264:
			m.writeVideoTag(w, t)
		case av.AAC:
			m.writeAudioTag(w, t)
		}
	})
}

func (m *mp4) writeSTTS(w io.Writer, t *mp4trk) {
	WriteTag(w, "stts", func (w io.Writer) {
		WriteInt(w, 0, 4) // version & flags
		WriteInt(w, len(t.stts), 4) // entry count
		for _, s := range t.stts {
			WriteInt(w, s.cnt, 4)
			WriteInt(w, s.dur, 4)
		}
	})
}

func (m *mp4) writeSTSC(w io.Writer, t *mp4trk) {
	WriteTag(w, "stsc", func (w io.Writer) {
		WriteInt(w, 0, 4) // version & flags
		WriteInt(w, len(t.stsc), 4) // entry count
		for _, s := range t.stsc {
			WriteInt(w, s.first, 4)
			WriteInt(w, s.cnt, 4)
			WriteInt(w, s.id, 4)
		}
	})
}

func (m *mp4) writeSTSZ(w io.Writer, t *mp4trk) {
	WriteTag(w, "stsz", func (w io.Writer) {
		WriteInt(w, 0, 4) // version & flags
		WriteInt(w, 0, 4) // sample size
		WriteInt(w, len(t.sampleSizes), 4) // sample count
		for _, s := range t.sampleSizes {
			WriteInt(w, s, 4)
		}
	})
}

func (m *mp4) writeSTCO(w io.Writer, t *mp4trk) {
	l.Printf("  stco %d", t.codec)
	WriteTag(w, "stco", func (w io.Writer) {
		WriteInt(w, 0, 4) // version & flags
		WriteInt(w, len(t.chunkOffs), 4) // entry count
		for _, s := range t.chunkOffs {
			WriteInt(w, int(s+m.mdatOff), 4)
		}
	})
}

func (m *mp4) writeSTBL(w io.Writer, t *mp4trk) {
	m.writeSTSD(w, t)
	m.writeSTTS(w, t)
	m.writeSTSC(w, t)
	m.writeSTSZ(w, t)
	m.writeSTCO(w, t)
}

func (m *mp4) writeMINF(w io.Writer, t *mp4trk) {
	WriteTag(w, "minf", func (w io.Writer) {
		switch t.codec {
		case av.H264:
			m.writeVMHD(w, t)
		case av.AAC:
			m.writeSMHD(w, t)
		}
		m.writeDINF(w, t)
		m.writeSTBL(w, t)
	})
}

func (m *mp4) writeMDIA(w io.Writer, t *mp4trk) {
	WriteTag(w, "mdia", func (w io.Writer) {
		m.writeMDHD(w, t)
		m.writeHDLR(w, t)
		m.writeMINF(w, t)
	})
}

func (m *mp4) writeTRAK(w io.Writer, t *mp4trk) {
	WriteTag(w, "trak", func (w io.Writer) {
		m.writeTKHD(w, t)
		m.writeMDIA(w, t)
	})
}

func (m *mp4) writeMVHD(w io.Writer) {
	WriteTag(w, "mvhd", func (w io.Writer) {
		WriteInt(w, 0, 1) // version
		WriteInt(w, 0, 3) // flags
		WriteInt(w, 0, 4) // create time
		WriteInt(w, 0, 4) // modify time
		WriteInt(w, 1000, 4) // time scale
		WriteInt(w, int(m.Dur*1000), 4) // duartion of the longest track

		WriteInt(w, 0x00010000, 4) /* reserved (preferred rate) 1.0 = normal */
		WriteInt(w, 0x0100, 2) /* reserved (preferred volume) 1.0 = normal */
		WriteInt(w, 0, 2) /* reserved */
		WriteInt(w, 0, 4) /* reserved */
		WriteInt(w, 0, 4) /* reserved */

		WriteInt(w, 0x00010000, 4) /* reserved */
		WriteInt(w, 0x0, 4) /* reserved */
		WriteInt(w, 0x0, 4) /* reserved */
		WriteInt(w, 0x0, 4) /* reserved */
		WriteInt(w, 0x00010000, 4) /* reserved */
		WriteInt(w, 0x0, 4) /* reserved */
		WriteInt(w, 0x0, 4) /* reserved */
		WriteInt(w, 0x0, 4) /* reserved */
		WriteInt(w, 0x40000000, 4) /* reserved */

		WriteInt(w, 0, 4) /* reserved (preview time) */
		WriteInt(w, 0, 4) /* reserved (preview duration) */
		WriteInt(w, 0, 4) /* reserved (poster time) */
		WriteInt(w, 0, 4) /* reserved (selection time) */
		WriteInt(w, 0, 4) /* reserved (selection duration) */
		WriteInt(w, 0, 4) /* reserved (current time) */
		WriteInt(w, 1, 4) /* Next track id */
	})
}

func (m *mp4) writeMOOV(w io.Writer) {
	WriteTag(w, "moov", func (w io.Writer) {
		m.writeMVHD(w)
		for _, t := range m.trk {
			m.writeTRAK(w, t)
		}
	})
}


func (m *mp4) trkAdd(t *mp4trk, p *av.Packet) {
	if len(t.extra) == 0 {
		t.extra = p.Data
		return
	}
	if p.Key {
		t.keyFrames = append(t.keyFrames, t.i)
	}
	t.sampleSizes = append(t.sampleSizes, len(p.Data))
	off, _ := m.w.Seek(0, 1)
	t.chunkOffs = append(t.chunkOffs, off)
	m.w.Write(p.Data)
	t.i++
	t.stts[0].cnt = t.i
	dur := float32(t.i)*1000.0/float32(t.timeScale)
	t.dur = int(dur*1000)
	if dur > m.Dur {
		m.Dur = dur
	}
}

func newTrk(codec, idx int) (t *mp4trk) {
	t = &mp4trk{
		codec:codec, idx:idx,
		stsc: []mp4stsc{{1, 1, 1}},
	}
	switch codec {
	case av.H264:
		t.timeScale = 25000
		t.stts = []mp4stts{{1, 1000}}
	case av.AAC:
		t.timeScale = 44100
		t.stts = []mp4stts{{1, 1000}}
	}
	return
}

func Create(path string) (m *mp4, err error) {
	tmp := fmt.Sprintf("%s.tmp", path)
	f, err := os.Create(tmp)
	if err != nil {
		return
	}
	f2, err := os.Create(path)
	if err != nil {
		return
	}
	m = &mp4{}
	m.tmp = tmp
	m.path = path
	m.w = f
	m.w2 = f2
	return
}

func (m *mp4) Write(p *av.Packet) {
	var ft *mp4trk
	for _, t := range m.trk {
		if t.codec == p.Codec && t.idx == p.Idx {
			ft = t
			break
		}
	}
	if ft == nil {
		ft = newTrk(p.Codec, p.Idx)
		m.trk = append(m.trk, ft)
	}
	m.trkAdd(ft, p)
}

func (m *mp4) WriteH264(p []byte) {
	m.Write(&av.Packet{Codec:av.H264, Data:p})
}

func (m *mp4) WriteAAC(p []byte) {
	m.Write(&av.Packet{Codec:av.AAC, Data:p})
}

func (m *mp4) closeWriter() {
	l.Printf("  ntrk %v", len(m.trk))

	var b bytes.Buffer

	m.writeFTYP(&b)
	m.writeMOOV(&b)

	m.mdatOff = int64(b.Len() + 8)

	m.writeFTYP(m.w2)
	m.writeMOOV(m.w2)

	size, _ := m.w.Seek(0, 1)
	l.Printf("mdat off %v size %v", m.mdatOff, size)

	WriteInt(m.w2, int(size)+8, 4)
	WriteString(m.w2, "mdat")

	m.w.Seek(0, 0)
	io.Copy(m.w2, m.w)

	m.w2.Close()
	m.w.Close()
	os.Remove(m.tmp)
}

