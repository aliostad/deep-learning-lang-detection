namespace BookMate.Core

module Configuration = 
    open System.IO
    open Newtonsoft.Json
    open System.Reflection
    open Newtonsoft.Json.Linq
    
    type ApplicationConfiguration = {
        YandexTranslateApiEndPoint: string
        YandexTranslateApiKey: string
        YandexDictionaryApiEndPoint: string
        YandexDictionaryApiKey: string
        DBConnectionString: string
        UserDefinedWordsFilePath: string
        StanfordTaggerFilePath: string
        StanfordTaggerEndpoint: string
    }

    let applicationJsonActual = @"appconfiguration.json"
    let private readJsonConfigurationFromFile jsonFileName  = 
        Path.Combine(System.IO.Path.GetDirectoryName(Assembly.GetEntryAssembly().Location), jsonFileName)
        |> File.ReadAllText

    let (|IsValidJson|NotValidJson|) (str:string) =
        try
            JContainer.Parse(str) |> ignore
            IsValidJson
        with
        | _ -> NotValidJson

    let loadConfigurationFromJsonText jsonText = 
        match jsonText with
        | null -> invalidArg "jsonText" "Can't load application configuration from null string"
        | IsValidJson -> JsonConvert.DeserializeObject<ApplicationConfiguration>(jsonText)
        | NotValidJson -> 
            let txt = sprintf "Provided string is not a valid json: %s" jsonText
            invalidArg "jsonText" txt

    let private applicationConfiguration =  lazy(
        applicationJsonActual 
        |> readJsonConfigurationFromFile
        |> loadConfigurationFromJsonText)

    let public getApplicationConfiguration () = applicationConfiguration.Value
    let public getYandexTranslateApiEndPoint() = getApplicationConfiguration().YandexTranslateApiEndPoint
    let public getYandexTranslateApiKey() = getApplicationConfiguration().YandexTranslateApiKey
    let public getYandexDictionaryApiEndPoint() = getApplicationConfiguration().YandexDictionaryApiEndPoint
    let public getYandexDictionaryApiKey() = getApplicationConfiguration().YandexDictionaryApiKey
    let public getDBConnectionString() = getApplicationConfiguration().DBConnectionString |> System.IO.Path.GetFullPath
    let public getUserDefinedWordsFilePath() = getApplicationConfiguration().UserDefinedWordsFilePath
    let public getStanfordTaggerFilePath () = getApplicationConfiguration().StanfordTaggerFilePath

    let public getStanfordTaggerEndpoint () = getApplicationConfiguration().StanfordTaggerEndpoint