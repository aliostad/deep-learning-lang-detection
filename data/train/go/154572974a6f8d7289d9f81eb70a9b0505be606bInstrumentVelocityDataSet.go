package rti

import (
	"encoding/binary"
	"math"
)

// InstrumentVelocityDataSet will contain all the Instrument Velocity Data set values.
// These values describe water profile data in m/s.
// The data will be stored in array.  The array size will be based off the
// base data set.
// Bin x Beam
type InstrumentVelocityDataSet struct {
	Base     BaseDataSet // Base Dataset
	Velocity [][]float32 // Velcity data in m/s
}

// Decode will take the binary data and decode into
// into the ensemble data set.
func (vel *InstrumentVelocityDataSet) Decode(data []byte) {

	// Initialize the 2D array
	// [Bins][Beams]
	vel.Velocity = make([][]float32, vel.Base.NumElements)
	for i := range vel.Velocity {
		vel.Velocity[i] = make([]float32, vel.Base.ElementMultiplier)
	}

	// Not enough data
	if uint32(len(data)) < vel.Base.NumElements*vel.Base.ElementMultiplier*uint32(BytesInFloat) {
		return
	}

	// Set each beam and bin data
	ptr := 0
	for beam := 0; beam < int(vel.Base.ElementMultiplier); beam++ {
		for bin := 0; bin < int(vel.Base.NumElements); bin++ {
			// Get the location of the data
			ptr = GetBinBeamIndex(int(vel.Base.NameLen), int(vel.Base.NumElements), beam, bin)

			// Set the data to float
			bits := binary.LittleEndian.Uint32(data[ptr : ptr+BytesInFloat])
			vel.Velocity[bin][beam] = math.Float32frombits(bits)
		}
	}

}
