//AnalyzeTypeSeabird.go
//Analyze the type of instrument of the data files
package analyze

import (
	"bufio"
	"log"
	"os"
	"regexp"
	"github.com/SNguyen29/Oceano2oceansitesTest/toml"
)

// read all cnv files and return dimensions
func AnalyzeType(cfg toml.Configtoml,files []string) string {

	var result = "error in analyse type"
	
	// open first file
	fid, err := os.Open(files[0])
	if err != nil {
		log.Fatal(err)
	}
	defer fid.Close()

	scanner := bufio.NewScanner(fid)
	for scanner.Scan() {
		str := scanner.Text()
		
		for i:=0;i<len(cfg.Instrument.Decodetype);i++{
				temp := regexp.MustCompile(cfg.Instrument.Decodetype[i])
				if temp.MatchString(str){
						result = cfg.Instrument.Type[i]
					}
			
			}
	}
	
	return result
}
