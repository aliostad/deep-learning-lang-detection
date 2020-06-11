module FormA12RegistrationMisc
open canopy
open runner
open etconfig
open lib

let core _ = 
    context "FORM-A12 Registration Miscellaneous"
    
    "A12 Validation - Registration Firm Name length and special characters" &&& fun _ ->
        objective "Firm Name is limited to 100 characters and contains no special characters"
        url (gatewayUrl + "msrb1/control/registration/")
        click "input[id='registrationTypeDealers']"
        click "#nextButton"
        click "#Continue"
        click "#OrgRolePopup"
        setFieldValue "#OrgRole" "Broker-Dealer and Municipal Advisor"
        click "#selectButton"
        click "Continue with Form A-12"  
        setFieldValue "#GeneralFirmInformation_FirmName" "2kshgosiy03 0-9=-24t9jmm vbjp'[awot8=-3284=-68jp'lsdgs9=923465=0439634086=-32434673790 ffjg;dsjfhp[2k"
        setFieldValue "#GeneralFirmInformation_BrokerDealerSec" "99999"
        setFieldValue "#GeneralFirmInformation_CRDNumber" "999999999"
        setFieldValue "#GeneralFirmInformation_MuniAdvisorSecPrefix" "866"
        setFieldValue "#GeneralFirmInformation_MuniAdvisorSec1" (((System.Random()).Next(10000, 99999)).ToString("00"))
        setFieldValue "#GeneralFirmInformation_MuniAdvisorSec2" (((System.Random()).Next(10, 99)).ToString("00"))
        setFieldValue "#GeneralFirmInformation_LegalEntityIdentifier" "43534535345345435345"
        fileUploadSelectPdf "#registrationDoc"
        click "#uploadbutton"
        assertDisplayed "Firm Name is invalid."
        setFieldValue "#GeneralFirmInformation_FirmName" "dfghasidfgkghakdhgsfisdagfsda707502375023578jhsafklsdhafklsadhflskad0-2570-27527hsaklfghsadlifhsadlkh"
        fileUploadSelectPdf "#registrationDoc"
        click "#uploadbutton"
        assertDisplayed "Firm Name is too long."
        setFieldValue "#GeneralFirmInformation_FirmName" ".';[p[]   ."
        fileUploadSelectPdf "#registrationDoc"
        click "#uploadbutton"
        assertDisplayed "Firm Name is invalid."
