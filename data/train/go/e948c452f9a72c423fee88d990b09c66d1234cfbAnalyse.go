//Analyse.go
//global analyse of the file

package analyze

import "toml"

type Structfile struct{
	Constructeur 	Constructor
	Instrument		string
	TypeInstrument	string	
}

//global function for analyse constructor, instrument and instrument type
func AnalyzeFile(cfg toml.Configtoml,files []string) Structfile{
	
	var result Structfile
	
	result.Constructeur = AnalyzeConstructor(cfg,files)
	
	result.Instrument = AnalyzeTypeSeabird(cfg,files)
	
	result.TypeInstrument = AnalyzeTypeInstrument(cfg,result.Instrument)
	
	return result
}