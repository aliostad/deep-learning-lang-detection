//AnalyzeConstructor.go
//Analyze the constructor of the data files
package analyze

import (
	"bufio"
	"log"
	"os"
	"regexp"
	"github.com/SNguyen29/Oceano2oceansitesTest/toml"
)

// define constante for constructor type
type Constructor struct{
		Name	string
		Number	int
	}



// read all cnv files and return dimensions
func AnalyzeConstructor(cfg toml.Configtoml,files []string) Constructor {
	
	regseabirdcnv := regexp.MustCompile(cfg.Instrument.Decodetype[0])
	regseabirdbtl := regexp.MustCompile(cfg.Instrument.Decodetype[1])
	regifm := regexp.MustCompile(cfg.Instrument.Decodetype[2])
	regseabirdthermo := regexp.MustCompile(cfg.Instrument.Decodetype[3])
	regmk21xbt := regexp.MustCompile(cfg.Instrument.Decodetype[4])

	var result Constructor
	// open first file
	fid, err := os.Open(files[0])
	if err != nil {
		log.Fatal(err)
	}
	defer fid.Close()

	scanner := bufio.NewScanner(fid)
	for scanner.Scan() {
		str := scanner.Text()
		
		switch {
		case regseabirdcnv.MatchString(str) || regseabirdbtl.MatchString(str): 
			result.Name = cfg.Instrument.Constructor[0]
			result.Number = 0
			
		case regifm.MatchString(str) : 
			result.Name = cfg.Instrument.Constructor[1]
			result.Number = 1
			
		case regseabirdthermo.MatchString(str) : 
			result.Name = cfg.Instrument.Constructor[2]
			result.Number = 2
		
		case regmk21xbt.MatchString(str) : 
			result.Name = cfg.Instrument.Constructor[3]
			result.Number = 3
		}
	}
	return result
}

