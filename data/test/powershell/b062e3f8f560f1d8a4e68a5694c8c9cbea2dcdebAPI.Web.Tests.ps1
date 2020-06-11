Import-Module ShareShell -Force

$TestWebApiUrl = "https://sharepoint.uni-hamburg.de/_api/web"

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

Describe "/_api/web" {
    Context "properties" {
       
        It "loads without errors" {
			{ Invoke-XmlApiRequest -Uri $TestWebApiUrl } | Should Not Throw
		}
		
		It "has a 'title' property" {
			$Web = Invoke-XmlApiRequest -Uri $TestWebApiUrl 
			$Web.Title | Should Not BeNullOrEmpty
		}
			
		It "has a '__Category' property" {
			$Web = Invoke-XmlApiRequest -Uri $TestWebApiUrl 
			$Web.__Category | Should Not BeNullOrEmpty
		}
		
		It "'__Category' is 'SP.Web'" {
			$Web = Invoke-XmlApiRequest -Uri $TestWebApiUrl 
			$Web.__Category | Should Be "SP.Web"
		}
		
		It "has a '__Uri' property" {
			$Web = Invoke-XmlApiRequest -Uri $TestWebApiUrl 
			$Web.__Uri | Should Not BeNullOrEmpty
		}
		
		It "'__Uri' is '$TestWebApiUrl'" {
			$Web = Invoke-XmlApiRequest -Uri $TestWebApiUrl 
			$Web.__Uri | Should Be $TestWebApiUrl
		}


	}
	
	Context "methods" {
		It "has a '__ApiMethods' property" {
			$Web = Invoke-XmlApiRequest -Uri $TestWebApiUrl 
			$Web.__ApiMethods | Should Not BeNullOrEmpty
		}

		It "has all defined api methods" {
			$Web = Invoke-XmlApiRequest -Uri $TestWebApiUrl 
			$AllowedMethods | Where-Object { $Web.__ApiMethods -notcontains $_ } | Should BeNullOrEmpty 
		}

		
		It "has only defined api methods" {
			$Web = Invoke-XmlApiRequest -Uri $TestWebApiUrl 
			$Web.__ApiMethods | Where-Object { $AllowedMethods -notcontains $_ } | Should BeNullOrEmpty 
		}
		
		It "has a 'SiteGroups()' function" {
			$Web = Invoke-XmlApiRequest -Uri $TestWebApiUrl 
			$Web.SiteGroups -is [Management.Automation.PSScriptMethod] | Should Be True
		}
		
		It "has a 'RoleAssignments()' function" {
			$Web = Invoke-XmlApiRequest -Uri $TestWebApiUrl 
			$Web.RoleAssignments -is [Management.Automation.PSScriptMethod] | Should Be True
		}
		
		It "has a 'RoleDefinitions()' function" {
			$Web = Invoke-XmlApiRequest -Uri $TestWebApiUrl 
			$Web.RoleDefinitions -is [Management.Automation.PSScriptMethod] | Should Be True
		}
		
		It "has a 'SiteUsers()' function" {
			$Web = Invoke-XmlApiRequest -Uri $TestWebApiUrl 
			$Web.SiteUsers -is [Management.Automation.PSScriptMethod] | Should Be True
		}
		
		It "has a 'UserCustomActions()' function" {
			$Web = Invoke-XmlApiRequest -Uri $TestWebApiUrl 
			$Web.UserCustomActions -is [Management.Automation.PSScriptMethod] | Should Be True
		}
	}
	
}