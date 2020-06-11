@{
	ModuleToProcess   = 'AtlassianCLI.psm1'
	ModuleVersion     = '1.2.2'
	GUID              = '5fef9356-84ff-4c09-81e7-48b9abb8b7fc'
	Author            = 'Tomas Deceuninck'
	Copyright         = '(c) 2014-17 Tomas Deceuninck. All rights reserved.'
	Description       = 'AtlassianCLI provides a PowerShell interface to several Atlassian web applications using their respective REST API''s'
	PowerShellVersion = '3.0'

	FunctionsToExport = '*'
	CmdletsToExport   = '*'
	VariablesToExport = '*'
	AliasesToExport   = '*'

	PrivateData       = @{
		PSData = @{
			Tags       = @('AtlassianCLI', 'Atlassian', 'REST', 'API', 'JIRA')
			LicenseUri = 'https://github.com/Invoke-Automation/AtlassianCLI/blob/master/LICENSE.txt'
			ProjectUri = 'https://github.com/Invoke-Automation/AtlassianCLI'
			#IconUri = ''
			#ReleaseNotes = ''
		}
	}
}