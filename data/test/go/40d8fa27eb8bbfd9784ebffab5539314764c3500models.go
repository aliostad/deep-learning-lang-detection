package sheetMusic

// sheetMusic is a struct that represents the data of a music sheet from the database.
type sheetMusic struct {
	ID          int
	Remarks     string
	TextVocals  int
	Title       string
	Vocals      int
	Composers   []string
	Files       []string
	Genres      []string
	Instruments []instrument
	Languages   []string
	Lyricists   []string
	Types       []string
}

// Instrument is a struct that represents an Instrument with a Name and Instrumenttype.
type instrument struct {
	Name           string
	InstrumentType string
}

// Collection is a slice of sheetMusic
type collection []sheetMusic
