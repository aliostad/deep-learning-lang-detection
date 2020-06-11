require 'windows/api'
include Windows

module Windows
   module COM
      API.auto_namespace = 'Windows::COM'
      API.auto_constant  = true
      API.auto_method    = true
      API.auto_unicode   = false

      API.new('BindMoniker', 'PLPP', 'L', 'ole32')
      API.new('CLSIDFromProgID', 'PP', 'L', 'ole32')
      API.new('CLSIDFromProgIDEx', 'PP', 'L', 'ole32')
      API.new('CLSIDFromString', 'PP', 'L', 'ole32')
      API.new('CoAddRefServerProcess', 'V', 'L', 'ole32')
      API.new('CoAllowSetForegroundWindow', 'PP', 'L', 'ole32')
      API.new('CoCancelCall', 'LL', 'L', 'ole32')
      API.new('CoCopyProxy', 'PP', 'L', 'ole32')
      API.new('CoCreateFreeThreadedMarshaler', 'PP', 'L', 'ole32')
      API.new('CoCreateGuid', 'P', 'L', 'ole32')
      API.new('CoCreateInstance', 'PPLPP', 'L', 'ole32')
      API.new('CoCreateInstanceEx', 'PPLPLP', 'L', 'ole32')
      API.new('CoDisableCallCancellation', 'L', 'L', 'ole32')
      API.new('CoDisconnectObject', 'PL', 'L', 'ole32')
      #API.new('CoDosDateTimeToFileTime', 'LLP', 'L')
      API.new('CoEnableCallCancellation', 'L', 'L', 'ole32')
      API.new('CoFileTimeNow', 'P', 'L', 'ole32')
      API.new('CoFileTimeToDosDateTime', 'LLL', 'B', 'ole32')
      API.new('CoFreeAllLibraries', 'V', 'V', 'ole32')
      API.new('CoFreeLibrary', 'L', 'V', 'ole32')
      API.new('CoFreeUnusedLibraries', 'V', 'V', 'ole32')
      API.new('CoFreeUnusedLibrariesEx', 'V', 'V', 'ole32')
      API.new('CoGetCallContext', 'PP', 'L', 'ole32')
      API.new('CoGetCallerTID', 'P', 'L', 'ole32')
      API.new('CoGetCancelObject', 'LPP', 'L', 'ole32')
      API.new('CoGetClassObject', 'PLPPP', 'L', 'ole32')
      API.new('CoGetContextToken', 'P', 'L', 'ole32')
      API.new('CoGetCurrentLogicalThreadId', 'P', 'L', 'ole32')
      API.new('CoGetCurrentProcess', 'V', 'L', 'ole32')
      API.new('CoGetInstanceFromFile', 'PPPLLPLP', 'L', 'ole32')
      API.new('CoGetInstanceFromIStorage', 'PPPLPLP', 'L', 'ole32')
      API.new('CoInitialize', 'P', 'L', 'ole32')
      API.new('CoTaskMemFree', 'P', 'V', 'ole32')
      API.new('CoUninitialize', 'V', 'V', 'ole32')
		API.new('StringFromGUID2', 'PPI', 'I', 'ole32')

      # Windows Vista
      begin
         API.new('CoDisconnectContext', 'L', 'L', 'ole32')
      rescue RuntimeError
         # Ignore - you must check for these methods via 'defined?'
      end
   end
end
