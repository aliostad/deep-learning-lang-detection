undefine newuser

create synonym &&newUser..CTSP_ALL_FILE        for OC_DATA.CTSP_ALL_FILE_VW;
create synonym &&newUser..CT_DATA_LAST_EXT     for OC_DATA.CT_DATA_LAST_EXT_VW;
create synonym &&newUser..CDUS_DATA            for OC_DATA.CDUS_DATA;
create synonym &&newUser..CT_DATA              for OC_DATA.CT_DATA;              
--
create synonym &&newUser..CT_DATA_VW_CTL       for CTEXT_CTL.CT_DATA_VW_CTL;
--
create synonym &&newUser..CT_APP_META_DATA     for CTEXT.CT_APP_META_DATA;
create synonym &&newUser..CT_DATA_MAP_CTL      for CTEXT.CT_DATA_MAP_CTL;
create synonym &&newUser..CT_EXT_ACCOUNTS      for CTEXT.CT_EXT_ACCOUNTS;
create synonym &&newUser..CT_EXT_CRS_CTL       for CTEXT.CT_EXT_CRS_CTL;
create synonym &&newUser..CT_EXT_DATA          for CTEXT.CT_EXT_DATA;
create synonym &&newUser..CT_EXT_ERRORS        for CTEXT.CT_EXT_ERRORS;
create synonym &&newUser..CT_EXT_FILE_CTL      for CTEXT.CT_EXT_FILE_CTL;
create synonym &&newUser..CT_EXT_LOGS          for CTEXT.CT_EXT_LOGS;
create synonym &&newUser..CT_EXT_OC_OBJ_CTL    for CTEXT.CT_EXT_OC_OBJ_CTL;
create synonym &&newUser..CT_EXT_STUDY_CTL     for CTEXT.CT_EXT_STUDY_CTL;
create synonym &&newUser..CT_EXT_STUDY_RPT_CTL for CTEXT.CT_EXT_STUDY_RPT_CTL;
--create synonym newUser..CT_EXT_SUBVAR_CTL    for CTEXT.CT_EXT_SUBVAR_CTL;
create synonym &&newUser..CT_EXT_TEMP          for CTEXT.CT_EXT_TEMP;
create synonym &&newUser..CT_EXT_VW_CTL        for CTEXT.CT_EXT_VW_CTL;
create synonym &&newUser..CT_REC_TYPE          for CTEXT.CT_REC_TYPE;
--
create synonym &&newUser..NCI_LABTEST_MAPPING  for OPS$BDL.NCI_LABTEST_MAPPING;