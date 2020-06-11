package header

import (
    "github.com/caa-dev-apps/cefmdd_v1/pkg/diag"
)

///////////////////////////////////////////////////////////////////////////////
//

//-     mks := []string {
//-         "MISSION_KEY_PERSONNEL",
//-         "EXPERIMENT_KEY_PERSONNEL",
//-         "INSTRUMENT_NAME",
//-         "INSTRUMENT_DESCRIPTION",
//-         "DATASET_CAVEATS",
//-         "METADATA_TYPE",
//-             "LOGICAL_FILE_ID",
//-         "EXPERIMENT_DESCRIPTION",
//-         "DATASET_ID",
//-         "MIN_TIME_RESOLUTION",
//-         "PROCESSING_LEVEL",
//-         "DATASET_VERSION",
//-             "FILE_TYPE",
//-         "FILE_CAVEATS",
//-         "TIME_RESOLUTION",
//-         "DATASET_DESCRIPTION",
//-         "MISSION_REFERENCES",
//-         "MISSION_CAVEATS",
//-         "EXPERIMENT",
//-         "OBSERVATORY_DESCRIPTION",
//-         "MEASUREMENT_TYPE",
//-         "ACKNOWLEDGEMENT",
//-         "METADATA_VERSION",
//-             "FILE_TIME_SPAN",
//-         "OBSERVATORY_CAVEATS",
//-         "OBSERVATORY_REGION",
//-         "INSTRUMENT_CAVEATS",
//-         "DATASET_TITLE",
//-         "INVESTIGATOR_COORDINATES",
//-         "EXPERIMENT_CAVEATS",
//-         "MISSION_TIME_SPAN",
//-         "MISSION_AGENCY",
//-         "MISSION_REGION",
//-         "EXPERIMENT_REFERENCES",
//-         "INSTRUMENT_TYPE",
//-             "DATA_TYPE",
//-         "MAX_TIME_RESOLUTION",
//-         "MISSION",
//-         "GENERATION_DATE",
//-         "MISSION_DESCRIPTION",
//-             "OBSERVATORY",
//-         "OBSERVATORY_TIME_SPAN",
//-         "CONTACT_COORDINATES",
//-             "VERSION_NUMBER",
//-     }

///////////////////////////////////////////////////////////////////////////////
//
        
func (h *CefHeaderData) print_results(about string, err error) {

    if err != nil {
        diag.Error(about, err)   
    } else {
        diag.Trace(diag.BoldGreen(" ok:"), about)  
    }
}        
        
func (h *CefHeaderData) Checks() (err error) {
    
    diag.Trace(diag.BoldCyan("Start"), "Header ATTR Checks:")
    if h.Attr_Checks() != nil {
        diag.Error("Header ATTR Checks:", "error(s) ")
    } else {
        h.print_results("Header ATTR Checks:", nil)
    }

    diag.Trace(diag.BoldCyan("Start"), "Header META Checks:")
    if h.Meta_Checks() != nil {
        diag.Error("Header META Checks:", "error(s) ")
    } else {
        h.print_results("Header META Checks:", nil)
    }

    diag.Trace(diag.BoldCyan("Start"), "Header VAR Checks:")
    if h.Var_Checks() != nil {
        diag.Error("Header VAR Checks:", "error(s) ")
    } else {
        h.print_results("Header VAR Checks:", nil)
    }
    
    return
}

