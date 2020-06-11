module SonarHelpers

open System
open System.IO
open System.Reflection
open VSSonarPlugins
open VSSonarPlugins.Types
open SonarRestService

let execPath = Directory.GetParent(Assembly.GetExecutingAssembly().CodeBase.Replace("file:///", "")).ToString()

let CreateRulesWithDiagnostic(path : string, profiles : System.Collections.Generic.Dictionary<string, Profile>, rest : ISonarRestService, token : ISonarConfiguration, createRule : bool, enableRule : bool) = 
    let diags =  RoslynHelper.LoadDiagnosticsFromPath(path)

    if createRule then
        let mutable j = 0
        for roslynanalyser in diags do
            for lang in roslynanalyser.Languages do
                let repoinserver, language, templaterule =
                    if lang.ToLower().Equals("c#") then
                        let templaterule = new Rule()
                        templaterule.Name <- "Template Rule"
                        templaterule.Key <- "roslyn-cs:TemplateRule"
                        "roslyn-cs", "cs", templaterule
                    else
                        let templaterule = new Rule()
                        templaterule.Name <- "Template Rule"
                        templaterule.Key <- "roslyn-vbnet:TemplateRule"
                        "roslyn-vbnet", "vbnet", templaterule

                let profile = profiles.[language]
                let mutable i = 0
                j <- j + 1
                for diag in roslynanalyser.Analyser.SupportedDiagnostics do
                    let rule = profile.GetRule(repoinserver + ":" + diag.Id)
                
                    if rule = null then
                        let rule = new Rule()
                    
                        rule.Severity <- Severity.MAJOR
                        let desc = sprintf """<p>%s<a href="%s">Help Url</a></p>""" (diag.Description.ToString()) diag.HelpLinkUri
                        let markdown = sprintf """*%s* [Help Url](%s)""" (diag.Description.ToString()) diag.HelpLinkUri
                        rule.HtmlDescription <- desc
                        rule.MarkDownDescription <- markdown
                        rule.Key <- repoinserver + ":" + diag.Id
                        rule.Name <- diag.Title.ToString()
                        rule.Repo <- repoinserver
                        let errors = rest.CreateRule(token, rule, templaterule)
                        let dic = new System.Collections.Generic.Dictionary<string, string>()
                        dic.Add("markdown_description", markdown)
                        if errors.Count <> 0 then
                            printf "Cannot create rule in server %s due %s\n\r" diag.Id errors.[0]
                        else    
                            i <- i + 1
                            printf "%i %i Create Rule %s in %s\n\r" j i rule.Key repoinserver

                            let errors = rest.UpdateRule(token, rule.Key, dic)
                            if errors.Count <> 0 then
                                printf "Failed to update markdown %s due %s\n\r" rule.Key errors.[0]

                            // enable rule
                            if enableRule then
                                let errors = rest.ActivateRule(token, rule.Key, rule.Severity.ToString(), profile.Key)
                                if errors.Count <> 0 then
                                    printf "Cannot enable rule in server %s due %s\n\r" rule.Key errors.[0]
    diags

let GetProfilesFromServer(projectKey : string,
                          service : ISonarRestService,
                          token : VSSonarPlugins.Types.ISonarConfiguration,
                          loaddisablerules : bool) =

    let profileData : System.Collections.Generic.Dictionary<string, Profile> = new System.Collections.Generic.Dictionary<string, Profile>()
    let profiles = service.GetQualityProfilesForProject(token, new Resource(Key=projectKey))
    let profilesKeys = service.GetProfilesUsingRulesApp(token)

    for profKey in profilesKeys do
        for profile in profiles do
            if profile.Name.Equals(profKey.Name) && profile.Language.Equals(profKey.Language) then
                profile.Key <- profKey.Key

    for profile in profiles do
        try
            System.Diagnostics.Debug.WriteLine("Get Profile: " + profile.Name + " : " + profile.Language)
            service.GetRulesForProfileUsingRulesApp(token, profile, true)

            if loaddisablerules then
                service.GetRulesForProfileUsingRulesApp(token, profile, false)

            profileData.Add(profile.Language, profile)
        with
        | ex ->
            printf "[RoslynRunner] profile failed to load: %s\n\r" ex.Message
            printf "[RoslynRunner] TRACE %s \n\r" ex.StackTrace
             
    profileData

let CreateAndAssignProfileInServer(projectKey : string,
                                   service : ISonarRestService,
                                   token : VSSonarPlugins.Types.ISonarConfiguration,
                                   diagnostics : Map<string, RoslynHelper.RosDiag List>) =

    let profileData : System.Collections.Generic.Dictionary<string, Profile> = new System.Collections.Generic.Dictionary<string, Profile>()
    let profiles = service.GetQualityProfilesForProject(token, new Resource(Key=projectKey))
    let profilesFinal : System.Collections.Generic.List<Profile> = null
    let profilesKeys = service.GetProfilesUsingRulesApp(token)

    for profKey in profilesKeys do
        for profile in profiles do
            if profile.Name.Equals(profKey.Name) && profile.Language.Equals(profKey.Language) then
                profile.Key <- profKey.Key

    for profile in profiles do
        let repositoryid = ""
        if profile.Language.Equals("cs") || profile.Language.Equals("vbnet") then
            let parentprofileKey = profile.Key
            let profilenew = profile
            if not(profile.Name.Equals("Complete Roslyn Profile : " + projectKey)) then
                // copy profile
                let newKey = service.CopyProfile(token, profile.Key, "Complete Roslyn Profile : " + projectKey)
                profilenew.Key <- newKey
                profilenew.Name <- "Complete Roslyn Profile"
                profilenew.Language <- profile.Language
                let msg = service.AssignProfileToProject(token, profilenew.Key, projectKey)
                if msg <> "" then
                    printf "Failed to assign profile %s to project %s\r\n" profile.Name projectKey

            // sync rules from rule set
            let repoid = 
                if profilenew.Language.Equals("cs") then
                    "roslyn-cs"
                else
                    "roslyn-vbnet"

            service.GetRulesForProfileUsingRulesApp(token, profilenew, false)

            for dll in diagnostics do
                if dll.Value.Length <> 0 then
                    for diag in dll.Value do
                        for supdiag in diag.Analyser.SupportedDiagnostics do
                            let rule = profilenew.GetRule(repoid + ":" + supdiag.Id)
                            if rule <> null then
                                for msg in service.ActivateRule(token, rule.Key, rule.Severity.ToString(), profilenew.Key) do
                                    printf "Cannot enable rule %s - %s\r\n" rule.Key msg

            // set parent profile so users can manage the rest of the profile
            let msg = service.ChangeParentProfile(token, profilenew.Key, parentprofileKey)
            if msg <> "Failed change parent: NoContent" then
                printf "Change Profile Parent Failed :  %s\r\n" msg
            
                                                       
    GetProfilesFromServer(projectKey, service, token, false)
                       
let AssignProfileToParent(token : ISonarConfiguration, rest : ISonarRestService, profileKey : string, projectKey : string ) = 
    let parentKey = rest.GetParentProfile(token, profileKey)

    if parentKey <> "" then
        let msg = rest.AssignProfileToProject(token, parentKey, projectKey)
        if msg <> "" then
            printf "Failed to assign profile %s to project %s\r\n" parentKey projectKey
                                               
let DeleteCompleteProfile(token : ISonarConfiguration, rest : ISonarRestService, projectKey : string) =
    let profiles = rest.GetProfilesUsingRulesApp(token)

    for profile in profiles do
        if profile.Name = "Complete Roslyn Profile : " + projectKey then
            AssignProfileToParent(token, rest, profile.Key, projectKey)
            let msg = rest.DeleteProfile(token, profile.Key)
            if msg <> "Failed change parent: NoContent" then
                printf "Delete Profile Parent Failed :  %s\r\n" msg
                                  
let SyncRulesInServer(paths : string [], baseroot : string, rest : ISonarRestService, token : ISonarConfiguration, enable : bool, projectKey : string, create : bool) =

    let profiles = GetProfilesFromServer(projectKey, rest, token, true)
    let mutable diagnosticList = Map.empty

    // make sure rules are created in sonar first
    for path in paths do
        if path <> "" then
            let abspath =
                if Path.IsPathRooted(path) then
                    path
                else
                    Path.GetFullPath(Path.Combine(baseroot, path))

            if File.Exists(abspath) then
                diagnosticList <- diagnosticList.Add(abspath, CreateRulesWithDiagnostic(abspath, profiles, rest, token, create, enable))
            else
                printf "[RoslynRunner] %s PATH not found" abspath

    diagnosticList

let GetConnectionToken(service : ISonarRestService, address : string , userName : string, password : string) = 
    let token = new VSSonarPlugins.Types.ConnectionConfiguration(address, userName, password, 4.5)
    token.SonarVersion <- float (service.GetServerInfo(token))
    token

let DeleteRoslynRulesInProfiles(service : ISonarRestService, token : VSSonarPlugins.Types.ISonarConfiguration, profile : Profile) = 
    let rules = profile.GetAllRules()
    for rule in rules do
        if rule.Key.StartsWith("roslyn-") && not(rule.IsTemplate) then
            let errors = service.DeleteRule(token, rule)
            for error in errors do
                printf "Cannot Delete Rule: %s\r\n" error
