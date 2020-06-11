namespace Lacjam.Integration

open System
open System.ServiceModel
open System.Linq
open System.Runtime.Serialization.Json
open System.Diagnostics
open Newtonsoft.Json
open log4net
open Lacjam
open Lacjam.Core
open Lacjam.Core.Runtime
open Lacjam.Core.User
open Lacjam.Core.Domain
open Lacjam.Core.Scheduling

module Jira  =
    open System
    open System.ServiceModel
    open System.Linq
    open System.Runtime.Serialization.Json
    open System.Diagnostics
    open Newtonsoft.Json
    open log4net
    open Autofac
    open Lacjam
    open Lacjam.Core
    open Lacjam.Core.Runtime
    open Lacjam.Core.User
    open Lacjam.Core.Domain
    open Lacjam.Core.Scheduling


//    type Project = {key:string}
//    type Fields = {fields : System.Collections.Generic.Dictionary<string, System.Object>}
//    type TimeTracking = { originalEstimate : System.Decimal}
//    type IssueTypeSection = {name: System.String}
//
//    
//    let getRestRequest url =  
//        let rc = new RestSharp.RestClient(url)
//        let request = new RestSharp.RestRequest(Method = RestSharp.Method.GET)
//        //request.AddHeader("Content-Type", "application/json")
//        //request.AddHeader("Authorization", "Basic " + Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(String.Format("{0}:{1}", "CHALLENGERAU\saSYDAAppDevBuilder", User.WindowsAccount.getPassword())))) |> ignore
//        request
//
//    let getRestResponse url =  
//        let rc = new RestSharp.RestClient(url)
//        let request = new RestSharp.RestRequest(Method = RestSharp.Method.GET)
//        //request.AddHeader("Content-Type", "application/json")
//        //request.AddHeader("Authorization", "Basic " + Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(String.Format("{0}:{1}", "CHALLENGERAU\saSYDAAppDevBuilder", User.WindowsAccount.getPassword())))) |> ignore
//        let result = rc.Execute(request)
//        result
//
//    let createIssue() = 
//        try
//      
//           let request = getRestRequest "https://atlassian.au.challenger.net/jira/rest/api/2/issue/"
//           let issueData = new System.Collections.Generic.Dictionary<string, System.Object>()
//       
//           let p = {key="DPMITPROJ"}
//           issueData.Add("project",p)
//           issueData.Add("summary", "Phoenix penetration test fixes")
//           issueData.Add("duedate", System.DateTime.Now.AddMonths(1))        
//           issueData.Add("customfield_10360", System.DateTime.Now)
//           let it = {name="Epic"}
//           issueData.Add("issuetype", it)
//          // let json = IO.File.ReadAllText(@"c:\temp\rest.txt")
//           request.RequestFormat <- RestSharp.DataFormat.Json
//           request.UseDefaultCredentials <- true
//           let mt = {fields = issueData}      
//           request.AddBody(mt) |> ignore
//       
//           let rc = new RestSharp.RestClient "https://atlassian.au.challenger.net/jira/rest/api/2/issue/"
//           let result = rc.Execute(request)
//           //let issue = restClient.CreateIssue("DPMITPROJ","5", "ddd")
//           Console.WriteLine(result)
//        with
//        | exn -> printfn "An exception occurred: %s" exn.Message
//        
//    [<Literal>]
//    let temp = @"c:\temp\roadmap-jira-output.txt"    
//
//    [<Literal>]
//    let remote = @"\\sharepoint\DavWWWRoot\teamsites\bs\it\DPM IT Documents\Roadmap\roadmap-jira-output.txt"
//
//    [<Literal>]
//    let remote2 = @"\\sharepoint\DavWWWRoot\teamsites\bs\it\DPM IT Documents\Roadmap\roadmap-jira-output2.txt"
//
//    [<Literal>]
//    let outputSchema = """ 
//            {"expand":"schema,names","startAt":0,"maxResults":3,"total":34,"issues":[{"expand":"editmeta,renderedFields,transitions,changelog,operations","id":"18094","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/18094","key":"DPMITPROJ-48","fields":{"summary":"FUM/Flow Charting","environment":"UAT1","customfield_10360":"sss","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10016","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_open.gif","name":"Backlog","id":"10016"},"customfield_11075":8.5,"duedate":"20ddd","issuelinks":[]}},{"expand":"editmeta,renderedFields,transitions,changelog,operations","id":"18093","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/18093","key":"DPMITPROJ-47","fields":{"summary":"Quotes in Salesforce","environment":null,"customfield_10360":"20cfgh23","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10016","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_open.gif","name":"Backlog","id":"10016"},"customfield_11075":11.0,"duedate":"201asdfsadf-23","issuelinks":[]}},{"expand":"editmeta,renderedFields,transitions,changelog,operations","id":"18092","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/18092","key":"DPMITPROJ-46","fields":{"summary":"Salesforce SSO","environment":null,"customfield_10360":"2sdf1","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10016","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_open.gif","name":"Backlog","id":"10016"},"customfield_11075":7.0,"duedate":"s","issuelinks":[]}}]} """
//
//    type OutputRoadmapJsonSchema = FSharp.Data.JsonProvider< outputSchema >
//
//    [<Literal>]
//    let linkedIssueSchema = """ {"expand":"renderedFields,names,schema,transitions,operations,editmeta,changelog","id":"17349","self":"https://atlassian.au.challenger.net/jira/rest/api/latest/issue/17349","key":"DPMITCRM-15","fields":{"progress":{"progress":0,"total":0},"summary":"Technical services","customfield_10560":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/customFieldOption/10340","value":"Yes","id":"10340"},"customfield_11067":null,"timetracking":{},"customfield_11066":null,"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/6","id":"6","description":"A user story","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/sales.gif","name":"User Story","subtask":false},"customfield_10562":null,"customfield_11069":null,"customfield_11068":null,"customfield_11160":"4281","customfield_11161":null,"customfield_11660":null,"timespent":null,"reporter":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/user?username=lkaligotla","name":"lkaligotla","emailAddress":"lkaligotla@challenger.com.au","avatarUrls":{"16x16":"https://atlassian.au.challenger.net/jira/secure/useravatar?size=small&avatarId=10102","48x48":"https://atlassian.au.challenger.net/jira/secure/useravatar?avatarId=10102"},"displayName":"Lakshmi Kaligotla","active":true},"created":"2013-08-22T14:16:43.663+1000","updated":"2013-10-22T10:11:23.673+1100","customfield_10041":null,"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"description":"Technical Services \r\n- Case management\r\n- Presentation request workflow","customfield_10002":null,"customfield_10003":null,"customfield_10040":null,"issuelinks":[{"id":"12767","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLink/12767","type":{"id":"10010","name":"CrossProjectLink","inward":"part of","outward":"contains","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLinkType/10010"},"outwardIssue":{"id":"17350","key":"DPMITCRM-1","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/17350","fields":{"summary":"Case Management Queue","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10014","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_closed.gif","name":"DONE","id":"10014"},"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/6","id":"6","description":"A user story","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/sales.gif","name":"User Story","subtask":false}}}},{"id":"12768","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLink/12768","type":{"id":"10010","name":"CrossProjectLink","inward":"part of","outward":"contains","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLinkType/10010"},"outwardIssue":{"id":"17392","key":"DPMITCRM-3","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/17392","fields":{"summary":"mails from General Mail IDs ","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10014","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_closed.gif","name":"DONE","id":"10014"},"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/6","id":"6","description":"A user story","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/sales.gif","name":"User Story","subtask":false}}}},{"id":"12773","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLink/12773","type":{"id":"10010","name":"CrossProjectLink","inward":"part of","outward":"contains","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLinkType/10010"},"outwardIssue":{"id":"17394","key":"DPMITCRM-4","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/17394","fields":{"summary":"Open Case ","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10014","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_closed.gif","name":"DONE","id":"10014"},"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/6","id":"6","description":"A user story","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/sales.gif","name":"User Story","subtask":false}}}},{"id":"12772","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLink/12772","type":{"id":"10010","name":"CrossProjectLink","inward":"part of","outward":"contains","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLinkType/10010"},"outwardIssue":{"id":"17395","key":"DPMITCRM-5","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/17395","fields":{"summary":"Create Case from existing email","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10014","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_closed.gif","name":"DONE","id":"10014"},"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/6","id":"6","description":"A user story","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/sales.gif","name":"User Story","subtask":false}}}},{"id":"12770","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLink/12770","type":{"id":"10010","name":"CrossProjectLink","inward":"part of","outward":"contains","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLinkType/10010"},"outwardIssue":{"id":"17396","key":"DPMITCRM-6","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/17396","fields":{"summary":"Manage Case","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10014","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_closed.gif","name":"DONE","id":"10014"},"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/6","id":"6","description":"A user story","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/sales.gif","name":"User Story","subtask":false}}}},{"id":"12778","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLink/12778","type":{"id":"10010","name":"CrossProjectLink","inward":"part of","outward":"contains","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLinkType/10010"},"outwardIssue":{"id":"17397","key":"DPMITCRM-7","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/17397","fields":{"summary":"Email in case","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10014","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_closed.gif","name":"DONE","id":"10014"},"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/6","id":"6","description":"A user story","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/sales.gif","name":"User Story","subtask":false}}}},{"id":"12776","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLink/12776","type":{"id":"10010","name":"CrossProjectLink","inward":"part of","outward":"contains","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLinkType/10010"},"outwardIssue":{"id":"17398","key":"DPMITCRM-8","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/17398","fields":{"summary":"Reminder/Notification to case owner/Manager","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10014","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_closed.gif","name":"DONE","id":"10014"},"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/6","id":"6","description":"A user story","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/sales.gif","name":"User Story","subtask":false}}}},{"id":"12774","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLink/12774","type":{"id":"10010","name":"CrossProjectLink","inward":"part of","outward":"contains","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLinkType/10010"},"outwardIssue":{"id":"17399","key":"DPMITCRM-9","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/17399","fields":{"summary":"Notify to manager","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10014","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_closed.gif","name":"DONE","id":"10014"},"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/6","id":"6","description":"A user story","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/sales.gif","name":"User Story","subtask":false}}}},{"id":"12771","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLink/12771","type":{"id":"10010","name":"CrossProjectLink","inward":"part of","outward":"contains","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLinkType/10010"},"outwardIssue":{"id":"17400","key":"DPMITCRM-10","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/17400","fields":{"summary":"BDM view for correspondence history","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10014","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_closed.gif","name":"DONE","id":"10014"},"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/6","id":"6","description":"A user story","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/sales.gif","name":"User Story","subtask":false}}}},{"id":"12769","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLink/12769","type":{"id":"10010","name":"CrossProjectLink","inward":"part of","outward":"contains","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLinkType/10010"},"outwardIssue":{"id":"17402","key":"DPMITCRM-11","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/17402","fields":{"summary":"Presentation Request Form ","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10014","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_closed.gif","name":"DONE","id":"10014"},"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/6","id":"6","description":"A user story","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/sales.gif","name":"User Story","subtask":false}}}},{"id":"12777","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLink/12777","type":{"id":"10010","name":"CrossProjectLink","inward":"part of","outward":"contains","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLinkType/10010"},"outwardIssue":{"id":"17403","key":"DPMITCRM-12","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/17403","fields":{"summary":"Request Flow","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10014","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_closed.gif","name":"DONE","id":"10014"},"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/6","id":"6","description":"A user story","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/sales.gif","name":"User Story","subtask":false}}}},{"id":"12775","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLink/12775","type":{"id":"10010","name":"CrossProjectLink","inward":"part of","outward":"contains","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLinkType/10010"},"outwardIssue":{"id":"17404","key":"DPMITCRM-13","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/17404","fields":{"summary":"Calendar display of approved events","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10014","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_closed.gif","name":"DONE","id":"10014"},"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/6","id":"6","description":"A user story","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/sales.gif","name":"User Story","subtask":false}}}}],"customfield_10000":null,"customfield_10765":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/customFieldOption/10667","value":"No","id":"10667"},"subtasks":[],"customfield_10767":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/customFieldOption/10674","value":"No","id":"10674"},"status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10012","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_generic.gif","name":"Release Ready","id":"10012"},"labels":[],"workratio":-1,"project":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/project/DPMITCRM","id":"11530","key":"DPMITCRM","name":"DPMIT-CRM","avatarUrls":{"16x16":"https://atlassian.au.challenger.net/jira/secure/projectavatar?size=small&pid=11530&avatarId=10000","48x48":"https://atlassian.au.challenger.net/jira/secure/projectavatar?pid=11530&avatarId=10000"}},"environment":"UAT1","customfield_10053":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/customFieldOption/10030","value":"Yes","id":"10030"},"aggregateprogress":{"progress":0,"total":0},"customfield_10050":null,"components":[],"comment":{"startAt":0,"maxResults":0,"total":0,"comments":[]},"timeoriginalestimate":null,"customfield_10461":null,"customfield_10460":null,"customfield_11963":null,"customfield_10360":"","votes":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/DPMITCRM-15/votes","votes":0,"hasVoted":false},"customfield_10261":null,"customfield_10262":null,"customfield_10263":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/customFieldOption/10061","value":"Yes","id":"10061"},"fixVersions":[{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/version/12162","id":"12162","description":"Deployement completed at 1:53 PM","name":"CHG32475","archived":false,"released":true,"releaseDate":"2013-09-13"}],"resolution":null,"resolutiondate":null,"aggregatetimeoriginalestimate":null,"customfield_10161":null,"customfield_10160":null,"duedate":"2013-09-06","customfield_10020":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/customFieldOption/10011","value":"S","id":"10011"},"customfield_10060":"4248","watches":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/DPMITCRM-15/watchers","watchCount":0,"isWatching":false},"customfield_10162":3.5,"worklog":{"startAt":0,"maxResults":0,"total":0,"worklogs":[]},"assignee":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/user?username=cbattegoda","name":"cbattegoda","emailAddress":"cbattegoda@challenger.com.au","avatarUrls":{"16x16":"https://atlassian.au.challenger.net/jira/secure/useravatar?size=small&ownerId=cbattegoda&avatarId=11281","48x48":"https://atlassian.au.challenger.net/jira/secure/useravatar?ownerId=cbattegoda&avatarId=11281"},"displayName":"Chameen Battegoda","active":true},"attachment":[{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/attachment/14091","id":"14091","filename":"BRD- Technical Services SF.docx","author":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/user?username=lkaligotla","name":"lkaligotla","emailAddress":"lkaligotla@challenger.com.au","avatarUrls":{"16x16":"https://atlassian.au.challenger.net/jira/secure/useravatar?size=small&avatarId=10102","48x48":"https://atlassian.au.challenger.net/jira/secure/useravatar?avatarId=10102"},"displayName":"Lakshmi Kaligotla","active":true},"created":"2013-08-22T14:25:40.300+1000","size":880615,"mimeType":"application/vnd.openxmlformats-officedocument.wordprocessingml.document","content":"https://atlassian.au.challenger.net/jira/secure/attachment/14091/BRD-+Technical+Services+SF.docx"}],"aggregatetimeestimate":null,"versions":[],"timeestimate":null,"customfield_10030":null,"customfield_10031":null,"aggregatetimespent":null}} """
//
//    type LinkedIssuesJsonSchema = FSharp.Data.JsonProvider< linkedIssueSchema >
//
//    type JiraItem = { Key:string ; Summary:string ; Start:DateTime; Due:DateTime; Environment:string; Status:string; IdealHours:decimal }
//    let jil = new System.Collections.Generic.List<JiraItem>();
//
//    [<Literal>]
//    let childIssueSchema = """ {"expand":"renderedFields,names,schema,transitions,operations,editmeta,changelog","id":"18039","self":"https://atlassian.au.challenger.net/jira/rest/api/latest/issue/18039","key":"DPMITPRODU-140","fields":{"progress":{"progress":0,"total":0},"summary":"Terms and Conditions","customfield_10560":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/customFieldOption/10340","value":"Yes","id":"10340"},"customfield_11067":null,"timetracking":{},"customfield_11066":null,"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/6","id":"6","description":"A user story","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/sales.gif","name":"User Story","subtask":false},"customfield_10562":null,"customfield_11069":null,"customfield_11068":null,"customfield_11160":"4834","customfield_11161":null,"customfield_11660":null,"timespent":null,"reporter":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/user?username=lkaligotla","name":"lkaligotla","emailAddress":"lkaligotla@challenger.com.au","avatarUrls":{"16x16":"https://atlassian.au.challenger.net/jira/secure/useravatar?size=small&avatarId=10102","48x48":"https://atlassian.au.challenger.net/jira/secure/useravatar?avatarId=10102"},"displayName":"Lakshmi Kaligotla","active":true},"created":"2013-12-24T11:05:54.973+1100","updated":"2013-12-24T11:07:19.083+1100","customfield_10041":null,"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"description":null,"customfield_10002":null,"customfield_10003":null,"customfield_10040":null,"issuelinks":[{"id":"13166","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLink/13166","type":{"id":"10010","name":"CrossProjectLink","inward":"part of","outward":"contains","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issueLinkType/10010"},"inwardIssue":{"id":"18036","key":"DPMITPROJ-35","self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/18036","fields":{"summary":"APC - Calculator","status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10003","description":"User has placed this item in the queue","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_visible.gif","name":"In Queue","id":"10003"},"priority":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/priority/3","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/priority_major.gif","name":"Medium","id":"3"},"issuetype":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issuetype/5","id":"5","description":"A big user story that needs to be broken down.","iconUrl":"https://atlassian.au.challenger.net/jira/download/resources/com.pyxis.greenhopper.jira:greenhopper-webactions/images/ico_epic.png","name":"Epic","subtask":false}}}}],"customfield_10000":null,"customfield_10765":null,"subtasks":[],"customfield_10767":null,"status":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/status/10016","description":"","iconUrl":"https://atlassian.au.challenger.net/jira/images/icons/status_open.gif","name":"Backlog","id":"10016"},"labels":[],"workratio":-1,"project":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/project/DPMITPRODU","id":"11433","key":"DPMITPRODU","name":"DPMIT-Products","avatarUrls":{"16x16":"https://atlassian.au.challenger.net/jira/secure/projectavatar?size=small&pid=11433&avatarId=11680","48x48":"https://atlassian.au.challenger.net/jira/secure/projectavatar?pid=11433&avatarId=11680"}},"environment":null,"customfield_10053":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/customFieldOption/10030","value":"Yes","id":"10030"},"aggregateprogress":{"progress":0,"total":0},"customfield_10050":null,"components":[],"comment":{"startAt":0,"maxResults":0,"total":0,"comments":[]},"timeoriginalestimate":null,"customfield_10461":null,"customfield_10460":null,"customfield_11963":[{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/customFieldOption/11441","value":"False","id":"11441"}],"customfield_10360":null,"votes":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/DPMITPRODU-140/votes","votes":0,"hasVoted":false},"customfield_10261":null,"customfield_10262":null,"customfield_10263":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/customFieldOption/10061","value":"Yes","id":"10061"},"fixVersions":[],"resolution":null,"resolutiondate":null,"aggregatetimeoriginalestimate":null,"customfield_10161":null,"customfield_10160":null,"duedate":null,"customfield_10020":null,"customfield_10060":"4790","watches":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/issue/DPMITPRODU-140/watchers","watchCount":1,"isWatching":false},"customfield_10162":null,"worklog":{"startAt":0,"maxResults":0,"total":0,"worklogs":[]},"assignee":{"self":"https://atlassian.au.challenger.net/jira/rest/api/2/user?username=cmckelt","name":"cmckelt","emailAddress":"cmcKelt@challenger.com.au","avatarUrls":{"16x16":"https://atlassian.au.challenger.net/jira/secure/useravatar?size=small&ownerId=cmckelt&avatarId=11084","48x48":"https://atlassian.au.challenger.net/jira/secure/useravatar?ownerId=cmckelt&avatarId=11084"},"displayName":"Chris Mckelt","active":true},"attachment":[],"aggregatetimeestimate":null,"versions":[],"timeestimate":null,"customfield_10030":null,"customfield_10031":null,"aggregatetimespent":null}}  """
//
//    type ChildJsonSchema = FSharp.Data.JsonProvider< childIssueSchema >
//
//    let checkNull str = (if String.IsNullOrEmpty(str) then "UAT1" else (if not <| (str="null") then str else "UAT1"))  // null is coming back as 'null' ie a string
//
//    let checkNullDate str = (if String.IsNullOrEmpty(str) then DateTime.Now else (if not <| (str="null") then Convert.ToDateTime str else DateTime.Now))  // null is coming back as 'null' ie a string
//
//    let checkNullObj o = match box(o) with | null -> false | x -> true  
//
//    let outputRoadmap() = 
//        let log = Lacjam.Core.Runtime.Ioc.Resolve<ILogWriter>()
//        log.Write(Debug("-- outputRoadmap --"))
//        
//        try
//            let url = "https://atlassian.au.challenger.net/jira/rest/api/2/search?jql=project=DPMIT-PROJECTS&fields=id,key,status,customfield_10360,customfield_11075,duedate,summary,environment,status,issuelinks&maxResults=100"
//            log.Write(Debug(url))
//            let result = getRestResponse url
//            log.Write(Debug("HTML Content Length return from REST query :" + result.Content.Length.ToString()))
//            let json = OutputRoadmapJsonSchema.Parse(result.Content)
//            for issue in json.Issues do
//                let startDate = checkNullDate issue.Fields.Customfield10360
//                let dueDate =  checkNullDate issue.Fields.Duedate
//                     
//                //                let dd = if (checkNullObj childJson.Fields.Duedate.JsonValue ) then DateTime.Now.AddMonths(3) else Convert.ToDateTime childJson.Fields.Duedate.JsonValue
//                let linkedResult = getRestResponse ("https://atlassian.au.challenger.net/jira/rest/api/latest/issue/" +  issue.Key)
//                Debug.WriteLine linkedResult
//                log.Write(Debug("HTML Content Length return from REST query :" + linkedResult.Content.Length.ToString()))
//                let linkedJson = LinkedIssuesJsonSchema.Parse(linkedResult.Content)
//                let mutable idealHours = 0E+0
//                for iss in linkedJson.Fields.Issuelinks do
//                    try
//                        if not <| (iss.OutwardIssue.Key.Contains("DPMITPROJ")) then
//                            if (iss.Type.Name = "CrossProjectLink")  then
//                                let uri =  ("https://atlassian.au.challenger.net/jira/rest/api/latest/issue/" +  (iss.OutwardIssue.Key.ToString()))
//                                log.Write(Debug(uri))
//                                let item = getRestResponse uri
//                                log.Write(Debug("HTML Content Length return from REST query :" + item.Content.Length.ToString()))
//                                let childJson = ChildJsonSchema.Parse(item.Content)
//                                log.Write(Debug(childJson.Fields.Customfield10162.JsonValue.ToString()))
//                                let (v:double) = 
//                                    match unbox(childJson.Fields.Customfield10162.JsonValue.ToString()) with 
//                                    | null -> 0E+0
//                                    | x when x <> "null" -> 
//                                        try
//                                            Convert.ToDouble(x)
//                                        with | exn -> 
//                                                printf "%A" exn
//                                                log.Write(Error("--  Convert.ToDouble(x) --",exn,false))
//                                                0E+0
//                                    | _ -> 0E+0
//                                idealHours <- (idealHours + v)
//                    with | exx ->  printf "%A" exx
//                                   log.Write(Error("-- Json.Issues --",exx,false))
//                
//                let estimatedHours = match idealHours with 
//                                        | 0E+0 -> 
//                                            try
//                                                Convert.ToDouble(issue.Fields.Customfield11075)    // use approve estimated instead 
//                                                with | exx ->  
//                                                        printf "%A" exx 
//                                                        0E+0
//                                        | _ -> idealHours
//                            
//                let ji = {
//                    Key=issue.Key; 
//                    Summary=issue.Fields.Summary; 
//                    Start=startDate; 
//                    Due=dueDate;
//                    Environment=(checkNull (issue.Fields.Environment.Value)); 
//                    Status=(issue.Fields.Status.Name) ; 
//                    IdealHours=(decimal estimatedHours)}
//                
//                if (ji.Status <> "DONE") && not <| (jil.Any(fun a-> ji.Key = a.Key)) then
//                    log.Write(Info("-- Adding -- " + ji.Key))
//                    jil.Add(ji)
//
//
//                log.Write(Debug("Total projects = " + json.Total.ToString()))
//                log.Write(Debug("Total issues = " + json.Issues.Count().ToString()))  
//
//
//            log.Write(Debug("-- Roadmap about to write out text file --"))
//           
//            let sb = new System.Text.StringBuilder()
//            
//            let op = jil.Distinct().OrderBy(fun x-> x.Start)
//            let sss = JsonConvert.SerializeObject(op)
//            sb.Append(sss.Replace("@", "")) |> ignore
//                
//            log.Write(Debug("-- Roadmap Results --"))
//            log.Write(Debug(sb.ToString()))
//
//            if not <| (String.IsNullOrEmpty(sb.ToString())) && (sb.ToString().Length > 5)  then
//                if (IO.File.Exists(remote)) then
//                   System.IO.File.Delete(remote)
//                System.IO.File.AppendAllText(remote,sb.ToString())
//            else
//                log.Write(Debug("-- NO Roadmap Results !!! String is empty--"))
//
//        with
//        | :? ServerTooBusyException as exn ->
////            let innerMessage =
////                match (exn.InnerException) with
////                | null -> ""
////                | innerExn -> innerExn.Message
////            printfn "An exception occurred:\n %s\n %s" exn.Message innerMessage
//            log.Write(Error("JIRA roadmap : ",exn, false))
//        | exn -> 
//                printfn "An exception occurred : %s" exn.Message
//                log.Write(Error("JIRA roadmap : ",exn, false))
//
