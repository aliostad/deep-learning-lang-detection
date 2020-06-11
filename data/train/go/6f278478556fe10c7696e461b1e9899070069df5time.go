package main

import (
	"fmt"
	"time"
)

// Time units
const (
	second = 1
	minute = 60 * second
	hour   = 60 * minute
	day    = 24 * hour
	week   = 7 * day
	month  = 30 * day
	year   = 12 * month
)

var now = time.Now().UnixNano()

func reltime(b writer, then int64) {
	const f = "%3d"
	diff := (now - then) / 1e9

	switch {
	case diff <= second:
		b.Write(cSecond)
		b.Write([]byte("  <s"))
		b.Write(cEnd)

	case diff < minute:
		b.Write(cSecond)
		fmt.Fprintf(b, f, diff)
		b.WriteByte('s')
		b.Write(cEnd)

	case diff < hour:
		b.Write(cMinute)
		fmt.Fprintf(b, f, diff/minute)
		b.WriteByte('m')
		b.Write(cEnd)

	case diff < hour*36:
		b.Write(cHour)
		fmt.Fprintf(b, f, diff/hour)
		b.WriteByte('h')
		b.Write(cEnd)

	case diff < month:
		b.Write(cDay)
		fmt.Fprintf(b, f, diff/day)
		b.WriteByte('d')
		b.Write(cEnd)

	case diff < year:
		b.Write(cWeek)
		fmt.Fprintf(b, f, diff/week)
		b.WriteByte('w')
		b.Write(cEnd)

	//case diff < Year:
	//	b.Write(cMonth)
	//	fmt.Fprintf(b, f, diff/Month) +
	//	b.WriteByte('y')
	//	b.Write(cEnd)

	default:
		b.Write(cYear)
		fmt.Fprintf(b, f, diff/year)
		b.WriteByte('y')
		b.Write(cEnd)
	}
}

func reltimeNoColor(b writer, then int64) {
	const f = "%3d"
	diff := (now - then) / 1e9

	switch {
	case diff <= second:
		b.Write(nSecond)
		b.Write([]byte("  <s"))

	case diff < minute:
		b.Write(nSecond)
		fmt.Fprintf(b, f, diff)
		b.WriteByte('s')

	case diff < hour:
		b.Write(nMinute)
		fmt.Fprintf(b, f, diff/minute)
		b.WriteByte('m')

	case diff < hour*36:
		b.Write(nHour)
		fmt.Fprintf(b, f, diff/hour)
		b.WriteByte('h')

	case diff < month:
		b.Write(nDay)
		fmt.Fprintf(b, f, diff/day)
		b.WriteByte('d')

	case diff < year:
		b.Write(nWeek)
		fmt.Fprintf(b, f, diff/week)
		b.WriteByte('w')

	//case diff < Year:
	//	b.Write(cMonth)
	//	fmt.Fprintf(b, f, diff/Month) +
	//	b.WriteByte('y')
	//	b.Write(cEnd)

	default:
		b.Write(nYear)
		fmt.Fprintf(b, f, diff/year)
		b.WriteByte('y')
	}
}
