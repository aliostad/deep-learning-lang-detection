module AgentRelationshipManagement
open canopy
open runner
open etconfig   
open lib
open gwlib
open System

let core _ = 
    context "Agent Relationship Management"

    "Designate an organization to act as your agent/ Organizations you have requested to act as your agent" &&& fun _ ->
        loginConfIssuer ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "Manage Agent Relationships"
        click "Designate an organization to act as your agent"                  //Designate an organization to act as your agent
        setFieldValue "#search" "A9995"
        click "#SearchButton"
        click "#A9995"
        click "#UpdateDesignationSubmissionTypesButton"              //UpdateDesignationSubmissionTypesButton
        check "input[value='EMMASM']"
        click "Add Submission Type"
        assertDisplayed ("Modifications successfully processed")
        click "Return to Agent Menu"
        click "Organizations you have requested to act as your agent: (1)"      //Organizations you have requested to act as your agent: (1)
        assertUrl (gatewayUrl + "msrb1/control/CompanyManagement/AgentRelationships/PendingAgentInvitations.asp")
        click "A9995"
        check "input[value='EMMASM']"
        click "Remove Relationship"
        assertDisplayed ("Modifications successfully processed")
        assertDisplayed ("-- No submission types authorized --")    
        click "Return to Agent Menu"
        logout ()

    "Designate an organization to act as your agent - UpdateAgentSubmissionTypes" &&& fun _ ->
        loginConfIssuer ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "#manageAgentRelationships"
        click "Designate an organization to act as your agent"                  //Designate an organization to act as your agent
        assertUrl (gatewayUrl + "msrb1/control/CompanyManagement/AgentRelationships/OrgLookup.asp?id=1")
        setFieldValue "#search" "A9995"    
        click "#SearchButton"
        click "#A9995" 
        assertFieldContains "span.headingMain" "Relationship with Abner, Herrman & Brock, LLC:"
        click "#UpdateAgentSubmissionTypesButton"           //UpdateAgentSubmissionTypesButton
        check  "input[value='G45']"      
        click "Add Submission Type"
        assertDisplayed ("Modifications successfully processed")
        check  "input[value='G45']"  
        click "Remove Relationship"
        click "Confirm" 
        assertDisplayed ("Modifications successfully processed")
        assertDisplayed ("-- No current agent relationship with this organization --")
        logout ()

    "Offer to serve as an agent for another organization/ Organizations for which you have offered to act as an agent" &&& fun _ ->
        loginConfIssuer ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "Manage Agent Relationships"
        click "Offer to serve as an agent for another organization" 
        assertUrl (gatewayUrl + "msrb1/control/CompanyManagement/AgentRelationships/OrgLookup.asp?id=1")
        setFieldValue "#search" "A9995"
        click "#SearchButton"
        click "#A9995"
        click "#UpdateAgentSubmissionTypesButton"
        check  "input[value='G45']" 
        click "Add Submission Type"
        assertDisplayed ("Modifications successfully processed")
        click "Return to Agent Menu"
        click "Organizations for which you have offered to act as an agent: (1)"
        click "A9995"
        check  "input[value='G45']" 
        click "Remove Relationship"
        click "Confirm"
        assertDisplayed ("Modifications successfully processed")
        assertDisplayed ("-- No current agent relationship with this organization --")
        logout ()

    "Unconfirmed Issuer should not have agent designation" &&& fun _ ->
        loginUnConfIssuer ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click  "#acctmgtlnk"
        click "Manage Agent Relationships"
        assertDisplayed "Offer to serve as an agent for another organization"
        assertNotDisplayed "Designate an organization to act as your agent"
        logout ()

    "Formal Issuer should have agent designation" &&& fun _ ->
        loginFormalIssuer ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "Manage Agent Relationships"
        assertDisplayed "Offer to serve as an agent for another organization"
        assertDisplayed "Designate an organization to act as your agent"
        click "Designate an organization to act as your agent"
        setFieldValue "#search" "A9995"
        click "#SearchButton"
        click "#A9995"
        click "#UpdateDesignationSubmissionTypesButton"
        assertDisplayed ("EMMA - Continuing Disclosure")
        assertDisplayed ("EMMA Voluntary Financial Information")
        assertDisplayed ("EMMA Voluntary OS/ARD Submission")
        assertDisplayed ("EMMA Voluntary Preliminary OS Submission")
        assertDisplayed ("-- No submission types authorized --")
        logout ()

    "Dealer MAA should have agent designation" &&& fun _ ->
        loginDealerMAA ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "Manage Agent Relationships"
        click "Designate an organization to act as your agent"
        setFieldValue "#search" "A24090001"
        click "#SearchButton"
        click "#A24090001"
        click "#UpdateAgentSubmissionTypesButton"
        assertDisplayed ("EMMA - Continuing Disclosure")
        assertDisplayed ("RTRS - Trade Data")
        logout ()

    "Formal Org NonMAA user should not have agent designation" &&& fun _ ->
        loginDealer ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        assertNotDisplayed "Manage Agent Relationships"
        logout ()

        //The following pair of test are a communication between a Dealer and a Confirmed Issuer to set up an agent relationship
    "Offer to serve as an agent for another organization" &&& fun _ ->
        loginDealerMAA ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "Manage Agent Relationships"
        click "#ServeAsAgent"                          //Offer to serve as an agent for another organization
        setFieldValue "#search" "A24090001"
        click "#SearchButton"
        click "#A24090001"
        click "#UpdateAgentSubmissionTypesButton"
        check "input[value='EMMASM']"
        click "input[value='Add Submission Type']"
        logout ()

    "Organizations offering to act as your agent /Active relationships" &&& fun _ ->
        loginConfIssuer ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "Manage Agent Relationships"
        click "a[href='PendingAgentRequests.asp']"              //Organizations offering to act as your agent
        click "a[href='EditPrincipal.asp?msrbid=A9995']"
        check "input[value='EMMASM']"
        click "Approve Relationship"
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "Manage Agent Relationships"
        click "a[href='ActiveAgents.asp']"                      //Active relationships
        click "a[href='OrgDetails.asp?msrbid=A9995']"
        click "#UpdateDesignationSubmissionTypesButton"
        check "input[value='EMMASM']"
        click "Remove Relationship"
        assertDisplayed ("Modifications successfully processed")
        logout ()

        //The following pair of test are a communication between a Confirmed Issuer and a Dealer to set up an agent relationship
    "Designate an organization to act as your agent" &&& fun _ ->
        loginConfIssuer ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "Manage Agent Relationships"
        click "#AgentDesignation"                       //Designate an organization to act as your agent
        setFieldValue "#search" "A9995"
        click "#SearchButton"
        click "#A9995"
        click "#UpdateDesignationSubmissionTypesButton" // Update Submission Types
        check "input[value='EMMASM']"
        click "Add Submission Type"
        logout ()

    "Organizations requesting that you act as their agent/ Active Relationships" &&& fun _ ->
        loginDealerMAA ()
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "Manage Agent Relationships"
        click "a[href='PendingPrincipalInvitations.asp']" //Organizations requesting that you act as their agent
        click "a[href='EditAgent.asp?msrbid=A24090001']"
        check "input[value='EMMASM']"
        click "Approve Relationship"
        url (gatewayUrl + "msrb1/control/selection.asp")
        click "Manage Agent Relationships"
        click "a[href='ActivePrincipals.asp']"           //Active Relationships
        click "a[href='OrgDetails.asp?msrbid=A24090001']"
        click "#UpdateAgentSubmissionTypesButton"
        check "input[value='EMMASM']"
        click "Remove Relationship"
        click "Confirm"
        assertDisplayed ("Modifications successfully processed")
        logout ()