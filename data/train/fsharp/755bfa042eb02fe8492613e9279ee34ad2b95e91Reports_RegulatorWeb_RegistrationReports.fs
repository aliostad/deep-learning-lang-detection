module Reports_RegulatorWeb_RegistrationReports
open canopy
open runner
open etconfig   
open lib
open gwlib
open System

let core _ = 
    context "Registration Reports - MSRB Regulator Web"
    once (fun _ -> 
        logoutGateway ()
        loginGateway ()
        )
    lastly (fun _ -> logoutGateway ())

    if config.regWebV2 = true then
            
        "MSRB Registration Report" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegistrationReports/RegistrationReports']"
            setFieldValue "#MsrbId" "A" 
            click "input[value='Search']"
            assertFieldContains "#tabs-1" "Search Results"

        "Form A-12 Review" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegistrationReports/RegistrationReports']"
            click "a[href='#tabs-2']"
            assertDisplayed "No data available in table"
            setFieldValue "#formA12SearchMsrbId" "A"
            click "Search"
            assertFieldContains "div.#formA12ResultsTable_info" "Showing 1 to"

        "Form RTRS" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegistrationReports/RegistrationReports']"
            click "a[href='#tabs-3']"
            assertDisplayed "No data available in table"
            setFieldValue "#formRTRSSearchMsrbId" "A"
            click "Search"
            assertFieldContains "div.#formRTRSResultsTable_info" "Showing 1 to"
        
        "Monthly Report" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RedirectToQueryReports']"
            url (gatewayUrl + "/msrb1/control/send.asp?target=REGULATOR_MR&auth=1")
            assertFieldContains "div.mainContent h2" "Periodic Reports"

        "Real-Time Transaction Reporting System (RTRS) - RTRS Report Usage Log"  &&& fun _ ->    
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RedirectToRTRSUsageLog']"
            url (gatewayUrl + "/msrb1/control/regulator/rtrswebusage/lookup.asp")
            setFieldValue "input[name=start_date]" "09/01/2010"
            setFieldValue "input[name=end_date]" "09/01/2010"
            click "input[value='    Submit    ']"  
            let t1 () =
                sleep 2.0
                someElement("Report Name").IsSome
            extendTimeout (fun _ -> waitFor t1)         
            assertDisplayed "Report Name"

        "Primary Market Risks LINK" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RegWebRedirect?tab=PrimaryRisks']"
            assertUrl (gatewayUrl + "RegWeb.aspx?Tab=PrimaryRisks")

        "Training Resources LINK" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RegWebRedirect?tab=TrainingResources']"
            assertUrl (gatewayUrl + "RegWeb.aspx?Tab=TrainingResources")

        "RebWeb Manuals LINK" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RegWebRedirect?tab=RegWebHelp']"
            assertUrl (gatewayUrl + "RegWeb.aspx?Tab=RegWebHelp")

        "Training Resources LINK - TRAINING RESOURCES" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RegWebRedirect?tab=TrainingResources']"
            assertUrl (gatewayUrl + "RegWeb.aspx?Tab=TrainingResources")
            click "div.#TrainingResourcesSubTab"
            assertDisplayed "Supporting Materials"
            click "div.#TrainingEventsSubTab"
            assertDisplayed "Event"
            assertDisplayed "Register"
            click "Register"

        "Training Resources LINK - PRIMARY MARKET RISKS" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RegWebRedirect?tab=TrainingResources']"
            assertUrl (gatewayUrl + "RegWeb.aspx?Tab=TrainingResources")
            click "a[href='#tabs-1']"
            assertElementExists "dealerRiskTypeSpan"
            click "#maRiskTypeSpan"
            click "#dealerRiskTypeSpan"

        "Training Resources LINK - REGWEB MANUALS" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RegWebRedirect?tab=TrainingResources']"
            assertUrl (gatewayUrl + "RegWeb.aspx?Tab=TrainingResources")
            click "a[href='#tabs-3']"
            assertElementExists "leftDocsTableDiv"
            assertElementExists "rigthDocsDiv"

        "MSRB Rules LINK" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "img[src='/Regulator/Content/images/msrb-rules.png']"
            locateWindowWithTitleText "MSRB Rules"
            assertUrl (msrbOrgUrl + "Rules-and-Interpretations/MSRB-Rules.aspx")
            safeCloseWindow()
            locateWindowWithTitleText "Regulator Web"

        "MSRB Education Center LINK" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "img[src='/Regulator/Content/images/msrb-edCenter-logo.png']"
            locateWindowWithTitleText "Education Center"
            assertUrl (msrbOrgUrl + "educationcenter.aspx")
            safeCloseWindow()
            locateWindowWithTitleText "Regulator Web"

        "EMMA LINK" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "img[src='/Regulator/Content/images/emma-logo.png']"
            locateWindowWithTitleText "EMMA"
            assertUrl (emmaUrl)
            safeCloseWindow()
            locateWindowWithTitleText "Regulator Web"

        "Tell us what you think LINK" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "img[src='/Regulator/Content/images/feedback.png']"
            assertDisplayed "MSRB Regulator Web Feedback"

        "TERMS AND CONDITIONS LINK" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click ("a[href='"+msrbOrgUrl+"Terms-and-Conditions.aspx']")
            locateWindowWithTitleText "Conditions"
            assertUrl (msrbOrgUrl + "Terms-and-Conditions.aspx")
            safeCloseWindow()
            locateWindowWithTitleText "Regulator Web"

        "PRIVACY STATEMENT LINK" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click ("a[href='"+msrbOrgUrl+"Privacy-Statement.aspx']")
            locateWindowWithTitleText "Privacy"
            assertUrl (msrbOrgUrl + "Privacy-Statement.aspx")
            safeCloseWindow()
            locateWindowWithTitleText "Regulator Web"

        "SITE MAP LINK" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click ("a[href='"+msrbOrgUrl+"Site-Map.aspx']")
            locateWindowWithTitleText "Map"
            assertUrl (msrbOrgUrl + "Site-Map.aspx")
            safeCloseWindow()
            locateWindowWithTitleText "Regulator Web"

    if config.regWebV2 = false then
        "Form A-12 Review" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "#regulatortog"
            click "All Enforcement Agencies"
            url (gatewayUrl + "/msrb1/control/send.asp?target=FORMA12_REG")
            setFieldValue "#MsrbId" "A0278"
            click "Search"
            assertFieldContains "div.search h2" "Search Results"
            
        "MSRB Registration Report" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "#regulatortog"
            click "All Enforcement Agencies"
            url (gatewayUrl + "/msrb1/control/dispatch.asp?target=RegistrationReport")
            setFieldValue "#MsrbId" "A0278" 
            click "Search"
            assertFieldContains "div.mainContent h2:nth-of-type(2)" "Search Results"
        
        "MSRB Broker-Dealer Registrants List" &&& fun _ ->
           url (gatewayUrl + "msrb1/control/selection.asp")
           click "#regulatortog"
           click "All Enforcement Agencies"
           click "MSRB Broker-Dealer Registrants List"
           extendTimeout ( fun _ ->
                waitFor ( fun _ ->
                    someElement("div.col-md-9.pt5 b").IsSome
                    )
                )
           assertFieldContains "div.col-md-9.pt5 b" "This is a complete list of all broker-dealers and bank dealers registered with the MSRB"
                
        "MSRB Municipal Advisor Registrants List" &&& fun _ ->
           url (gatewayUrl + "msrb1/control/selection.asp")
           click "#regulatortog"
           click "All Enforcement Agencies"
           click "MSRB Municipal Advisor Registrants List"
           extendTimeout ( fun _ ->
                waitFor ( fun _ ->
                    someElement("div.col-md-9.pt5 b").IsSome
                    )
                )
           assertFieldContains "div.col-md-9.pt5 b" "This is a complete list of all municipal advisors registered with the MSRB"

        "Monthly Report" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "#regulatortog"
            click "All Enforcement Agencies"
            url (gatewayUrl + "/msrb1/control/send.asp?target=REGULATOR_MR&auth=1")
            assertFieldContains "div.mainContent h4" "The most current monthly reports for" 

        "Real-Time Transaction Reporting System (RTRS) - Form RTRS" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "#regulatortog"
            click "All Enforcement Agencies"
            url (gatewayUrl + "/msrb1/control/send.asp?target=FORMRTRS_REG")
            setFieldValue "#MsrbId" "A0278" 
            click "input.submit"
            assertFieldContains "div.search h2" "Search Results"

        "Real-Time Transaction Reporting System (RTRS) - Form RTRS Archive" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "#regulatortog"
            click "All Enforcement Agencies"
            url (gatewayUrl + "msrb1/control/regulator/FormRTRS/formonlyreview.asp")
            setFieldValue "#search" "A0278" 
            click "input[type=submit]"
            contains "Archive of Form RTRS Submissions Prior to April 15, 2013" (read "h1") 

        "Product Documentation Directory" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "#regulatortog"
            click "All Enforcement Agencies"
            url (gatewayUrl + "msrb1/control/regulator/msrbproducts/productdirectoryp1.asp")
            assertDisplayed "MSRB PRODUCT DOCUMENTATION DIRECTORY"

        "Real-Time Transaction Reporting System (RTRS) - RTRS Report Usage Log"  &&& fun _ ->    
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "#regulatortog"
            click "All Enforcement Agencies"
            url (gatewayUrl + "/msrb1/control/regulator/rtrswebusage/lookup.asp")
            setFieldValue "input[name=start_date]" "09/01/2010"
            setFieldValue "input[name=end_date]" "09/01/2010"
            click "input[value='    Submit    ']"  
            let t1 () =
                sleep 2.0
                someElement("Report Name").IsSome
            extendTimeout (fun _ -> waitFor t1)         
            assertDisplayed "Report Name"

let underConstruction _ = 
    context "Registration Reports - MSRB Regulator Web (Under Construction)"
    once (fun _ -> loginGateway ())
    lastly (fun _ -> logoutGateway ())

    "Real-Time Transaction Reporting System (RTRS) - RTRS Web" &&& fun _ ->
        url (gatewayUrl + "msrb1/control/selection.asp")
        if config.regWebV2 = true then
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RedirectToQueryReports']"
        else
            click "#regulatortog"
            click "All Enforcement Agencies"
        url (gatewayUrl + "/msrb1/control/regulator/rtrsweb/dealer_lookup.asp")
        setFieldValue "#search" "A0005  "
        click "input[value='  Search   ']"
        sleep 2.0
        click "a[href='send.asp?msrbid=A0005']"   
        assertUrl (rtrsUrl + "rtrsweb/controller.do?cmd=home")

        

