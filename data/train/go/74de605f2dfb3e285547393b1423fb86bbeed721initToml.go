//inittoml.go
//Initialise the struct with config file

package toml

import (
	"fmt"
	"github.com/BurntSushi/toml"
)

var fileconfig = "configfile/configtoml.toml"

type Configtoml struct{
	Progname	string
	Progversion	string
	Roscopfile 	string
	
	Profil		string
	Timeserie	string
	Trajectoire	string
	
	Global struct{
		Author 	string
		Debug 	int
		Echo 	int
	}
	
	Cruise struct{
		CycleMesure string
		Plateforme 	string
		Callsign  	string
		Institute 	string
		Pi          string
		Timezone    string
		BeginDate   string
		EndDate     string
		Creator     string
	}
	
	Instrument struct{
		Seabird			string
		Tabprofil		[]string
		Tabtimeserie	[]string
		Tabtrajectoire	[]string
		Type			[]string
		Decodetype		[]string
	}
	
	Ctd struct{
		CruisePrefix   			string
		StationPrefixLength  	int
		TitleSummary  			string
		TypeInstrument   		string
		InstrumentNumber  		string
		Split          			[]string
		SplitAll       			[]string
	}

	Btl struct{
		TypeInstrument 		string
		InstrumentNumber  	string
		TitleSummary  		string
		Comment        		string
		Split 				[]string
	}
		
	Seabird struct{
		Prefix				string
		Header				string
		Cruise 				string
		Ship 				string
		Station 			string
		Type 				string
		Operator			string
		BottomDepth 		string
		DummyBottomDepth	string
		Date 				string
		Hour 				string
		SystemTime 			string
		Latitude 			string
		Longitude 			string
		}
}
	
//init the struct configtoml with the config file
func  InitToml() (string,Configtoml){
	
	var cfg Configtoml
	
	if _, err := toml.DecodeFile(fileconfig, &cfg); err != nil {
		fmt.Println(err)
		return fileconfig,cfg
	}
	return fileconfig,cfg
}