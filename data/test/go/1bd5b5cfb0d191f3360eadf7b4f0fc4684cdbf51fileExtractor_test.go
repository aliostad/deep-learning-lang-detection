// fileExtractor_test
package fileExtractor

import (
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"testing"
	"time"

	"github.com/BurntSushi/toml"
	"github.com/stretchr/testify/assert"
)

// TODOS:
// - read multiples lines
// - define type for variables, default float64

// usefull macro
var p = fmt.Println
var pf = fmt.Printf

// use for debug mode
var debug io.Writer = ioutil.Discard
var debugMode bool = false

func init() {
	if debugMode {
		debug = os.Stdout
	}
}

var (
	// configFile string = "config.toml"
	configFile string = "cruise.toml"
)

type tomlConfig struct {
	CycleMesure string    `toml:"cruise"`
	Plateforme  string    `toml:"ship"`
	CallSign    string    `toml:"callsign"`
	BeginDate   time.Time `toml:"begin_date"`
	//BeginDate string          `toml:"begin_date"`
	EndDate     time.Time             `toml:"end_date"`
	Institute   string                `toml:"institute"`
	Pi          string                `toml:"pi"`
	Creator     string                `toml:"creator"`
	Instruments map[string]instrument `toml:"instruments"`
	Kml         kml                   `toml:"kml"`
}

type instrument struct {
	FileName        string `toml:"fileName"`
	Type            string `toml:"type"`
	VarList         string `toml:"varList"`
	Separator       string `toml:"separator"`
	PlotNames       string `toml:"plotNames,omitempty"`
	Prefix          int    `toml:"prefix,omitempty"`
	PlotSize        int    `toml:"plotSize,omitempty"`
	SkipLine        int    `toml:"skipLine"`
	HeaderDelimiter string `toml:"header_delimiter"`
}

type kml struct {
	FileName string `toml:"filename"`
}

/* Examples of asser in action
func TestSomething(t *testing.T) {
  assert.Equal(t, 123, 123, "they should be equal")

// if you assert many times, use the below:

func TestSomething(t *testing.T) {
  assert := assert.New(t)
  assert.Equal(123, 123, "they should be equal")
*/

// test default empty FileExtractor object
func TestEmptyFileExtractor(t *testing.T) {
	assert := assert.New(t)
	opts := NewFileExtractOptions()
	assert.Empty(opts.VarsList())
	assert.Empty(opts.hdr)
	assert.Equal(opts.skipLine, -1)
}

// fill and test a valid FileExtractor object
func TestValidFileExtractor(t *testing.T) {
	/*
		assert := assert.New(t)
		fn := "pirata-fr23_tsg"
		opts := NewFileExtractOptions()
		//assert.Equal(opts.Filename(), fn)
		opts.SetVarsList("LATITUDE,3,LONGITUDE,4")
		assert.Equal(opts.VarsList(), map[string]int{"LATITUDE": 3, "LONGITUDE": 4})
		assert.Equal(opts.hdr, []string{"LATITUDE", "LONGITUDE"})
		assert.Len(opts.hdr, 2)
		opts.SetSkipLine(2)
		assert.Equal(opts.skipLine, 2)
	*/
}

// read and test valid FileExtractor object from toml file
func TestFileExtractorFromConfigFile(t *testing.T) {
	var config tomlConfig
	debug = os.Stdout
	assert := assert.New(t)
	configFile := "cruise.toml"

	if _, err := toml.DecodeFile(configFile, &config); err != nil {
		log.Fatal(err)
	}
	/*
		if assert.Error(err, "An error was expected") {
			assert.Equal(err, "test")
		}
	*/
	assert.Equal(config.CycleMesure, "PIRATA-FR26")
	assert.Equal(config.Plateforme, "THALASSA")
	assert.Equal(config.CallSign, "FNFP")
	assert.Equal(config.BeginDate.Format("01/02/2006"), "03/08/2016")
	//tt, _ := time.Parse("02/01/2006", config.BeginDate)
	//assert.Equal(tt.Format("01/02/2006"), "03/08/2016")
	assert.Equal(config.EndDate.Format("01/02/2006"), "04/14/2016")
	assert.Equal(config.Institute, "IRD")
	assert.Equal(config.Pi, "BOURLES")
	assert.Equal(config.Creator, "Jacques.Grelet_at_ird.fr")

	// display informations only for debugging
	//p(debug, config)

	opts := NewFileExtractOptions()
	// loop over instruments table
	for device, instrument := range config.Instruments {
		pf("Instrument: %s\n(%s, %s)\n", device, instrument.FileName, instrument.VarList)
		switch device {
		case "ctd":
			// test first if files exist
			assert.Equal(instrument.FileName, "test/CTD/dfr2600?.cnv")
			opts.SetVarsList(instrument.VarList)
			opts.SetSkipLine(instrument.SkipLine)
		//opts.SetHdrDelimiter(instrument.HeaderDelimiter)

		/*
			first := 0
			last := ext.Length() - 1
			pres := ext.Data()["PRES"]
			assert.Equal(2.0, pres[first]) // test the first pressure value
			assert.Equal(7.0, pres[last])  // test the last pressure value
			temp := ext.Data()["TEMP"]
			assert.Equal(24.7241, temp[first])
			assert.Equal(24.7260, temp[last])
			psal := ext.Data()["PSAL"]
			assert.Equal(35.7711, psal[first])
			assert.Equal(35.7716, psal[last])
		*/

		case "btl":
			assert.Equal(instrument.FileName, "test/CTD/fr26001.btl")
			opts.SetVarsList(instrument.VarList)
			opts.SetSkipLine(instrument.SkipLine)
			/*
				size := ext.Size() - 1
				btl := ext.Data()["BOTL"]
				assert.Equal(btl[0], 1.0)     // test the first pressure value
				assert.Equal(btl[size], 11.0) // test the last pressure value
				temp := ext.Data()["TE01"]
				assert.Equal(temp[0], 3.5048)
				assert.Equal(temp[size], 3.5048)
				psal := ext.Data()["PSA1"]
				assert.Equal(psal[0], 34.9636)
				assert.Equal(psal[size], 34.9637)
				fmt.Fprintf(debug, ext)
			*/
		case "tsg":
			assert.Equal(instrument.FileName, "test/TSG/20160308-085453-TS_COLCOR.COLCOR")
			opts.SetVarsList(instrument.VarList)
			opts.SetSkipLine(instrument.SkipLine)
			opts.SetSeparator(instrument.Separator)

		case "xbt":
			assert.Equal(instrument.FileName, "test/XBT/T7_00001.EDF")
			opts.SetVarsList(instrument.VarList)
			opts.SetSkipLine(instrument.SkipLine)
			/*
				first := 0
				last := ext.Length() - 1
				pres := ext.Data()["DEPTH"]
				assert.Equal(0.0, pres[first]) // test the first pressure value
				assert.Equal(5.8, pres[last])  // test the last pressure value
				temp := ext.Data()["TEMP"]
				assert.Equal(23.32, temp[first])
				assert.Equal(23.23, temp[last])
				svel := ext.Data()["SVEL"]
				assert.Equal(1530.25, svel[first])
				assert.Equal(1530.10, svel[last])
			*/
		}

		ext := NewFileExtractor(opts)
		switch instrument.Type {
		case "profile":
			pf := NewProfilesExtractor(instrument.FileName, *ext)
			pf.Read()
			p(pf)
		case "trajectory", "timeSerie":
			traj := NewTrajectoriesExtractor(instrument.FileName, *ext)
			traj.Read()
			p(traj)
		default:
			pf("invalid or unknom  data type -> %s\n", instrument.Type)
			p("Exiting...")
			os.Exit(0)
		}

	}
	assert.Equal(config.Kml.FileName, "pirata-fr26.kml")

}
