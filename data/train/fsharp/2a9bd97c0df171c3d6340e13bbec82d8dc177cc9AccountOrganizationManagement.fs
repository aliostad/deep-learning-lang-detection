module AccountOrganizationManagement
open canopy
open runner
open etconfig   
open lib
open gwlib
open System

let core _ = 
    context "Account Organization Management"

    "Manage User Accounts - Add / Remove Right" &&& fun _ ->
        objective "Master Account Administrator can remove righs and re-instates rights"
        precondition "Account Access Rights (Agency is selected) followed by deselect and re-select steps"
        postcondition "Account Access Rights (Agency is selected)"
        loginGateway ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#ManageUserAccounts"
        assertFieldContains "span.heading" "User Accounts"
        click "a[href='accountView.asp?userId=MASTERUSER']"
        selected "#AGENCY"
        click "Edit User Account"
        uncheck "#AGENCY"
        click "Continue"
        click "Confirm User Account"
        click "Return to Accounts"
        click "a[href='accountView.asp?userId=MASTERUSER']"
        deselected "#AGENCY"
        click "Edit User Account"
        check "#AGENCY"
        click "Continue"
        click "Confirm User Account"
        click "Return to Accounts"
        click "a[href='accountView.asp?userId=MASTERUSER']"
        selected "#AGENCY"         
        assertFieldContains "span.heading" "User Account Profile and Access Rights"

    "Organization Administrator - View Account Administrators" &&& fun _ ->
        objective "Administrator can View Account Administrators"
        loginGateway ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        url (gatewayUrl + "msrb1/control/CompanyManagement/accountAdministrators.asp")
        assertFieldContains "span.heading" "Account Administrators"

    "User - View Account Administrators" &&& fun _ ->
        objective "User can View Account Administrators"
        loginDealer ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        url (gatewayUrl + "msrb1/control/CompanyManagement/accountAdministrators.asp")
        assertFieldContains "span.heading" "Account Administrators"

    "Manage User Accounts - Organization Administrator - View Account Profile History" &&& fun _ ->
        objective "Organization Administrator - View Account Profile History"
        loginGateway ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#ManageUserAccounts"
        assertFieldContains "span.heading" "User Accounts"
        setFieldValue "input[name='lName']" "TESTER"
        click "Search"
        click "a[href='accountView.asp?userId=MASTERUSER']"
        assertFieldContains "span.heading" "User Account Profile and Access Rights"
        click "input[value='View Profile History']"
        assertFieldContains "span.heading" "User Account Profile History"

    "Manage User Accounts - Organization Administrator - View Account Rights History" &&& fun _ ->
        objective "Organization Administrator - View Account Rights History"
        loginGateway ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#ManageUserAccounts"
        assertFieldContains "span.heading" "User Accounts"
        setFieldValue "input[name='lName']" "TESTER"
        click "Search"
        click "a[href='accountView.asp?userId=MASTERUSER']"
        assertFieldContains "span.heading" "User Account Profile and Access Rights"
        click "input[value='View Rights History']"
        assertFieldContains "span.heading" "User Account Access Rights History"

    "Manage Groups - Add Group Path A" &&& fun _ ->
        objective "Add a new group via Use Accounts - Edit Groups - Add New Group"
        loginGateway ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        url (gatewayUrl + "msrb1/control/CompanyManagement/groups/groupList.asp")
        assertFieldContains "span.heading" "Groups |"
        click "User Account List"
        assertFieldContains "span.heading" "User Accounts"
        click "Edit Groups"
        click "Add New Group"
        assertFieldContains "span.heading" "Groups"
        let groupName = ("Group Name" + (getRandomNumberString 7))
        setFieldValue "input[name=groupName]" groupName   
        click "input[type=Submit]" // Save Changes
        assertFieldContains "span.heading" "Groups - Confirmation"
        assertFieldContains "span.infoText" "You have added Group"

    "Manage Groups - Add Group Path B" &&& fun _ ->
        loginGateway ()
        url (gatewayUrl + "msrb1/control/CompanyManagement/groups/groupList.asp")
        assertFieldContains "span.heading" "Groups |"
        click "Add New Group"
        let groupName = ("Group Name" + (getRandomNumberString 7))
        setFieldValue "input[name=groupName]" groupName   
        click "input[type=Submit]"
        assertFieldContains "span.heading" "Groups - Confirmation"
        assertFieldContains "span.infoText" "You have added Group"

    "Manage Groups - Edit Group" &&& fun _ ->
        loginGateway ()
        url (gatewayUrl + "msrb1/control/CompanyManagement/groups/groupList.asp")
        assertFieldContains "span.heading" "Groups |"
        click ((elements "input[value='Edit']").Item(0))
        let groupName = ("Group Name" + (getRandomNumberString 7))
        setFieldValue "input[name=groupName]" groupName   
        click "input[type=Submit]"
        assertFieldContains "span.heading" "Groups - Confirmation"
        assertFieldContains "span.infoText" "You have updated Group"

    "Manage Groups - View User Accounts" &&& fun _ ->
        loginGateway ()
        url (gatewayUrl + "msrb1/control/CompanyManagement/groups/groupList.asp")
        contains "Groups |" (read "span.heading")
        click "View User Accounts"
        contains "User Accounts" (read "span.heading")

    "Manage Groups - Delete Group" &&& fun _ ->
        url (gatewayUrl + "msrb1/control/CompanyManagement/groups/groupList.asp")
        assertFieldContains "span.heading" "Groups |"
        click ((elements "input[value='Delete']").Item(0))
        dismissAlert ()

    "Manage Consolidations - Invite" &&& fun _ ->
        loginConfIssuer ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        url (gatewayUrl + "msrb1/control/dispatch.asp?target=ManageConsolidations")
        assertFieldContains "h2" "Consolidation Requests"
        setFieldValue "#SearchParameters_MSRBID" "D001110001"
        click "Search"
        assertFieldContains "#inviteForm" "Search Results"
        click "Invite"
        click "Cancel"
        assertFieldContains "#inviteForm" "Search Results"
        logoutGateway ()
                
    "Add / Remove Roles for Continuing Disclosure Service - DealerMAA" &&& fun _ ->
        loginDealerMAA ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        url (gatewayUrl + "msrb1/control/registration/cod/userRoles.asp")
        assertFieldContains "span.heading" "Add / Remove Roles"
        check "input[name='ISSUER']"
        click "Next"
        assertFieldContains "span.heading" "Confirmation"
        logoutGateway ()

    "How to Get Confirmed as a Continuing Disclosure Submitter - Confirmation Overview" &&& fun _ ->
        loginUnConfIssuer ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "a[href='/msrb1/control/ConfirmationOverview.pdf']" //How to get confirmed?
        logoutGateway ()



        
 
     




                

                  


 

    


