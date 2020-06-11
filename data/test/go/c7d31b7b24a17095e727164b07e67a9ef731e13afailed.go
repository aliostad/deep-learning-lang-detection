package model

import "bytes"

// FailedTest represents info about failed test
type FailedTest struct {
	ARN      string
	Class    string
	Method   string
	Message  string
	Device   string
	OS       string
	LogURL   string
	VideoURL string
}

// ToString generate string from struct
func (f *FailedTest) ToString() string {
	var buf bytes.Buffer
	if f.Class != "" {
		buf.WriteString("Class: ")
		buf.WriteString(f.Class)
		buf.WriteString("\n")
	}
	if f.Method != "" {
		buf.WriteString("Method: ")
		buf.WriteString(f.Method)
		buf.WriteString("\n")
	}
	if f.Message != "" {
		buf.WriteString("Error: ")
		buf.WriteString(f.Message)
		buf.WriteString("\n")
	}
	if f.Device != "" {
		buf.WriteString("Device: ")
		buf.WriteString(f.Device)
		buf.WriteString("\n")
	}
	if f.OS != "" {
		buf.WriteString("OS version: ")
		buf.WriteString(f.OS)
		buf.WriteString("\n")
	}
	if f.LogURL != "" {
		buf.WriteString("URL for log: ")
		buf.WriteString(f.LogURL)
		buf.WriteString("\n")
	}
	if f.VideoURL != "" {
		buf.WriteString("URL for video: ")
		buf.WriteString(f.VideoURL)
		buf.WriteString("\n")
	}
	buf.WriteString("//==================================")
	buf.WriteString("\n")
	return buf.String()
}
