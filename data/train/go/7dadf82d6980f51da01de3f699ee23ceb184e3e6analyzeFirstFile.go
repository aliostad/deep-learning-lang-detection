// analyzeFirstFile
package main

import (
	"bufio"
	//	"fmt"
	"log"
	"os"
	"regexp"
)

type instrumentType int

// define an integer constant for instrument type
const (
	CTD instrumentType = 3
	BTL                = 5
)

//	XBT
//	TSG
//	MTO
//	LADCP
//	SADCP
//)

var typeInstrument instrumentType

// define bitmask for instrument
const (
	isSBE instrumentType = 1 << iota
	isCTD
	isBTL
)

// define regexp
var regIsSeabird = regexp.MustCompile(`^\*\s+(Sea-Bird)`)
var regIsCnv = regexp.MustCompile(`(\*END\*)`)
var regIsBtottle = regexp.MustCompile(`^\s+(Bottle)`)

// AnalyseFirstFile read all cnv files and return dimensions
func analyseFirstFile(files []string) instrumentType {

	// initialize bitmask
	var result instrumentType

	// open first file
	fid, err := os.Open(files[0])
	if err != nil {
		log.Fatal(err)
	}
	defer fid.Close()

	scanner := bufio.NewScanner(fid)
	for scanner.Scan() {
		str := scanner.Text()

		match := regIsSeabird.MatchString(str)
		if match {
			//res := regIsSeabird.FindStringSubmatch(str)
			//value := res[1]
			result = result | isSBE
			//fmt.Fprintln(debug, value, result)
		}
		match = regIsCnv.MatchString(str)
		if match {
			//res := regIsCnv.FindStringSubmatch(str)
			//value := res[1]
			result = result | isCTD
			//fmt.Fprintln(debug, value, result)
		}
		match = regIsBtottle.MatchString(str)
		if match {
			//res := regIsBtottle.FindStringSubmatch(str)
			//value := res[1]
			result = result | isBTL
			//fmt.Fprintln(debug, value, result)
		}
	}
	//fmt.Fprintln(debug, result)
	return result
}
