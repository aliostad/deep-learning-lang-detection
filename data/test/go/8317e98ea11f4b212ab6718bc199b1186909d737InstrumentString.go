package theory

//InstrumentString is the state of a single string on a stringed instrument. First, check
//Disabled to see if this string is used or not, then Fret and Finger can give information about how its played.
type InstrumentString interface {
	Fret() int8
	Finger() Finger
	Disabled() bool
}

type instrumentString struct {
	fret   int8
	finger Finger
}

//Given a int8 that indicates which fret and a Finger, create a new InstrumentString.
//Pass -1 for the fret to indicate it should be disabled
func CreateInstrumentString(fret int8, finger Finger) InstrumentString {
	return instrumentString{
		fret: fret,
		finger: finger}
}
//Given a int8 that indicates which fret and int for Finger, create a new InstrumentString.
//Pass -1 for the fret to indicate it should be disabled
func CreateInstrumentStringInt(fret int8, finger int) InstrumentString {
	return CreateInstrumentString(fret, CreateFinger(finger))
}

func (string instrumentString) Fret() int8 {
	return string.fret
}

func (string instrumentString) Finger() Finger {
	return string.finger
}

func (string instrumentString) Disabled() bool {
	return string.fret == -1
}