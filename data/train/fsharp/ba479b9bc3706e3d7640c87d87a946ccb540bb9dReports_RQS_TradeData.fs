module Reports_RQS_TradeData
open canopy
open runner
open etconfig   
open lib
open gwlib
open System

let core _ = 
    context "Regulatory Query System Reports - Trade Data"
    once (fun _ -> loginRegulator ())
    lastly (fun _ -> logoutGateway ())

    if config.regWebV2 = true then
        "RQS-All Trades by One Dealer (Q1)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RedirectToQueryReports']"
            click "All Trades by One Dealer (Q1)"
            setFieldValue "#MsrbId" "A0278"
            setFieldValue "#BeginDate" "01/01/2010"
            setFieldValue "#EndDate" "06/01/2010"
            click "Continue"
            let t1 () =
                sleep 2.0
                someElement("Regulator Query System — All Trades by One Dealer (Q1)").IsSome
            extendTimeout (fun _ -> waitFor t1)
            assertFieldContains "h2" "Regulator Query System — All Trades by One Dealer (Q1)"

        "RQS-All Trades in One CUSIP by One Dealer (Q2)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RedirectToQueryReports']"
            click "All Trades in One CUSIP by One Dealer (Q2)"
            setFieldValue "#BeginDate" "01/01/2012"
            setFieldValue "#EndDate" "01/02/2012"
            setFieldValue "#Cusip" "71883REC3"
            setFieldValue "#MsrbId" "A6907"
            click "Continue"
            let t2 () =
                sleep 2.0
                someElement("Regulator Query System — All Trades in One CUSIP by One Dealer (Q2)").IsSome
            extendTimeout (fun _ -> waitFor t2)
            assertFieldContains "h2" "Regulator Query System — All Trades in One CUSIP by One Dealer (Q2)"

        "For Multiple CUSIPs, All Trades by Dealers (Q6)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RedirectToQueryReports']"
            click "For Multiple CUSIPs, All Trades by Dealers (Q6)"
            setFieldValue "#BeginDate" "01/01/2012"
            setFieldValue "#EndDate" "06/30/2012"
            setFieldValue "#CusipsRawString" "016066BH4"
            click "Submit"
            assertDisplayed "Regulator Query System — Request Submitted"

        "All Trades by All Dealers in Issues with Coupon Exceeding x% (Q8)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RedirectToQueryReports']"
            click "All Trades by All Dealers in Issues with Coupon Exceeding x% (Q8)"
            setFieldValue "#BeginDate" "01/01/2012"
            setFieldValue "#EndDate" "01/01/2012"
            setFieldValue "#Coupon" "7.5"
            click "Submit"
            assertDisplayed "Regulator Query System — Request Submitted"

        "All Interdealer Trades by One Clearing Broker (Q11)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RedirectToQueryReports']"
            click "All Interdealer Trades by One Clearing Broker (Q11)"
            setFieldValue "#BeginDate" "01/01/2012"
            setFieldValue "#EndDate" "01/01/2012"
            setFieldValue "#ClearingId" "ABC"
            click "Submit"
            assertDisplayed "Regulator Query System — Request Submitted"

        "All Interdealer Trades by Multiple Clearing Brokers and Executing Dealers (Q12)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RedirectToQueryReports']"
            click "All Interdealer Trades by Multiple Clearing Brokers and Executing Dealers (Q12)"
            setFieldValue "#BeginDate" "01/01/2012"
            setFieldValue "#EndDate" "01/01/2012"
            setFieldValue "input[name=ClearingIds]" "ABC"
            setFieldValue "input[name=Ebses]" "ABC"
            click "Submit"
            assertDisplayed "Regulator Query System — Request Submitted"

        "All Trades by All Dealers Above Specified Spread (Q10)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RedirectToQueryReports']"
            click "All Trades by All Dealers Above Specified Spread (Q10)"
            setFieldValue "#BeginDate" "01/01/2012"
            setFieldValue "#EndDate" "01/01/2012"
            setFieldValue "#Spread" "101"
            click "Submit"
            assertDisplayed "Regulator Query System — Request Submitted"

        "All Trades by One Dealer Above Specified Spread (Q14)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RedirectToQueryReports']"
            click "All Trades by One Dealer Above Specified Spread (Q14)"
            setFieldValue "#BeginDate" "01/01/2012"
            setFieldValue "#EndDate" "01/01/2012"
            setFieldValue "#Spread" "101"
            setFieldValue "#CompanyName" "Securities"
            click "Continue"
            click "table.tdata tbody tr:nth-of-type(1) input[type=radio]"
            click "Continue"
            click "Continue"
            assertDisplayed "Regulator Query System — Request Submitted"

        "Regulator can not see Staff-Administration Tab" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "a[href='/msrb1/control/send.asp?target=REGWEB&auth=1']"
            click "a[href='/Regulator/RegWeb/RedirectToQueryReports']"
            assertNotDisplayed "#tabs-4"



    if config.regWebV2 = false then
        "RQS-All Trades by One Dealer (Q1)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "All Enforcement Agencies"
            click "Regulator Query System"
            click "All Trades by One Dealer (Q1)"
            setFieldValue "#MsrbId" "A0278"
            setFieldValue "#BeginDate" "01/01/2010"
            setFieldValue "#EndDate" "06/01/2010"
            click "Continue"
            let t1 () =
                sleep 2.0
                someElement("Regulator Query System — All Trades by One Dealer (Q1)").IsSome
            extendTimeout (fun _ -> waitFor t1)
            assertFieldContains "h2" "Regulator Query System — All Trades by One Dealer (Q1)"

        "RQS-All Trades in One CUSIP by One Dealer (Q2)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "All Enforcement Agencies"
            click "Regulator Query System"
            click "All Trades in One CUSIP by One Dealer (Q2)"
            setFieldValue "#BeginDate" "01/01/2012"
            setFieldValue "#EndDate" "01/02/2012"
            setFieldValue "#Cusip" "71883REC3"
            setFieldValue "#MsrbId" "A6907"
            click "Continue"
            let t2 () =
                sleep 2.0
                someElement("Regulator Query System — All Trades in One CUSIP by One Dealer (Q2)").IsSome
            extendTimeout (fun _ -> waitFor t2)
            assertFieldContains "h2" "Regulator Query System — All Trades in One CUSIP by One Dealer (Q2)"

        "For Multiple CUSIPs, All Trades by Dealers (Q6)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "All Enforcement Agencies"
            click "Regulator Query System"
            click "For Multiple CUSIPs, All Trades by Dealers (Q6)"
            setFieldValue "#BeginDate" "01/01/2012"
            setFieldValue "#EndDate" "06/30/2012"
            setFieldValue "#CusipsRawString" "016066BH4"
            click "Submit"
            assertDisplayed "Regulator Query System — Request Submitted"

        "All Trades by All Dealers in Issues with Coupon Exceeding x% (Q8)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "All Enforcement Agencies"
            click "Regulator Query System"
            click "All Trades by All Dealers in Issues with Coupon Exceeding x% (Q8)"
            setFieldValue "#BeginDate" "01/01/2012"
            setFieldValue "#EndDate" "01/01/2012"
            setFieldValue "#Coupon" "7.5"
            click "Submit"
            assertDisplayed "Regulator Query System — Request Submitted"

        "All Interdealer Trades by One Clearing Broker (Q11)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "All Enforcement Agencies"
            click "Regulator Query System"
            click "All Interdealer Trades by One Clearing Broker (Q11)"
            setFieldValue "#BeginDate" "01/01/2012"
            setFieldValue "#EndDate" "01/01/2012"
            setFieldValue "#ClearingId" "ABC"
            click "Submit"
            assertDisplayed "Regulator Query System — Request Submitted"

        "All Interdealer Trades by Multiple Clearing Brokers and Executing Dealers (Q12)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "All Enforcement Agencies"
            click "Regulator Query System"
            click "All Interdealer Trades by Multiple Clearing Brokers and Executing Dealers (Q12)"
            setFieldValue "#BeginDate" "01/01/2012"
            setFieldValue "#EndDate" "01/01/2012"
            setFieldValue "input[name=ClearingIds]" "ABC"
            setFieldValue "input[name=Ebses]" "ABC"
            click "Submit"
            assertDisplayed "Regulator Query System — Request Submitted"

        "All Trades by All Dealers Above Specified Spread (Q10)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "All Enforcement Agencies"
            click "Regulator Query System"
            click "All Trades by All Dealers Above Specified Spread (Q10)"
            setFieldValue "#BeginDate" "01/01/2012"
            setFieldValue "#EndDate" "01/01/2012"
            setFieldValue "#Spread" "101"
            click "Submit"
            assertDisplayed "Regulator Query System — Request Submitted"

        "All Trades by One Dealer Above Specified Spread (Q14)" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "All Enforcement Agencies"
            click "Regulator Query System"
            click "All Trades by One Dealer Above Specified Spread (Q14)"
            setFieldValue "#BeginDate" "01/01/2012"
            setFieldValue "#EndDate" "01/01/2012"
            setFieldValue "#Spread" "101"
            setFieldValue "#CompanyName" "Securities"
            click "Continue"
            click "table.tdata tbody tr:nth-of-type(1) input[type=radio]"
            click "Continue"
            click "Continue"
            assertDisplayed "Regulator Query System — Request Submitted"

        "Regulator can not see Staff-Administration Tab" &&& fun _ ->
            url (gatewayUrl + "msrb1/control/selection.asp")
            click "All Enforcement Agencies"
            click "Regulator Query System"
            assertNotDisplayed "#tabs-4"



