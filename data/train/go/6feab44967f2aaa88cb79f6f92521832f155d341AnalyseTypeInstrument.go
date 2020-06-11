//AnalyzeTypeInstrument.go
//Analyze the type of instrument in general case
package analyze

import (
	"strings"
	"toml"
)

// define constante for Type

func AnalyzeTypeInstrument(cfg toml.Configtoml,inst string) string{
	
	var Vprofil bool = false
	var VTimes bool = false
	var Vtraj bool = false
	var result string
	
	for i:=0;i<len(cfg.Instrument.Tabprofil);i++{
			if strings.EqualFold(inst,cfg.Instrument.Tabprofil[i]){
				Vprofil = true
			}
				
		}
	for i:=0;i<len(cfg.Instrument.Tabtimeserie);i++{
			if strings.EqualFold(inst,cfg.Instrument.Tabtimeserie[i]){
				VTimes = true
			}
				
		}
	for i:=0;i<len(cfg.Instrument.Tabtrajectoire);i++{
			if strings.EqualFold(inst,cfg.Instrument.Tabtrajectoire[i]){
				Vtraj = true
			}
				
		}
		
	switch{
		case Vprofil : result = cfg.Profil
		case VTimes : result = cfg.Timeserie
		case Vtraj : result = cfg.Trajectoire
	}
	
	return result
}
