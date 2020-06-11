//  Copyright 2013 Thomas McGrew
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

package mzlib

import (
	"errors"
	"fmt"
	"math"
	"strings"
)

const (
	// The mzlib version.
	Version string = "0.2.2013.03.07"
)

// Represents the raw data from a mass spectrometry file.
type RawData struct {
	Filename   string
	SourceFile string
	Instrument Instrument
	ScanCount  uint64
	Scans      []Scan
}

// Represents instrument metadata from the read in file.
type Instrument struct {
	Manufacturer string
	Model        string
	MassAnalyzer string
	Detector     string
	Resolution   float64
	Accuracy     float64
	Ionization   string
}

// Creates a copy of this RawData object
func (r *RawData) Clone() RawData {
	cpy := RawData{}
	cpy.Filename = r.Filename
	cpy.SourceFile = r.SourceFile
	cpy.ScanCount = r.ScanCount
	cpy.Instrument.Manufacturer = r.Instrument.Manufacturer
	cpy.Instrument.Model = r.Instrument.Model
	cpy.Instrument.MassAnalyzer = r.Instrument.MassAnalyzer
	cpy.Instrument.Detector = r.Instrument.Detector
	cpy.Instrument.Resolution = r.Instrument.Resolution
	cpy.Instrument.Accuracy = r.Instrument.Accuracy
	cpy.Instrument.Ionization = r.Instrument.Ionization
	for _, s := range r.Scans {
		cpy.Scans = append(cpy.Scans, *s.Clone())
	}
	return cpy
}

// Creates a copy of this RawData object containing only level 1 scans.
func (r *RawData) Level1() RawData {
	cpy := RawData{}
	cpy.Filename = r.Filename
	cpy.SourceFile = r.SourceFile
	cpy.Instrument.Manufacturer = r.Instrument.Manufacturer
	cpy.Instrument.Model = r.Instrument.Model
	cpy.Instrument.MassAnalyzer = r.Instrument.MassAnalyzer
	cpy.Instrument.Detector = r.Instrument.Detector
	cpy.Instrument.Resolution = r.Instrument.Resolution
	cpy.Instrument.Accuracy = r.Instrument.Accuracy
	cpy.Instrument.Ionization = r.Instrument.Ionization
	for _, s := range r.Scans {
    if s.MsLevel == 1 {
      cpy.Scans = append(cpy.Scans, *s.Clone())
    }
	}
	cpy.ScanCount = uint64(len(cpy.Scans))
	return cpy
}

// Retreives the scan closest to the specified retention time
//
// Paramters:
//   retentionTime: The retention time value in minutes to locate the scan for.
func (r *RawData) GetScan(retentionTime float64) *Scan {
	var returnvalue *Scan
	if len(r.Scans) > 0 {
		returnvalue = &r.Scans[0]
	}
	diff := math.Abs((*returnvalue).RetentionTime - retentionTime)
	for i, l := 1, len(r.Scans); i < l; i++ {
		if math.Abs(r.Scans[i].RetentionTime-retentionTime) < diff {
			returnvalue = &r.Scans[i]
			diff = math.Abs((*returnvalue).RetentionTime - retentionTime)
		}
	}
	return returnvalue
}

// Removes any scans inside the specified range.
//
// Parameters:
//   minTime: The minimum retention time value in minutes to discard (inclusive)
//   maxTime: The maximum retention time value in minutes to discard (exclusive)
//
// Return value:
//   uint64: The number of scans removed
func (r *RawData) RemoveScans(minTime float64, maxTime float64) uint64 {
	var newScans []Scan
	removed := uint64(0)
	r.ScanCount = 0
	for _, v := range r.Scans {
		if v.RetentionTime < minTime || v.RetentionTime > maxTime {
			newScans = append(newScans, v)
			r.ScanCount++
		} else {
			removed++
		}
	}
	r.Scans = newScans
	return removed
}

// Removes any scans outside the specified range.
//
// Parameters:
//   minTime: The minimum retention time value in minutes to retain (inclusive).
//   maxTime: The maximum retention time value in minutes to retain (exclusive).
//
// Return value:
//   uint64: The number of scans removed
func (r *RawData) OnlyScans(minTime float64, maxTime float64) uint64 {
	var newScans []Scan
	removed := uint64(0)
	r.ScanCount = 0
	for _, v := range r.Scans {
		if v.RetentionTime > minTime && v.RetentionTime < maxTime {
			newScans = append(newScans, v)
			r.ScanCount++
		} else {
			removed++
		}
	}
	r.Scans = newScans
	return removed
}

// Removes any peaks inside the given range.
//
// Parameters:
//   minMz: The minimum m/z value to be removed
//   maxMz: The maximum m/z value to be removed
//
// Return value:
//   uint64 The number of peaks removed
func (r *RawData) RemoveMz(minMz float64, maxMz float64) uint64 {
	removed := uint64(0)
	for i := range r.Scans {
		if r.Scans[i].MsLevel == 1 {
			removed += r.Scans[i].RemoveMz(minMz, maxMz)
		}
	}
	return removed
}

// Removes any peaks outside the given range.
//
// Parameters:
//   minMz: The minimum m/z value to be retained
//   maxMz: The maximum m/z value to be retained
//
// Return value:
//   uint64 The number of peaks removed
func (r *RawData) OnlyMz(minMz float64, maxMz float64) uint64 {
	removed := uint64(0)
	for i := range r.Scans {
		if r.Scans[i].MsLevel == 1 {
			removed += r.Scans[i].OnlyMz(minMz, maxMz)
		}
	}
	return removed
}

// Returns a selected ion chromatogram for the data.
//
// Parameters:
//   minMz: The minimum m/z value to select peaks from.
//   maxMz: The maximum m/z value to select peaks from.
//
// Return value:
// []float64: An array containing the total intensity of all peaks between
//   minMz and maxMz for each scan.
func (r *RawData) Sic(minMz float64, maxMz float64) []float64 {
	returnvalue := make([]float64, 0, r.ScanCount)
	var sum float64
	for _, s := range r.Scans {
		if s.MsLevel == 1 {
			sum = 0.0
			for i, v := range s.MzArray {
				if v > minMz && v < maxMz {
					sum += s.IntensityArray[i]
				}
			}
			returnvalue = append(returnvalue, sum)
		}
	}
	return returnvalue
}

// Returns a total ion chromatogram for the data.
//
// Return value:
// []float64: An array containing the total intensity for each scan.
func (r *RawData) Tic() []float64 {
	returnvalue := make([]float64, 0, r.ScanCount)
	var sum float64
	for _, s := range r.Scans {
		if s.MsLevel == 1 {
			sum = 0.0
			for _, v := range s.IntensityArray {
				sum += v
			}
			returnvalue = append(returnvalue, sum)
		}
	}
	return returnvalue
}

// Returns a base peak chromatogram for the data.
//
// Return value:
// []float64: An array containing the intensity of the largest peak for each
//   level 1 scan
func (r *RawData) Bpc() []float64 {
	returnvalue := make([]float64, 0, r.ScanCount)
	var val float64
	for _, s := range r.Scans {
		if s.MsLevel == 1 {
			val = 0.0
			for _, v := range s.IntensityArray {
				if v > val {
					val = v
				}
			}
			returnvalue = append(returnvalue, val)
		}
	}
	return returnvalue
}

// Finds the minimum m/z value in the data.
//
// Return value:
//   float64: The minimum m/z value.
func (r *RawData) MinMz() float64 {
	returnvalue := math.MaxFloat64
	for _, s := range r.Scans {
		for _, v := range s.MzArray {
			if v < returnvalue {
				returnvalue = v
			}
		}
	}
	return returnvalue
}

// Finds the maximum m/z value in the data.
//
// Return value:
//   float64: The maximum m/z value.
func (r *RawData) MaxMz() float64 {
	returnvalue := float64(-1.0)
	for _, s := range r.Scans {
		for _, v := range s.MzArray {
			if v > returnvalue {
				returnvalue = v
			}
		}
	}
	return returnvalue
}

// Finds the maximum intensity value in the data.
func (r *RawData) PeakIntensity() float64 {
	returnvalue := float64(-1.0)
	for _, s := range r.Scans {
		for _, v := range s.IntensityArray {
			if v > returnvalue {
				returnvalue = v
			}
		}
	}
	return returnvalue
}

// Reads mass spectrometry data from the specified file. The format is
// auto-detected based on the file name.
//
// Parameters:
//   filename: The name of the file to be written to
//
// Return value:
//   error: Indicates whether or not an error occurred while reading the file
func (r *RawData) Read(filename string) error {
	flen := len(filename)
	if flen >= 6 && strings.ToLower(filename[flen-6:]) == ".mzxml" {
		return r.ReadMzXml(filename)
	}
	if flen >= 7 && strings.ToLower(filename[flen-7:]) == ".mzdata" {
		return r.ReadMzData(filename)
	}
	if flen >= 4 && strings.ToLower(filename[flen-4:]) == ".xml" {
		return r.ReadMzData(filename)
	}
	if flen >= 5 && strings.ToLower(filename[flen-5:]) == ".mzml" {
		return r.ReadMzMl(filename)
	}
	return errors.New(fmt.Sprintf("Filetype for '%s' not recognized", filename))
}

// Writes mass spectrometry data to the specified file. The format is auto-
//   detected base on the file name.
func (r *RawData) Write(filename string) error {
	flen := len(filename)
	if flen >= 6 && strings.ToLower(filename[flen-6:]) == ".mzxml" {
		return r.WriteMzXml(filename)
	}
	if flen >= 7 && strings.ToLower(filename[flen-7:]) == ".mzdata" {
		return r.WriteMzData(filename)
	}
	if flen >= 4 && strings.ToLower(filename[flen-4:]) == ".xml" {
		return r.WriteMzData(filename)
	}
	if flen >= 5 && strings.ToLower(filename[flen-5:]) == ".mzml" {
		return r.WriteMzMl(filename)
	}
	return errors.New(fmt.Sprintf("File type for '%s' not recognized", filename))
}
