//ReadSeabird.go
//Function for read data file for constructor Seabird

package seabird

import (
	"github.com/SNguyen29/Oceano2oceansitesTest/lib"
	"github.com/SNguyen29/Oceano2oceansitesTest/config"
	"github.com/SNguyen29/Oceano2oceansitesTest/analyze"
	"github.com/SNguyen29/Oceano2oceansitesTest/toml"
	"github.com/SNguyen29/Oceano2oceansitesTest/netcdf"
	)


// read cnv files in two pass, the first to get dimensions
// second to get data
func ReadSeabird(nc *lib.Nc, m *config.Map,filestruct analyze.Structfile,cfg toml.Configtoml,files []string,optCfgfile string,optAll *bool,optDebug *bool,prefixAll string) {
	
	switch{
		case filestruct.Instrument == cfg.Instrument.Type[0] :
		
			config.GetConfigCTD(nc,m,cfg,optCfgfile,filestruct.TypeInstrument,optAll)
			
			// first pass, return dimensions fron cnv files
			nc.Dimensions["TIME"], nc.Dimensions["DEPTH"] = firstPassCTD(nc,m,cfg,files)
		
			// initialize 2D data
			nc.Variables_2D = make(lib.AllData_2D)
			for i, _ := range m.Map_var {
				nc.Variables_2D.NewData_2D(i, nc.Dimensions["TIME"], nc.Dimensions["DEPTH"])
			}
		
			// second pass, read files again, extract data and fill slices
			secondPassCTD(nc,m,cfg,files,optDebug)
			// write ASCII file
			WriteAscii(nc,cfg,m.Map_format, m.Hdr,filestruct.Instrument,prefixAll)
		
			// write netcdf file
			//if err := nc.WriteNetcdf(); err != nil {
			//log.Fatal(err)
			//}
			netcdf.WriteNetcdf(nc,m,cfg,filestruct.Instrument,prefixAll)
			
		case filestruct.Instrument == cfg.Instrument.Type[1] :
		
			config.GetConfigBTL(nc,m,cfg,optCfgfile,filestruct.TypeInstrument)
			// first pass, return dimensions fron btl files
			nc.Dimensions["TIME"], nc.Dimensions["DEPTH"] = firstPassBTL(nc,m,cfg,files)
		
			// initialize 2D data
			nc.Variables_2D = make(lib.AllData_2D)
			for i, _ := range m.Map_var {
				nc.Variables_2D.NewData_2D(i, nc.Dimensions["TIME"], nc.Dimensions["DEPTH"])
			}
		
			// second pass, read files again, extract data and fill slices
			secondPassBTL(nc,m,cfg,files,optDebug)
			// write ASCII file
			WriteAscii(nc,cfg,m.Map_format, m.Hdr,filestruct.Instrument,prefixAll)
		
			// write netcdf file
			//if err := nc.WriteNetcdf(); err != nil {
			//log.Fatal(err)
			//}
			netcdf.WriteNetcdf(nc,m,cfg,filestruct.Instrument,prefixAll)
			}
}