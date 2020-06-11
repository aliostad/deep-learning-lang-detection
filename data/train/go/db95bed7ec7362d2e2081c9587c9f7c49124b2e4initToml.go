//inittoml.go
//Initialise the struct with config file

package toml

import (
	"fmt"
	"github.com/BurntSushi/toml"
)

type Configtoml struct{
	Progname	string
	Progversion	string
	Roscopfile 	string
	Outputfile	string
	
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
		Constructor		[]string
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
	
	Ladcp struct{
		CruisePrefix		string
		StationPrefixLength int
		TypeInstrument 		string
		InstrumentNumber  	string
		TitleSummary  		string
		Comment        		string
		Split				[]string
	}
	
	Xbt struct{
		CruisePrefix   		string 
		AcquisitionSoftware string
		AcquisitionVersion 	string 
		TypeInstrument    	string
		InstrumentNumber   	string
		TitleSummary   		string
		Comment        		string
		Split 				[]string
	}
	
	Thermo struct{
		CruisePrefix		string
		AcquisitionSoftware string
		TypeInstrument      string
		InstrumentNumber    string
		CalDate        		string 
		ExternalType   		string
		ExternalSn     		string
		ExternalCalDate 	string
		DepthIntake    		string
		TitleSummary   		string
		Comment        		string
		Split				[]string
	}
		
	Seabird struct{
		Prefix				string
		Header				string
		HeaderBTL			string
		HeaderBTL2			string
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
		
	Ifm struct{
		Header				string
		Date 				string
		StartTime 			string
		Latitude 			string
		Longitude 			string
		}
	
	Thecsas struct{
		Data				string
		}
		
	Mk21 struct{
		Header				string
		Date 				string
		Time 				string
		Latitude 			string
		Longitude 			string
		}
}
	
//init the struct configtoml with the config file
func  InitToml(file string) (Configtoml){
	
	var cfg Configtoml
	
	if _, err := toml.DecodeFile(file, &cfg); err != nil {
		fmt.Println(err)
		return cfg
	}
	return cfg
}