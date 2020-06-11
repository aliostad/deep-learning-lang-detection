module OrganizationAdministration
open canopy
open runner
open etconfig
open lib
open gwlib
open System

let mutable lastMsrbId = ""

let core _ = 
    context "Staff Content - Organization Administration"
    once (fun _ -> loginGateway ())
    lastly (fun _ -> logoutGateway ())

    "User Lookup - UserID" &&& fun _ ->
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#stafftog"
        click "#organizationAdministration"
        click "#userLookup"
        setFieldValue "#userID" "DEALERMAA"
        click "Search"
        assertFieldContains "span.headingMain" "Matching Records"
        click "a[href='OrgDetails.asp?msrbid=A9995']"
        assertFieldContains "span.headingMain" "Organization Profile"
        click "a[href='UserDetails.asp?msrbid=A9995&uid=DEALERMAA']"
        assertFieldContains "span.headingMain" "User Profile for DEALERMAA"
        click "input[value='Send UserID']"
        assertFieldContains "h1" "Send UserID"
        assertFieldContains "td" "The userid has been sent to the address on record for this account along with instructions on how to obtain the matching password"

    "User Lookup - Role" &&& fun _ ->
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#stafftog"
        click "#organizationAdministration"
        click "#userLookup"
        setFieldValue "#role" "Dealer"
        click "Search"
        assertFieldContains "span.headingMain" "Matching Records"

    "User Lookup - By Application - EMMA Contiuing Disclosure Submission" &&& fun _ ->
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#stafftog"
        click "#organizationAdministration"
        click "#userLookup"
        setFieldValue "#appID" "EMMA Continuing Disclosure Submissions"
        click "Search"
        let t1 () =
            sleep 2.0
            someElement("a[href='UserLookup.asp?o=1']").IsSome
        extendTimeout (fun _ -> waitFor t1)
        assertFieldContains "span.headingMain" "Matching Records"

    "User Lookup - By Application - EMMA Continuing Disclosure Subscriber" &&& fun _ ->
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#stafftog"
        click "#organizationAdministration"
        click "#userLookup"
        setFieldValue "#appID" "EMMA Continuing Disclosure Subscriber"
        click "Search"
        let t1 () =
            sleep 2.0
            someElement("a[href='UserLookup.asp?o=1']").IsSome
        extendTimeout (fun _ -> waitFor t1)
        assertFieldContains "span.headingMain" "Matching Records"

    "User Lookup - By Application - EMMA Primary Market Submissions" &&& fun _ ->
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#stafftog"
        click "#organizationAdministration"
        click "#userLookup"
        setFieldValue "#appID" "EMMA Primary Market Submissions"
        click "Search"
        let t1 () =
            sleep 2.0
            someElement("a[href='UserLookup.asp?o=1']").IsSome
        extendTimeout (fun _ -> waitFor t1)
        assertFieldContains "span.headingMain" "Matching Records"

    "MSRB Registration Report" &&& fun _ ->
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#stafftog"
        click "#organizationAdministration"
        click "MSRB Registration Report"    
        setFieldValue "#OrganizationRole" "Broker-Dealer Only"
        click "Search"
        assertFieldContains "div.mainContent" "Matching Records"

    "Organization Registration - Dealer and Municipal Advisors" &&& fun _ ->
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#stafftog"
        click "#organizationAdministration"
        click "#dealerMALookup"
        click "Active/Withdrawn"
        setFieldValue "#MsrbId" "MSRB"
        click "Search"
        assertFieldContains "#psoActiveSearchResults_info" "Showing"

    "Organization Lookup" &&& fun _ ->
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#stafftog"
        click "#organizationAdministration"
        click "#organizationLookup"
        setFieldValue "#search" "A9995"
        click "#searchButton"
        click "#A99950"
        assertFieldContains "span.headingMain" "Organization Profile"

    "Organization Registration - Dealers and Municipal Advisors - Pending" &&& fun _ ->
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#stafftog"
        click "#organizationAdministration"
        click "#dealerMALookup"
        click "[href='#tabs-1']"
        click "#psoSearchResults tbody tr:nth-of-type(2) td:nth-of-type(1) a"
        assertFieldContains "h2" "A12 Organization Details"

