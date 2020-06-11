Import-Module ShareShell -Force

$ApiUrl = "https://sharepoint.uni-hamburg.de/_api/lists"

$AllowedMethods = @(
	"FirstUniqueAncestorSecurableObject", "RoleAssignments", "AllProperties", 
	"AssociatedMemberGroup", "AssociatedOwnerGroup", "AssociatedVisitorGroup", 
	"AvailableContentTypes", "AvailableFields", "ContentTypes", "CurrentUser", 
	"EventReceivers", "Features", "Fields", "Folders", "Lists", "ListTemplates", 
	"Navigation", "ParentWeb", "PushNotificationSubscribers", "RecycleBin", 
	"RegionalSettings", "RoleDefinitions", "RootFolder", "SiteGroups", 
	"SiteUserInfoList", "SiteUsers", "ThemeInfo", "UserCustomActions", 
	"Webs", "WebInfos", "WorkflowAssociations", "WorkflowTemplates"
)

Describe "/_api/lists" { 
	
	Context "general" {
		It "loads without errors" {
			{ Invoke-XmlApiRequest -Uri $ApiUrl } | Should Not Throw
		}
		
		It "has elements" {
			{ Invoke-XmlApiRequest -Uri $ApiUrl } | Should Not BeNullOrEmpty
		}
		
		It "contains lists" {
			Invoke-XmlApiRequest -Uri $ApiUrl | Select-Object -First 1 -ExpandProperty "__Category"  | Should Be "SP.List"
		}
	}	
} 