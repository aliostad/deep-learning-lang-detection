namespace BookMate.Core.Tests

module ConfigurationTests = 
    open Xunit
    open FsUnit.Xunit
    open BookMate.Core.Configuration

    let expectedConfiguration () : ApplicationConfiguration = 
        {
            YandexTranslateApiEndPoint="YandexTranslateApiEndPoint"
            YandexTranslateApiKey="YandexTranslateApiKey"
            YandexDictionaryApiEndPoint="YandexDictionaryApiEndPoint"
            YandexDictionaryApiKey="YandexDictionaryApiKey"
            DBConnectionString="DBConnectionString"
            UserDefinedWordsFilePath="UserDefinedWordsFilePath"
            StanfordTaggerFilePath = "StanfordTaggerFilePath"
            StanfordTaggerEndpoint = "StanfordTaggerEndpoint"
        }

    [<Fact>]
    let ``Read configuration from JSON text should be equal to expected`` () = 
        let jsonToTest = """ 
            {
                "YandexTranslateApiEndPoint": "YandexTranslateApiEndPoint",
                "YandexTranslateApiKey": "YandexTranslateApiKey",
                "YandexDictionaryApiEndPoint": "YandexDictionaryApiEndPoint",
                "YandexDictionaryApiKey": "YandexDictionaryApiKey",
                "DBConnectionString": "DBConnectionString",
                "UserDefinedWordsFilePath": "UserDefinedWordsFilePath",
                "StanfordTaggerFilePath": "StanfordTaggerFilePath",
                "StanfordTaggerEndpoint": "StanfordTaggerEndpoint"
            }
        """
        let actualConfiguration = loadConfigurationFromJsonText jsonToTest

        expectedConfiguration() = actualConfiguration |> should be True

    [<Fact>]
    let ``Read configuration from partially correct JSON text should not be equal to expected `` () = 
        let jsonToTest = """ 
            {
                "YandexTranslateApiEndPoint": "YandexTranslateApiEndPoint",
                "YandexTranslateApiKey": "YandexTranslateApiKey"
            }
        """
        let actualConfiguration = loadConfigurationFromJsonText jsonToTest

        expectedConfiguration() = actualConfiguration |> should be False


    [<Theory()>]
    [<InlineData(null);InlineData("");InlineData("     ")>]
    let ``Non-valid json strings should not qualify as valid application configuration `` (jsonText:string) =
        (fun () -> loadConfigurationFromJsonText jsonText |> ignore) |> should throw typeof<System.ArgumentException>