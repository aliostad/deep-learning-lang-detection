//ReadSeabird.go
//Function for read data file for constructor Seabird

package main

import "lib"
import "config"


// read cnv files in two pass, the first to get dimensions
// second to get data
func ReadSeabird(nc *lib.Nc, m *config.Map,files []string,optCfgfile string) {
	
	switch{
		case filestruct.Instrument == cfg.Instrument.Type[0] :
		
			config.GetConfigCTD(nc,m,cfg,optCfgfile,filestruct.TypeInstrument,optAll)
			
			// first pass, return dimensions fron cnv files
			nc.Dimensions["TIME"], nc.Dimensions["DEPTH"] = firstPassCTD(nc,files)
		
			// initialize 2D data
			nc.Variables_2D = make(lib.AllData_2D)
			for i, _ := range m.Map_var {
				nc.Variables_2D.NewData_2D(i, nc.Dimensions["TIME"], nc.Dimensions["DEPTH"])
			}
		
			// second pass, read files again, extract data and fill slices
			secondPassCTD(nc,files)
			// write ASCII file
			WriteAsciiCTD(nc,m.Map_format, m.Hdr,filestruct.Instrument)
		
			// write netcdf file
			//if err := nc.WriteNetcdf(); err != nil {
			//log.Fatal(err)
			//}
			WriteNetcdf(nc,m,filestruct.Instrument)
			
		case filestruct.Instrument == cfg.Instrument.Type[1] :
		
			config.GetConfigBTL(nc,m,cfg,optCfgfile,filestruct.TypeInstrument)
			// first pass, return dimensions fron btl files
			nc.Dimensions["TIME"], nc.Dimensions["DEPTH"] = firstPassBTL(nc,m,files)
		
			//	// initialize 2D data
			//	nc.Variables_2D = make(AllData_2D)
			//	for i, _ := range map_var {
			//		nc.Variables_2D.NewData_2D(i, nc.Dimensions["TIME"], nc.Dimensions["DEPTH"])
			//	}
		
			// second pass, read files again, extract data and fill slices
			secondPassBTL(nc,m,files)
			// write ASCII file
			WriteAsciiBTL2(nc,m.Map_format, m.Hdr,filestruct.Instrument)
		
			// write netcdf file
			//if err := nc.WriteNetcdf(); err != nil {
			//log.Fatal(err)
			//}
			WriteNetcdf(nc,m,filestruct.Instrument)
			}
}