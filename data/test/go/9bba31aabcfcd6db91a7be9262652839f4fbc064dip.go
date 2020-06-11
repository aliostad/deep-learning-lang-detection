package stationxml

import (
	"fmt"
)

// Instrument dip in degrees down from horizontal.
// Together azimuth and dip describe the direction of the sensitive axis of the instrument. min: -90, max: 90
type Dip struct {
	Float
}

func (d Dip) IsValid() error {

	if err := Validate(d.Float); err != nil {
		return err
	}

	if d.Unit != "" && d.Unit != "DEGREES" {
		return fmt.Errorf("dip invalid unit: %s", d.Unit)
	}
	if d.Value < -90 || d.Value > 90 {
		return fmt.Errorf("dip outside range: %g", d.Value)
	}

	return nil
}
