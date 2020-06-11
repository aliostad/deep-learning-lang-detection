/*	------------------------------------------------------------------------
	FILE NAME: ASP_SCRIPT_2
	PARAMETERS: None
	
	AVERAGE SYSTEM PRESSURE: SCRIPT_1
		Opens and balances model 
		Assigns correct profiles to all demands
		Turns off unwanted tags
      Saves"_ASP.MDB"
   
   VERSION: 1.1 - Added ASP Report [11 March 2015]
 
 	
	------------------------------------------------------------------------*/

int main()
{
   string sSettingsFile = "S:\TEST AREA\ac00418\average_system_pressures\settings\asp_settings_N1.ini";
   Settings defaultSettingsFile;
   double nScriptVersion = 1.1;

   // MODEL SETTINGS FROM INI FILE
   // ----------------------------
   // Workspace  
   string sWorkspace;
   // Warehouse   
   string sWarehouse;
   // Migrate to current version
   bool bMigrate = true;

   // AVERAGE SYSTEM PRESSURE REPORT
   // ------------------------------
   string sReportFile;
   // Path to report file save location
   string sReportPath;
   // 
   string sReportName;
   // Pre-existing Report
   string sReportASP = "Local Reports\ASP";
   Report newReport;

   // LOG SYNERGEE SCRIPT
   // -------------------
   // Text document to report to
   string sSynergeeLog, sSynergeeLog_temp;
   TextFile sSynergeeLogText;

   // Success / fail check    
   bool bOK;
   // Log write succes / fail check
   bool bLogOK;
   long n;
   long nModelCount;
   long nModelCountDefault = 1;
   string sMessage, sPressMessage;

   // Logs
   string sAnalysisLog, sGeneralLog, sValidationLog, sDataImportLog, sDataExportLog, sScriptLog; 
   string sAnalysisLog_temp, sGeneralLog_temp, sValidationLog_temp, sDataImportLog_temp, sDataExportLog_temp, sScriptLog_temp; 
   string sLogName;
   long nMessageLimit;

   // MODEL DATA
   string sModelNo;
   string sModel;
   string sModelName;
   string sLDZ, sRegion;

   string sExportFlowCategoriesFile, sExportFlowCategoriesFile_temp;
   string sExportFlowCategoriesSettings;
   string sExportFlowCategoriesWorksheet;

   string sDateFormatted;  
   DateTime dateTimeInfo;
   bOK = dateTimeInfo.SetToCurrentTime();
   sDateFormatted = dateTimeInfo.Format("%Y-%m-%d_%H-%M-%S");

   // LOAD SETTINGS FROM INI FILE
   // ===========================
   // Load settings file
   bOK = defaultSettingsFile.Setup(sSettingsFile);

   // Load Log
   sSynergeeLog_temp = defaultSettingsFile.GetText("", "LOGS", "script_log_synergee");
   sSynergeeLog = sSynergeeLog_temp + "_" + sDateFormatted + ".txt";
   sSynergeeLogText.Setup(sSynergeeLog);
   sSynergeeLogText.OpenClear();
   sMessage = "Begin script";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = "Script Version: " + nScriptVersion;
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = "Settings File: " + sSettingsFile;
   sSynergeeLogText.WriteWithDateTime(sMessage);


   sMessage = " ";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = "---------------------------------------------------------------";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = " ";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   // Load workspace
   sWorkspace = defaultSettingsFile.GetText("", "SUPPLEMENTS", "workspace");
   sMessage = "Using workspace: " + sWorkspace;
   sSynergeeLogText.WriteWithDateTime(sMessage);

   // Load warehouse
   sWarehouse = defaultSettingsFile.GetText("", "SUPPLEMENTS", "warehouse");
   sMessage = "Using warehouse " + sWarehouse;
   sSynergeeLogText.WriteWithDateTime(sMessage);


   
   sMessage = " ";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = "---------------------------------------------------------------";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = " ";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = "[MODEL DATA]";
   sSynergeeLogText.WriteWithDateTime(sMessage);



   // Load LDZ and region
   sLDZ = defaultSettingsFile.GetText("", "MODELSIN", "ldz_of_models");
   sMessage = "LDZ: " + sLDZ;
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sRegion = defaultSettingsFile.GetText("", "MODELSIN", "region_of_models");
   sMessage = "REGION: " + sRegion;
   sSynergeeLogText.WriteWithDateTime(sMessage);
   
   // Load number of models
   nModelCount = defaultSettingsFile.GetLong(nModelCountDefault, "MODELSIN", "number_of_models");
   sMessage = "Number of models: " + nModelCount;
   sSynergeeLogText.WriteWithDateTime(sMessage);


   sMessage = " ";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = "---------------------------------------------------------------";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = " ";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = "[REPORTS & OUTPUTS]";
   sSynergeeLogText.WriteWithDateTime(sMessage);

   // Load ASP report location
   sReportPath = defaultSettingsFile.GetText("","OUTPUTS","asp_report");
   sMessage = "ASP Report is of form: model_name_asp.csv";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   // Flow Categories exchange
   sExportFlowCategoriesFile_temp = defaultSettingsFile.GetText(" ","EXCHANGE", "exchangeFlowCategoriesFile");
   sExportFlowCategoriesSettings = defaultSettingsFile.GetText(" ","EXCHANGE", "exchangeFlowCategoriesSettings");
   sExportFlowCategoriesWorksheet = defaultSettingsFile.GetText(" ","EXCHANGE", "exchangeFlowCategoriesWorksheet");
   sMessage = " Export Flow Categories settings file: " + sExportFlowCategoriesSettings;
   sSynergeeLogText.WriteWithDateTime(sMessage);

   sMessage = " ";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = "---------------------------------------------------------------";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = " ";
   sSynergeeLogText.WriteWithDateTime(sMessage);

   sMessage = "Setup Complete";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = "Begin model cycle";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = " ";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = "[MODELS]";
   sSynergeeLogText.WriteWithDateTime(sMessage);

// Begin loop through models
   for (n=1; n<(nModelCount+1); n=n+1)
   {
      sMessage = " " + n + ". Load model data........................................";
      sSynergeeLogText.WriteWithDateTime(sMessage);
      sModelNo = "Model" + n;
      sModel = defaultSettingsFile.GetText("","MODELSIN",sModelNo);
      sMessage = " " + sModelNo + " : " + sModel;
      sSynergeeLogText.WriteWithDateTime(sMessage);
      sModelNo = "ModelName" + n;
      sModelName = defaultSettingsFile.GetText("","MODELNAMES",sModelNo);
      sMessage = " " + sModelNo + " : " + sModelName;
      sSynergeeLogText.WriteWithDateTime(sMessage);

      sExportFlowCategoriesFile = sExportFlowCategoriesFile_temp + sModelName + "_flow_categories.csv";
      sMessage = " Flow Categories file: " + sExportFlowCategoriesFile;
      sSynergeeLogText.WriteWithDateTime(sMessage);

      sReportName = sReportPath + sModelName;
      sReportFile = sReportName + "_asp.csv";
      sMessage = "ASP Report: " + sReportFile;

// Load the model
      bOK = Model.LoadDb(sModel, sWorkspace, sWarehouse, bMigrate);
      if (bOK)
      {
         sMessage = " ..........Model Load OK";
         sSynergeeLogText.WriteWithDateTime(sMessage);
         System.LogInfo(sMessage);
      }
      else
      {
         sMessage = " xxxxxxxxxx MODEL LOAD FAILED";
         sSynergeeLogText.WriteWithDateTime(sMessage);
         System.LogError(sMessage);
         break;
      }

      // Balance the model
      bOK = Analysis.Balance();
      if (bOK)
      {
         sMessage = " ..........Model Balance OK";
         sSynergeeLogText.WriteWithDateTime(sMessage);
         System.LogInfo(sMessage);
      }
      else
      {
         sMessage = " xxxxxxxxxx MODEL BALANCE FAILED";
         sSynergeeLogText.WriteWithDateTime(sMessage);
         System.LogError(sMessage);
         
      }


      // Export flow categories
      bOK = Model.ExportExchangeFile(sExportFlowCategoriesSettings, sExportFlowCategoriesFile, sExportFlowCategoriesWorksheet);
      if (bOK)
      {
         sMessage = " ..........Flow Categories EXPORT OK";
         sSynergeeLogText.WriteWithDateTime(sMessage);
      }
      else
      {
         sMessage = " xxxxxxxxxx Flow Categories EXPORT FAILED";
         sSynergeeLogText.WriteWithDateTime(sMessage);
         System.LogError(sMessage);
      }

      // Subsystem trace
      Subsystem.UsePhysicalBorders = true;
      bOK = Subsystem.Trace();
      if (bOK)
      {
         sMessage = "..........Subsystem Trace OK";
         sSynergeeLogText.WriteWithDateTime(sMessage);
         System.LogInfo(sMessage);
      }
      else
      {
         sMessage = "xxxxxxxxxx Subsystem Trace FAILED";
         sSynergeeLogText.WriteWithDateTime(sMessage);
         System.LogError(sMessage);
      }

       // open ASP Report

      bOK = newReport.Setup(sReportASP);
      if (bOK)
      {
         sMessage = "..........ASP Report Setup OK";
         sSynergeeLogText.WriteWithDateTime(sMessage);
         System.LogInfo(sMessage);
      }
      else
      {
         sMessage = "xxxxxxxxxx ASP Report Setup FAILED";
         sSynergeeLogText.WriteWithDateTime(sMessage);
         System.LogError(sMessage);
         
      }

      // Generate report
      bOK = newReport.Generate();
      bOK = newReport.SaveData(sReportFile);
      if (bOK)
      {
         sMessage = "..........ASP Report Save OK";
         sSynergeeLogText.WriteWithDateTime(sMessage);
         System.LogInfo(sMessage);
      }
      else
      {
         sMessage = "xxxxxxxxxx ASP Report Save FAILED";
         sSynergeeLogText.WriteWithDateTime(sMessage);
         System.LogError(sMessage);
         
      }

      sMessage = "Done: ... " + sModelName;
      sSynergeeLogText.WriteWithDateTime(sMessage);
      System.LogInfo(sMessage);

      }

         sMessage = "Finished batch";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = " ";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = " ";
   sSynergeeLogText.WriteWithDateTime(sMessage);
   sMessage = "DONE";
   sSynergeeLogText.WriteWithDateTime(sMessage);

   sSynergeeLogText.Close();


   return 0;

   }
