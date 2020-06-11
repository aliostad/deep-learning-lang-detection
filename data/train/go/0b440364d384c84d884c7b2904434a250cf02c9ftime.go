package niftyutils

import (
	"bytes"
	"strconv"
	"time"
)

//Not used anymore after realization that a client side fuzzy time in javascript is better - using livestamp for that
func FuzzyTime(d time.Duration) string {
	s := int(d.Seconds())
	h := int(s / 3600)

	var buffer bytes.Buffer

	if h > 0 {
		buffer.WriteString(strconv.Itoa(h))
		buffer.WriteString(" hour")

		if h > 1 {
			buffer.WriteString("s")
		}

		s = s - (h * 3600)
	}

	m := int(s / 60)

	if m > 0 {
		if h > 0 {
			buffer.WriteString(", ")
		}

		buffer.WriteString(strconv.Itoa(m))
		buffer.WriteString(" minute")

		if m > 1 {
			buffer.WriteString("s")
		}

		s = s - (m * 60)
	}

	if s > 0 {
		if h > 0 || m > 0 {
			buffer.WriteString(", ")
		}

		buffer.WriteString(strconv.Itoa(s))
		buffer.WriteString(" second")

		if s > 1 {
			buffer.WriteString("s")
		}

	}

	if buffer.String() == "" {
		return "almost a second ago"
	} else {
		buffer.WriteString(" ago")
	}

	return buffer.String()
}
