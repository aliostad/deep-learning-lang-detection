module TryAppServiceAnalytics.Path

type IntPath = PrintfFormat<(int -> string), unit, string, string, int>

let home = "/"

module Analytics =
    let kpi = "/api/kpis"
    let appCreates = "/api/appCreates"
    let appCreatesFreeTrialClicks = "/api/appCreatesFreeTrialClicks"
    let accountTypes = "/api/accountTypes"
    let accountsTypesFreeTrialClicks = "/api/accountTypesFreeTrialClicks"
    let referrersCatagories = "/api/referrersCatagories"
    let templates = "/api/templates"
    let experiments = "/api/experiments"
    let experimentResults = "/api/experimentResult"
    let sourceVariations = "/api/sourceVariations"
    let sourceVariationResults = "/api/sourceVariationResult"
    let userFeedback = "/api/userFeedback"
    let mobileTemplates = "/api/mobileTemplates"
    let mobileClientUsage = "/api/mobileClientUsage"

module Info =
    let dbConnection = "/api/dbconnection"