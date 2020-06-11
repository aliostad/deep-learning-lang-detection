. $PSScriptRoot"\Test_Functions.ps1"
. $PSScriptRoot"\..\Core\jira_functions.ps1"

Describe "jira_functions" {
  Context "Add-JiraUrlPostfix-To-Config-Url" {
    It "Add-JiraUrlPostfix-To-Config-Url_WithoutSlashAtEnd" {
      Add-JiraUrlPostfix-To-Config-Url "http://testJiraUrl.com/jira" | Should Be "http://testJiraUrl.com/jira/rest/api/2/"
    }

    It "Add-JiraUrlPostfix-To-Config-Url_WithSlashAtEnd" {
      Add-JiraUrlPostfix-To-Config-Url "http://testJiraUrl.com/jira/" | Should Be "http://testJiraUrl.com/jira/rest/api/2/"
    }
  }
}