module RightsManagementAndAuthentication
open canopy
open runner
open etconfig
open lib
open gwlib
open System

let core _ = 
    context "Rights Management and Authentication"

//Dealer does not have EMMA Dataport as a Gateway option
//DealerMAA grants Dealer right to EMMA Dataport - Continuing Disclosure Submission
//Dealer has EMMA Dataport as a Gateway option and can navigate to EMMA Dataport from Gateway
//Dealer logs into EMMA Dataport
//DealerMAA removes Dealer right to EMMA Dataport
//Dealer can not login into EMMA Dataport After Rights Are Removed
//Dealer does not have EMMA Dataport as a Gateway option

//NOTE: The GW_CREATION_SCRIPT.SQL must be run before the below scenario as a series of test case will succeed!

    "Step - 1: Dealer does not have EMMA Dataport as a Gateway option" &&& fun _ ->
        loginDealer ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        assertNotDisplayed "Market Transparency Systems"
        logoutGateway ()

    "Step - 2: DealerMAA grants Dealer right to EMMA Dataport - Continuing Disclosure Submission" &&& fun _ ->
        precondition "Dealer does not have EMMA Continuing Disclosure Rights"
        postcondition "Dealer does have EMMA Continuing Disclosure Rights"
        loginDealerMAA ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#acctmgtlnk"
        click "#ManageUserAccounts"
        assertFieldContains "span.heading" "User Accounts"
        click "a[href='accountView.asp?userId=DEALER']"
        click "Edit User Account"
        deselected "#EMMASSUBMIT"
        check "#EMMASSUBMIT"
        click "Continue"
        click "Confirm User Account"
        click "Return to Accounts"
        click "a[href='accountView.asp?userId=DEALER']" 
        selected "#EMMASSUBMIT"
        logoutGateway ()

    "Step - 3: Dealer has EMMA Dataport as a Gateway option and can navigate to EMMA Dataport from Gateway" &&& fun _ ->
        precondition "Dealer does have EMMA Continuing Disclosure Rights"
        postcondition "Dealer can access EMMA Dataport from Gateway"
        loginDealer ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        assertDisplayed "#systemstog"
        click "a[href='send.asp?target=EMMAEOS&checktac=1']"
        assertFieldContains "span.heading" "Continuing Disclosure - Terms and Conditions"
        click "input[value=' Accept ']"
        assertUrl (gatewayUrl + "Submission/SubmissionPortal.aspx")
        click "#ctl00_backToGatewayLinkButton"
//        click "Logout"
        logoutGateway ()

    "Step - 4: Dealer logs into EMMA Dataport" &&& fun _ ->
        precondition "Dealer has EMMA Dataport Rights"
        postcondition "Dealer can log into EMMA"
        url (emmaUrl)
        click "a[href='/Main/GotoDataport']"
        click "#loginButton"
        loginDealer () 
        click "a[href='send.asp?target=EMMAEOS&checktac=1']"
        assertUrl (gatewayUrl + "Submission/SubmissionPortal.aspx")
        click "#ctl00_backToGatewayLinkButton"
//        click "Logout"
        logoutGateway ()

    "Step - 5: DealerMAA removes Dealer right to EMMA Dataport" &&& fun _ ->
        precondition "Dealer must logout from EMMA/Gateway before rights are removed, otherwise Dealer still can access EMMA"
        postcondition "Dealer does not have EMMA Continuing Disclosure Rights"
        loginDealerMAA ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#acctmgtlnk"
        click "#ManageUserAccounts"
        assertFieldContains "span.heading" "User Accounts"
        click "a[href='accountView.asp?userId=DEALER']"
        click "Edit User Account"
        selected "#EMMASSUBMIT"
        uncheck "#EMMASSUBMIT"
        click "Continue"
        click "Confirm User Account"
        click "Return to Accounts"
        click "a[href='accountView.asp?userId=DEALER']" 
        deselected "#EMMASSUBMIT"
//        click "Logout"
        logoutGateway ()

    "Step - 6: Dealer can not login into EMMA Dataport After Rights Are Removed" &&& fun _ ->
        precondition "Dealer's rights to EMMA have been removed"
        postcondition "Dealer can not login into EMMA"
        url (emmaUrl)
        click "a[href='/Main/GotoDataport']"
        click "#loginButton"
        loginDealer () 
        assertNotDisplayed "Market Transparency Systems"
        logoutGateway ()

    "Step - 7: Dealer does not have EMMA Dataport as a Gateway option" &&& fun _ ->
        precondition "Dealer's rights to EMMA have been removed"
        postcondition "Market Transparency System link is not visible to Dealer in Gateway"
        loginDealer ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        assertNotDisplayed "Market Transparency Systems"
        logoutGateway ()

