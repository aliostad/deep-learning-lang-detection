module FormA12Registration
open canopy
open runner
open etconfig
open lib
open gwlib
open System
open TestomaticSupport

let mutable lastMsrbId = ""
let mutable lastUserId = ""
let mutable lastPrimaryContactName =""
let mutable emailHelper : EmailHelper = null

let core _ = 
    context "FORM-A12 Registration"
    once (fun _ -> 
        emailHelper <- new EmailHelper (config.smtpTest.username, config.smtpTest.password)
        emailHelper.DeleteAllMessages |> ignore
        )
    lastly (fun _ -> 
        emailHelper.DeleteAllMessages |> ignore
        emailHelper <- null 
        )
//Broker-Dealer and Municipal Advisor--------------------------------------------------------------------
    let dealerAndMaRegistration () =        
        url (gatewayUrl + "msrb1/control/registration/")
        click "input[id='registrationTypeDealers']"
        click "#nextButton"
        click "#Continue"
        click "#OrgRolePopup"
        setFieldValue "#OrgRole" "Broker-Dealer and Municipal Advisor"
        click "#selectButton"
        click "Continue with Form A-12"  
        setFieldValue "#GeneralFirmInformation_FirmName" "test msrb Broker Dealer and MA"
        setFieldValue "#GeneralFirmInformation_BrokerDealerSec" "99999"
        setFieldValue "#GeneralFirmInformation_CRDNumber" "999999999"
        setFieldValue "#GeneralFirmInformation_MuniAdvisorSecPrefix" "866"
        setFieldValue "#GeneralFirmInformation_MuniAdvisorSec1" (((System.Random()).Next(10000, 99999)).ToString("00"))
        setFieldValue "#GeneralFirmInformation_MuniAdvisorSec2" (((System.Random()).Next(10, 99)).ToString("00"))
        setFieldValue "#GeneralFirmInformation_LegalEntityIdentifier" "43534535345345435345"
        fileUploadSelectPdf "#registrationDoc"
        click "#uploadbutton"
        setFieldValue "#GeneralFirmInformation_CorpAddress1" "1900 Duke Street"
        setFieldValue "#GeneralFirmInformation_CorpAddress2" "Suite 500"
        setFieldValue "#GeneralFirmInformation_City" "Alexandria"
        setFieldValue "#GeneralFirmInformation_State" "VA"
        setFieldValue "#GeneralFirmInformation_Zip" "40602"
        setFieldValue "#GeneralFirmInformation_CorpWebsite" "www.msrb.org"
        setFieldValue "#GeneralFirmInformation_FormOfOrganization" "Corporation"
        setFieldValue "#GeneralFirmInformation_OrgCity" "Alexandria"
        setFieldValue "#GeneralFirmInformation_OrgState" "VA"
        click "Continue"
        click "#BusinessActivities_Sections_0__BusinessActivitiesTypes_0__Selected"
        click "a[href='#tabs-2']"
        click "a[href='#tabs-3']"
        click "#BusinessActivities_Sections_2__BusinessActivitiesTypes_1__Selected"
        click "Continue"
        displayed "#BusinessActivities_Sections_3__BusinessActivitiesTypes_0__Selected"
        click "Continue"
        click "#addNewContact"
        setFieldValue "#ContactsModel_EditContact_FirstName" "Dealer"
        setFieldValue "#ContactsModel_EditContact_LastName" "ealer-MA"
        setFieldValue "#ContactsModel_EditContact_Title" "Title"
        setFieldValue "#ContactsModel_EditContact_EmailAddress" config.registrantEmail
        setFieldValue "#ContactsModel_EditContact_EmailAddressConfirm" config.registrantEmail
        setFieldValue "#ContactsModel_EditContact_AddressLine1" "1900 Duke Street"
        setFieldValue "#ContactsModel_EditContact_AddressLine2" "Suite 500"
        setFieldValue "#ContactsModel_EditContact_City" "Alexandria"
        setFieldValue "#ContactsModel_EditContact_State" "VA"
        setFieldValue "#ContactsModel_EditContact_Zip" "22314"
        setFieldValue "#ContactsModel_EditContact_PhoneAreaCode" "703"
        setFieldValue "#ContactsModel_EditContact_PhonePrefix" "797"
        setFieldValue "#ContactsModel_EditContact_PhoneNumber" "6600"
        setFieldValue "#ContactsModel_EditContact_PhoneExtension" "123"
        click "#saveContactButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Master Account Administrator"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Primary Regulatory Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Billing Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Compliance Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Primary Data Quality Contact"
        click "#selectButton"
        click "Optional Contacts"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Regulatory Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Data Quality Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Technical Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        click "Continue"
        click "#ExemptFromTradeReportingFlag"
        waitFor (fun _ -> (element "#preview").Enabled = true)
        click "#preview"
        sleep 1.0
        click "#Certification"
        sleep 0.01
        describe "User Application Submit"
        click "#submitButton"
        assertDisplayed "Submission Confirmation"
        click "click here"
        lastMsrbId <- (read "div.pdfInfo div.hr li:nth-of-type(1)").Replace("MSRB ID: ", "")
        describe ("lastMsrbId is: " + lastMsrbId)
        assertEqual true (emailHelper.MessageExists  ("MSRB Registration Form Received", "Organization Name: test msrb Broker Dealer and MA"))

    "Dealer and MA Registration and PSO Approval" &&& fun _ ->
        objective "Register a Dealer and MA complete through PSO Approval"
        objective "Verify User Id does not contain a special character and is not empty"
        objective "Verify email is delivered to registrant upon registration approval"
        dealerAndMaRegistration ()
        loginStaff ()
        waitFor (fun  _ -> (someElement "#stafftog").IsSome)
        click "#stafftog"
        click "#organizationAdministration"
        click "#dealerMALookup"
        setFieldValue "#MsrbId" lastMsrbId
        describe "Staff searching for form to approve"
        let t1 () =
            click "Search"
            sleep 2
            let e = (someElement "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a")
            e.IsSome && e.Value.Text = lastMsrbId
        extendTimeout (fun _ -> waitFor t1)
        click "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a"
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click "#approveFormA12"
        let t3 () =
            sleep 2.0
            someElement("MSRB Registration Report - Dealers and Municipal Advisors").IsSome
        extendTimeout (fun _ -> waitFor t3)
        assertUrl (gatewayUrl + "RegistrationManager/PSO/PSOSearch")
        click "Active/Withdrawn"
        describe "Staff searches for approved form"
        setFieldValue "#MsrbId" lastMsrbId
        let t2 () =
            click "Search"
            sleep 2
            let e = (someElement "#psoActiveSearchResults tr:nth-of-type(1) td:nth-of-type(1) a")
            e.IsSome && e.Value.Text = lastMsrbId
        extendTimeout (fun _ -> waitFor t2)
        click "#psoActiveSearchResults tr:nth-of-type(1) td:nth-of-type(1) a"
        assertEqual 5 (elements "Verified").Length
        lastUserId <- (read "div.a12Preview div.pdfInfo.orgdetails ul.l:nth-of-type(2) li:nth-of-type(2)").Replace("User ID: ", "")
        describe ("lastUserId is: " + lastUserId)
        assertStringIsAlphaNumeric lastUserId
        logout ()

    "Dealer and MA Registration and PSO Send Back User" &&& fun _ ->
        objective "Register a Dealer and MA complete through PSO Approval concluding with send back user"
        dealerAndMaRegistration ()
        loginStaff ()
        waitFor (fun  _ -> (someElement "#stafftog").IsSome)
        click "#stafftog"
        click "#organizationAdministration"
        click "#dealerMALookup"
        setFieldValue "#MsrbId" lastMsrbId //A7158
        let t1 () =
            click "Search"
            sleep 2
            let e = (someElement "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a")
            e.IsSome && e.Value.Text = lastMsrbId
        extendTimeout (fun _ -> waitFor t1)
        click "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a"
        click "#sendBack"
        setFieldValue "#psoSendBackNote" "test"
        click "#proceedSendBackSave"
        click "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a"
        click "input[id='sendBack']"
        click "input[id='proceedSendBack']"
        click "Return to Gateway Menu"
        logout ()

    "Dealer and MA Registration and PSO Reject" &&& fun _ ->
        objective "Register a Dealer and MA complete through PSO Approval concluding with a rejection notice"
        dealerAndMaRegistration ()
        loginStaff ()
        waitFor (fun  _ -> (someElement "#stafftog").IsSome)
        click "#stafftog"
        click "#organizationAdministration"
        click "#dealerMALookup"
        setFieldValue "#MsrbId" lastMsrbId
        let t1 () =
            click "Search"
            sleep 2
            let e = (someElement "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a")
            e.IsSome && e.Value.Text = lastMsrbId
        extendTimeout (fun _ -> waitFor t1)
        click "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a"
        click "#reject"
        setFieldValue "#psoRejectNote" "test"
        click "#proceedReject"
        click "Return to Gateway Menu"
        logout ()

//Broker-Dealer Only--------------------------------------------------------------------
    let brokerDealerRegistration () =
        url (gatewayUrl + "msrb1/control/registration/")
        click "input[id='registrationTypeDealers']"
        click "#nextButton"
        click "#Continue"
        click "#OrgRolePopup"
        setFieldValue "#OrgRole" "Broker-Dealer Only"
        click "#selectButton"
        click "Continue with Form A-12"  
        setFieldValue "#GeneralFirmInformation_FirmName" "test msrb Broker Dealer only"
        setFieldValue "#GeneralFirmInformation_BrokerDealerSec" "99999"
        setFieldValue "#GeneralFirmInformation_CRDNumber" "999999999"
        setFieldValue "#GeneralFirmInformation_LegalEntityIdentifier" "43534535345345435345"
        fileUploadSelectPdf "#registrationDoc"
        click "#uploadbutton"
        setFieldValue "#GeneralFirmInformation_CorpAddress1" "1900 Duke Street"
        setFieldValue "#GeneralFirmInformation_CorpAddress2" "Suite 500"
        setFieldValue "#GeneralFirmInformation_City" "Alexandria"
        setFieldValue "#GeneralFirmInformation_State" "VA"
        setFieldValue "#GeneralFirmInformation_Zip" "40602"
        setFieldValue "#GeneralFirmInformation_CorpWebsite" "www.msrb.org"
        setFieldValue "#GeneralFirmInformation_FormOfOrganization" "Corporation"
        setFieldValue "#GeneralFirmInformation_OrgCity" "Alexandria"
        setFieldValue "#GeneralFirmInformation_OrgState" "VA"
        click "Continue"
        click "#BusinessActivities_Sections_0__BusinessActivitiesTypes_0__Selected"
        click "Continue"
        click "#BusinessActivities_Sections_1__BusinessActivitiesTypes_1__Selected"
        click "Continue"
        displayed "#BusinessActivities_Sections_2__BusinessActivitiesTypes_0__Selected"
        click "Continue"
        click "#addNewContact"
        setFieldValue "#ContactsModel_EditContact_FirstName" "Broker"
        setFieldValue "#ContactsModel_EditContact_LastName" "roker-Dealer"
        setFieldValue "#ContactsModel_EditContact_Title" "Title"
        setFieldValue "#ContactsModel_EditContact_EmailAddress" config.email
        setFieldValue "#ContactsModel_EditContact_EmailAddressConfirm" config.email
        setFieldValue "#ContactsModel_EditContact_AddressLine1" "1900 Duke Street"
        setFieldValue "#ContactsModel_EditContact_AddressLine2" "Suite 500"
        setFieldValue "#ContactsModel_EditContact_City" "Alexandria"
        setFieldValue "#ContactsModel_EditContact_State" "VA"
        setFieldValue "#ContactsModel_EditContact_Zip" "22314"
        setFieldValue "#ContactsModel_EditContact_PhoneAreaCode" "703"
        setFieldValue "#ContactsModel_EditContact_PhonePrefix" "797"
        setFieldValue "#ContactsModel_EditContact_PhoneNumber" "6600"
        setFieldValue "#ContactsModel_EditContact_PhoneExtension" "123"
        click "#saveContactButton"
        click "#addNewContact"
        setFieldValue "#ContactsModel_EditContact_FirstName" "User"
        setFieldValue "#ContactsModel_EditContact_LastName" "serB"
        setFieldValue "#ContactsModel_EditContact_Title" "Title_UserB"
        setFieldValue "#ContactsModel_EditContact_EmailAddress" config.email
        setFieldValue "#ContactsModel_EditContact_EmailAddressConfirm" config.email
        setFieldValue "#ContactsModel_EditContact_AddressLine1" "1900 Duke Street"
        setFieldValue "#ContactsModel_EditContact_AddressLine2" "Suite 500"
        setFieldValue "#ContactsModel_EditContact_City" "Alexandria"
        setFieldValue "#ContactsModel_EditContact_State" "VA"
        setFieldValue "#ContactsModel_EditContact_Zip" "22314"
        setFieldValue "#ContactsModel_EditContact_PhoneAreaCode" "703"
        setFieldValue "#ContactsModel_EditContact_PhonePrefix" "797"
        setFieldValue "#ContactsModel_EditContact_PhoneNumber" "6600"
        setFieldValue "#ContactsModel_EditContact_PhoneExtension" "123"
        click "#saveContactButton"
        setFieldValue "#ContactsModel_RequiredSeletedUser" "Broker roker-Dealer"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Master Account Administrator"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedUser" "User serB"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Primary Regulatory Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Billing Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Compliance Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Primary Data Quality Contact"
        click "#selectButton"
        click "Optional Contacts"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Regulatory Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Data Quality Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Technical Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        click "Continue"
        click "#ExemptFromTradeReportingFlag"
        waitFor (fun _ -> (element "#preview").Enabled = true)
        click "#preview"
        sleep 1.0
        click "#Certification"
        sleep 0.10
        click "#submitButton"
        assertDisplayed "Submission Confirmation"
        click "click here"
        lastMsrbId <- (read "div.pdfInfo div.hr li:nth-of-type(1)").Replace("MSRB ID: ", "")

    let brokerDealerApproval () =
        loginStaff ()
        waitFor (fun  _ -> (someElement "#stafftog").IsSome)
        click "#stafftog"
        click "#organizationAdministration"
        click "#dealerMALookup"
        describe "Staff searching for form to approve"
        setFieldValue "#MsrbId" lastMsrbId
        let t1 () =
            click "Search"
            sleep 3
            let e = (someElement "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a")
            e.IsSome && e.Value.Text = lastMsrbId
        extendTimeout (fun _ -> waitFor t1)
        click "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a"
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click "#approveFormA12"
        let t3 () =
            sleep 2.0
            someElement("MSRB Registration Report - Dealers and Municipal Advisors").IsSome
        extendTimeout (fun _ -> waitFor t3)
        assertUrl (gatewayUrl + "RegistrationManager/PSO/PSOSearch")
        click "Active/Withdrawn"
        describe "Staff searches for approved form"
        setFieldValue "#MsrbId" lastMsrbId
        let t2 () =
            click "Search"
            sleep 3.0
            let e = (someElement "#psoActiveSearchResults tr:nth-of-type(1) td:nth-of-type(1) a")
            e.IsSome && e.Value.Text = lastMsrbId
        extendTimeout (fun _ -> waitFor t2)
        click "#psoActiveSearchResults tr:nth-of-type(1) td:nth-of-type(1) a"
        assertEqual 4 (elements "Verified").Length
        logout ()

    let ChangeMasterAccountAdminToExistingUserByStaff () =
        loginStaff ()
        waitFor (fun  _ -> (someElement "#admintog").IsSome)
        click "#admintog"
        click "User Administration"
        click "Maintain existing users"
        setFieldValue "#msrbid" lastMsrbId
        click "Locate Account"
        click "table.main2 table:nth-of-type(2) tbody tr:nth-of-type(2) td:nth-of-type(2) a" 
        click "  Change Info.  "
        selected "#ACCTMASTER"
        click "Previous Page"
        click " Previous Page  "
        click "table.main2 table:nth-of-type(2) tbody tr:nth-of-type(3) td:nth-of-type(2) a"
        click "  Change Info.  "
        deselected "#ACCTMASTER"
        check "#ACCTMASTER"
        click "Update Account"
        click "Confirm Account"
        click "Return to Search"
        setFieldValue "#msrbid" lastMsrbId
        click "Locate Account"
        click "table.main2 table:nth-of-type(2) tbody tr:nth-of-type(2) td:nth-of-type(2) a" 
        click "  Change Info.  "
        deselected "#ACCTMASTER"
        click "Return to Menu"
        logout ()

    let ChangeMasterAccountAdminToNewUserCreatedByStaff () =
        loginStaff ()
        waitFor (fun  _ -> (someElement "#admintog").IsSome)
        click "#admintog"
        click "User Administration"
        click "Create new users"
        setFieldValue "#fname" "User"
        setFieldValue "#lname" "serC"
        setFieldValue "#email" "email@email.com"
        setFieldValue "#email2" "email@email.com"
        setFieldValue "#MSRBRegNo" lastMsrbId
        check "#ACCTMASTER"
        click "Create Account"
        click "Confirm Account"
        click "Account Menu"
        click "Maintain existing users"
        setFieldValue "#msrbid" lastMsrbId
        click "Locate Account"
        click "table.main2 table:nth-of-type(2) tbody tr:nth-of-type(3) td:nth-of-type(2) a"
        click "  Change Info.  "
        deselected "#ACCTMASTER"


    "Broker-Dealer Only Registration, PSO Approval and MAA Rights Management" &&& fun _ ->
        objective "Register a Broker-Dealer Only"
        objective "Staff approve registration"
        objective "Change Master Account Admin To Existing User By Staff"
        objective "Change Master Account Admin To New User Created By Staff"
        brokerDealerRegistration ()
        brokerDealerApproval ()
        ChangeMasterAccountAdminToExistingUserByStaff ()
        ChangeMasterAccountAdminToNewUserCreatedByStaff ()

//Municipal Advisor Only--------------------------------------------------------------------
    let municipalAdvisorOnlyRegistration () =
        url (gatewayUrl + "msrb1/control/registration/")
        click "#registrationTypeDealers"
        click "#nextButton"
        click "#Continue"
        click "#OrgRolePopup"
        setFieldValue "#OrgRole" "Municipal Advisor Only"
        click "#selectButton"
        click "Continue with Form A-12"  
        setFieldValue "#GeneralFirmInformation_FirmName" "test msrb Municipal Advisor Only"
        setFieldValue "#GeneralFirmInformation_CRDNumber" "999999999"
        setFieldValue "#GeneralFirmInformation_MuniAdvisorSecPrefix" "866"
        setFieldValue "#GeneralFirmInformation_MuniAdvisorSec1" (((System.Random()).Next(10000, 99999)).ToString("00"))
        setFieldValue "#GeneralFirmInformation_MuniAdvisorSec2" (((System.Random()).Next(10, 99)).ToString("00"))
        setFieldValue "#GeneralFirmInformation_LegalEntityIdentifier" "43534535345345435345"
        fileUploadSelectPdf "#registrationDoc"
        click "#uploadbutton"
        setFieldValue "#GeneralFirmInformation_CorpAddress1" "1900 Duke Street"
        setFieldValue "#GeneralFirmInformation_CorpAddress2" "Suite 500"
        setFieldValue "#GeneralFirmInformation_City" "Alexandria"
        setFieldValue "#GeneralFirmInformation_State" "VA"
        setFieldValue "#GeneralFirmInformation_Zip" "40602"
        setFieldValue "#GeneralFirmInformation_CorpWebsite" "www.msrb.org"
        setFieldValue "#GeneralFirmInformation_FormOfOrganization" "Corporation"
        setFieldValue "#GeneralFirmInformation_OrgCity" "Alexandria"
        setFieldValue "#GeneralFirmInformation_OrgState" "VA"
        click "Continue"
        click "#BusinessActivities_Sections_0__BusinessActivitiesTypes_0__Selected"
        click "Continue"
        click "#addNewContact"
        setFieldValue "#ContactsModel_EditContact_FirstName" "Muni"
        setFieldValue "#ContactsModel_EditContact_LastName" "uni-Advisor"
        setFieldValue "#ContactsModel_EditContact_Title" "testTitle"
        setFieldValue "#ContactsModel_EditContact_EmailAddress" config.email
        setFieldValue "#ContactsModel_EditContact_EmailAddressConfirm" config.email
        setFieldValue "#ContactsModel_EditContact_AddressLine1" "1900 Duke Street"
        setFieldValue "#ContactsModel_EditContact_AddressLine2" "Suite 500"
        setFieldValue "#ContactsModel_EditContact_City" "Alexandria"
        setFieldValue "#ContactsModel_EditContact_State" "VA"
        setFieldValue "#ContactsModel_EditContact_Zip" "22314"
        setFieldValue "#ContactsModel_EditContact_PhoneAreaCode" "703"
        setFieldValue "#ContactsModel_EditContact_PhonePrefix" "797"
        setFieldValue "#ContactsModel_EditContact_PhoneNumber" "6600"
        setFieldValue "#ContactsModel_EditContact_PhoneExtension" "123"
        click "#saveContactButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Master Account Administrator"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Primary Regulatory Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Billing Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Compliance Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Primary Data Quality Contact"
        click "#selectButton"
        click "Optional Contacts"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Regulatory Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Data Quality Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Technical Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        click "Continue"
        sleep 1.0
        click "#Certification"
        sleep 0.10
        click "#submitButton"
        assertDisplayed "Submission Confirmation"
        click "click here"
        lastMsrbId <- (read "div.pdfInfo div.hr li:nth-of-type(1)").Replace("MSRB ID: ", "")
        Console.WriteLine("MSRB ID: = " + lastMsrbId)
        
    "Municipal Advisor Only Registration and PSO Approval" &&& fun _ ->
        objective "Register a Municipal Advisor Only complete through PSO Approval"
        municipalAdvisorOnlyRegistration ()
        loginStaff ()
        waitFor (fun  _ -> (someElement "#stafftog").IsSome)
        click "#stafftog"
        click "#organizationAdministration"
        click "#dealerMALookup"
        describe "Staff searching for form to approve"
        setFieldValue "#MsrbId" lastMsrbId
        let t1 () =
            click "Search"
            sleep 2
            let e = (someElement "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a")
            e.IsSome && e.Value.Text = lastMsrbId
        extendTimeout (fun _ -> waitFor t1)
        click "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a"
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click "input[id='approveFormA12']"
        let t3 () =
            sleep 2.0
            someElement("MSRB Registration Report - Dealers and Municipal Advisors").IsSome
        extendTimeout (fun _ -> waitFor t3)
        assertUrl (gatewayUrl + "RegistrationManager/PSO/PSOSearch")
        click "Active/Withdrawn"
        describe "Staff searches for approved form"
        setFieldValue "#MsrbId" lastMsrbId
        let t2 () =
            click "Search"
            sleep 2
            let e = (someElement "#psoActiveSearchResults tr:nth-of-type(1) td:nth-of-type(1) a")
            e.IsSome && e.Value.Text = lastMsrbId
        extendTimeout (fun _ -> waitFor t2)
        click "#psoActiveSearchResults tr:nth-of-type(1) td:nth-of-type(1) a"
        assertEqual 3 (elements "Verified").Length
        logout ()

//Municipal Securities Dealer BankDealer--------------------------------------------------------------------
    let municipalSecuritiesDealer_BankDealerRegistration () =
        url (gatewayUrl + "msrb1/control/registration/")
        click "input[id='registrationTypeDealers']"
        click "#nextButton"
        click "#Continue"
        click "#OrgRolePopup"
        setFieldValue "#OrgRole" "Municipal Securities Dealer (Bank Dealer)"
        click "#selectButton"
        click "Continue with Form A-12"  
        setFieldValue "#GeneralFirmInformation_FirmName" "test msrb Municipal Securities Dealer BankDealer"
        setFieldValue "#GeneralFirmInformation_CRDNumber" "999999999"
        setFieldValue "#GeneralFirmInformation_BrokerDealerSec" (((System.Random()).Next(10000, 99999)).ToString("00"))
        setFieldValue "#GeneralFirmInformation_LegalEntityIdentifier" "43534535345345435345"
        fileUploadSelectPdf "#registrationDoc"
        click "#uploadbutton"
        setFieldValue "#GeneralFirmInformation_CorpAddress1" "1900 Duke Street"
        setFieldValue "#GeneralFirmInformation_CorpAddress2" "Suite 500"
        setFieldValue "#GeneralFirmInformation_City" "Alexandria"
        setFieldValue "#GeneralFirmInformation_State" "VA"
        setFieldValue "#GeneralFirmInformation_Zip" "40602"
        setFieldValue "#GeneralFirmInformation_CorpWebsite" "www.msrb.org"
        setFieldValue "#GeneralFirmInformation_FormOfOrganization" "Corporation"
        setFieldValue "#GeneralFirmInformation_OrgCity" "Alexandria"
        setFieldValue "#GeneralFirmInformation_OrgState" "VA"
        click "Continue"
        click "#BusinessActivities_Sections_0__BusinessActivitiesTypes_0__Selected"
        click "Continue"
        click "#BusinessActivities_Sections_1__BusinessActivitiesTypes_1__Selected"
        click "Continue"
        displayed "#BusinessActivities_Sections_2__BusinessActivitiesTypes_0__Selected"
        click "Continue"
        click "#addNewContact"
        setFieldValue "#ContactsModel_EditContact_FirstName" "Bank"
        setFieldValue "#ContactsModel_EditContact_LastName" "ank-Dealer"
        setFieldValue "#ContactsModel_EditContact_Title" "test"
        setFieldValue "#ContactsModel_EditContact_EmailAddress" config.email
        setFieldValue "#ContactsModel_EditContact_EmailAddressConfirm" config.email
        setFieldValue "#ContactsModel_EditContact_AddressLine1" "1900 Duke Street"
        setFieldValue "#ContactsModel_EditContact_AddressLine2" "Suite 500"
        setFieldValue "#ContactsModel_EditContact_City" "Alexandria"
        setFieldValue "#ContactsModel_EditContact_State" "VA"
        setFieldValue "#ContactsModel_EditContact_Zip" "22314"
        setFieldValue "#ContactsModel_EditContact_PhoneAreaCode" "703"
        setFieldValue "#ContactsModel_EditContact_PhonePrefix" "797"
        setFieldValue "#ContactsModel_EditContact_PhoneNumber" "6600"
        setFieldValue "#ContactsModel_EditContact_PhoneExtension" "123"
        click "#saveContactButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Master Account Administrator"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Primary Regulatory Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Billing Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Compliance Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Primary Data Quality Contact"
        click "#selectButton"
        click "Optional Contacts"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Regulatory Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Data Quality Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Technical Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        click "Continue"
        click "#ExemptFromTradeReportingFlag"
        click "Continue"
        click "Continue"
        sleep 1.0
        click "#Certification"
        sleep 0.10
        click "#submitButton"
        assertDisplayed "Submission Confirmation"
        click "click here"
        lastMsrbId <- (read "div.pdfInfo div.hr li:nth-of-type(1)").Replace("MSRB ID: ", "")

    "Municipal Securities Dealer BankDealer Registration and PSO Approval" &&& fun _ ->
        objective "Register a Municipal Securities Dealer BankDealer complete through PSO Approval"
        municipalSecuritiesDealer_BankDealerRegistration ()
        loginStaff ()
        waitFor (fun  _ -> (someElement "#stafftog").IsSome)
        click "#stafftog"
        click "#organizationAdministration"
        click "#dealerMALookup"
        setFieldValue "#MsrbId" lastMsrbId
        describe "Staff searching for form to approve"
        let t1 () =
            click "Search"
            sleep 2
            let e = (someElement "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a")
            e.IsSome && e.Value.Text = lastMsrbId
        extendTimeout (fun _ -> waitFor t1)
        click "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a"
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click "input[id='approveFormA12']"
        let t3 () =
            sleep 2.0
            someElement("MSRB Registration Report - Dealers and Municipal Advisors").IsSome
        extendTimeout (fun _ -> waitFor t3)
        assertUrl (gatewayUrl + "RegistrationManager/PSO/PSOSearch")
        click "Active/Withdrawn"
        describe "Staff searches for approved form"        
        setFieldValue "#MsrbId" lastMsrbId
        let t2 () =
            click "Search"
            sleep 2
            let e = (someElement "#psoActiveSearchResults tr:nth-of-type(1) td:nth-of-type(1) a")
            e.IsSome && e.Value.Text = lastMsrbId
        extendTimeout (fun _ -> waitFor t2)
        click "#psoActiveSearchResults tr:nth-of-type(1) td:nth-of-type(1) a"
        assertEqual 4 (elements "Verified").Length

//Municipal Securities Dealer and Munimipal Advisor Registration and PSO Approval--------------------------------------------------------------------
    let municipalSecuritiesDealer_municipalAdvisorRegistration () =
        url (gatewayUrl + "msrb1/control/registration/")
        click "input[id='registrationTypeDealers']"
        click "#nextButton"
        click "#Continue"
        click "#OrgRolePopup"
        setFieldValue "#OrgRole" "Municipal Securities Dealer (Bank Dealer)"
        click "#selectButton"
        click "Continue with Form A-12"  
        setFieldValue "#GeneralFirmInformation_FirmName" "test msrb Municipal Securities Dealer and Munimipal Advisor Registration and PSO Approval"
        setFieldValue "#GeneralFirmInformation_CRDNumber" "999999999"
        setFieldValue "#GeneralFirmInformation_BrokerDealerSec" (((System.Random()).Next(10000, 99999)).ToString("00"))
        setFieldValue "#GeneralFirmInformation_LegalEntityIdentifier" "43534535345345435345"
        fileUploadSelectPdf "#registrationDoc"
        click "#uploadbutton"
        setFieldValue "#GeneralFirmInformation_CorpAddress1" "1900 Duke Street"
        setFieldValue "#GeneralFirmInformation_CorpAddress2" "Suite 500"
        setFieldValue "#GeneralFirmInformation_City" "Alexandria"
        setFieldValue "#GeneralFirmInformation_State" "VA"
        setFieldValue "#GeneralFirmInformation_Zip" "40602"
        setFieldValue "#GeneralFirmInformation_CorpWebsite" "www.msrb.org"
        setFieldValue "#GeneralFirmInformation_FormOfOrganization" "Corporation"
        setFieldValue "#GeneralFirmInformation_OrgCity" "Alexandria"
        setFieldValue "#GeneralFirmInformation_OrgState" "VA"
        click "Continue"
        click "#BusinessActivities_Sections_0__BusinessActivitiesTypes_0__Selected"
        click "Continue"
        click "#BusinessActivities_Sections_1__BusinessActivitiesTypes_1__Selected"
        click "Continue"
        displayed "#BusinessActivities_Sections_2__BusinessActivitiesTypes_0__Selected"
        click "Continue"
        click "#addNewContact"
        setFieldValue "#ContactsModel_EditContact_FirstName" "Muni"
        setFieldValue "#ContactsModel_EditContact_LastName" "uni-Securities-Dealer"
        setFieldValue "#ContactsModel_EditContact_Title" "Title"
        setFieldValue "#ContactsModel_EditContact_EmailAddress" config.email
        setFieldValue "#ContactsModel_EditContact_EmailAddressConfirm" config.email
        setFieldValue "#ContactsModel_EditContact_AddressLine1" "1900 Duke Street"
        setFieldValue "#ContactsModel_EditContact_AddressLine2" "Suite 500"
        setFieldValue "#ContactsModel_EditContact_City" "Alexandria"
        setFieldValue "#ContactsModel_EditContact_State" "VA"
        setFieldValue "#ContactsModel_EditContact_Zip" "22314"
        setFieldValue "#ContactsModel_EditContact_PhoneAreaCode" "703"
        setFieldValue "#ContactsModel_EditContact_PhonePrefix" "797"
        setFieldValue "#ContactsModel_EditContact_PhoneNumber" "6600"
        setFieldValue "#ContactsModel_EditContact_PhoneExtension" "123"
        click "#saveContactButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Master Account Administrator"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Primary Regulatory Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Billing Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Compliance Contact"
        click "#selectButton"
        setFieldValue "#ContactsModel_RequiredSeletedRole" "Primary Data Quality Contact"
        click "#selectButton"
        click "Optional Contacts"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Regulatory Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Data Quality Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        setFieldValue "#ContactsModel_OptionalSelectedRole" "Optional Technical Contact"
        click "#AssignOptionalContact > ul > li > #selectButton"
        click "Continue"
        click "#ExemptFromTradeReportingFlag"
        click "Continue"
        click "Continue"
        sleep 1.0
        click "#Certification"
        sleep 0.10
        click "#submitButton"
        assertDisplayed "Submission Confirmation"
        click "click here"
        lastMsrbId <- (read "div.pdfInfo div.hr li:nth-of-type(1)").Replace("MSRB ID: ", "")

    "Municipal Securities Dealer and Munimipal Advisor Registration and PSO Approval" &&& fun _ ->
        objective "Register a Municipal Securities Dealer and Municipal Advisor complete through PSO Approval"
        municipalSecuritiesDealer_municipalAdvisorRegistration ()
        loginStaff ()
        waitFor (fun  _ -> (someElement "#stafftog").IsSome)
        click "#stafftog"
        click "#organizationAdministration"
        click "#dealerMALookup"
        setFieldValue "#MsrbId" lastMsrbId
        describe "Staff searching for form to approve"
        let t1 () =
            click "Search"
            sleep 2
            let e = (someElement "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a")
            e.IsSome && e.Value.Text = lastMsrbId
        extendTimeout (fun _ -> waitFor t1)
        click "#psoSearchResults tr:nth-of-type(1) td:nth-of-type(1) a"
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click ((elements "Approve").[0])
        waitForAjax ()
        click "input[id='approveFormA12']"
        let t3 () =
            sleep 2.0
            someElement("MSRB Registration Report - Dealers and Municipal Advisors").IsSome
        extendTimeout (fun _ -> waitFor t3)
        assertUrl (gatewayUrl + "RegistrationManager/PSO/PSOSearch")
        click "Active/Withdrawn"
        describe "Staff searches for approved form"        
        setFieldValue "#MsrbId" lastMsrbId
        let t2 () =
            click "Search"
            sleep 2
            let e = (someElement "#psoActiveSearchResults tr:nth-of-type(1) td:nth-of-type(1) a")
            e.IsSome && e.Value.Text = lastMsrbId
        extendTimeout (fun _ -> waitFor t2)
        click "#psoActiveSearchResults tr:nth-of-type(1) td:nth-of-type(1) a"
        assertEqual 4 (elements "Verified").Length




