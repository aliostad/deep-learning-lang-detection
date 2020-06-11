namespace BookMate.Integration.Tests

module YandexTests = 
    open Xunit
    open FsUnit.Xunit
    open System.Reflection
    open System.IO

    open BookMate.Integration.Tests.YandexMocks
    open BookMate.Integration.Yandex
    open BookMate.Integration.YandexHelper
    
    let dictionaryApiResponseJson = lazy(
        Path.Combine(System.IO.Directory.GetCurrentDirectory(), "exampleDictionaryResponse.json")
        |> File.ReadAllText
    )

    let translateApiResponseJson = """ {"code":200,"lang":"en-ru","text":["предварительные"]} """

    [<Fact>]
    let ``Serialized JSON DictionaryAPI response should match expected example`` () =
      let readJson = dictionaryApiResponseJson.Value
      
      let expected = expectedDictionaryResponse
      let actual = deserializeJsonDictionaryResponse readJson
      
      expected.def = actual.def |> should be True

    [<Fact>]
    let ``'Part of speech - translation' pairs should be successfully extracted from Yandex DictionaryAPI response`` () = 
        let jsonFetcherMock = fun (_:string) -> async { return (dictionaryApiResponseJson.Value, 200) }
        let jsonReaderMock = fun (_:string) -> expectedDictionaryResponse
        let apiEndpoint = "127.0.0.1"
        let apiKey = "123456789"
        let words = "test, test2, test3"

        let expected = 
          [| ("noun", "время"); ("noun", "час"); ("noun", "эпоха"); ("noun", "век"); ("noun", "такт"); ("noun", "жизнь") 
             ("verb", "приурочивать"); ("verb", "рассчитывать"); ("adjective", "временный"); ("adjective", "повременный") |]

        let actual = 
          askYandexDictionary (jsonFetcherMock) (jsonReaderMock) apiEndpoint apiKey words
          |> Async.RunSynchronously
        
        actual = expected |> should be True
      
    [<Fact>]
    let ``Serialized JSON TranslateAPI response should match expected example`` () =
      let readJson = translateApiResponseJson

      let expected = {
        code = 200
        lang = "en-ru"
        text = [| "предварительные" |]
      }
      let actual = deserializeJsonTranslateResponse readJson
      
      expected = actual |> should be True
    
    [<Theory>]
    [<InlineData("предварительные");InlineData("");InlineData("   ")>]
    let ``Translations should be successfully extracted from Yandex TranslateAPI response`` (translation : string) = 
        let model = {
          code = 200
          lang = "en-ru"
          text = [| translation |]
        }
        let apiEndpoint = "127.0.0.1"
        let apiKey = "123456789"
        let word = "test"
        let jsonFetcherMock = fun (_:string) -> async { return (translateApiResponseJson,200) }
        let jsonReaderMock = fun (_:string) -> model
        let expected = [| translation.Trim() |]

        let actual = askYandexTranslate jsonFetcherMock jsonReaderMock apiEndpoint apiKey word |> Async.RunSynchronously |> Option.get
        
        actual = expected |> should be True

    [<Fact>]
    let ``Exceeding day limits should cause return of None`` () =
      let model = {
          code = 401
          lang = "en-ru"
          text = [|""|]
        }
      let apiEndpoint = "127.0.0.1"
      let apiKey = "123456789"
      let word = "test"
      let jsonFetcherMock = fun (_:string) -> async { return (translateApiResponseJson,200) }
      let jsonReaderMock = fun (_:string) -> model
      let expected = None
      let actual = askYandexTranslate jsonFetcherMock jsonReaderMock apiEndpoint apiKey word |> Async.RunSynchronously 

      actual = expected |> should be True
      