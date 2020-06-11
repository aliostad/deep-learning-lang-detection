namespace YieldMap.Tools.Settings

[<AutoOpen>]
module Settings =

    // todo ORM mapping or XML mapping or whatever mapping
    type QuoteSettings = {
        midIfBoth : bool
    }

    type LoggingSettings = {
        fileName : string
    }

    type SourceSettings = {
        defaultFeed : string
    }

    type ApiSettings = {
        port : int
    }

    type Settings = {
        logging : LoggingSettings
        quotes : QuoteSettings
        source : SourceSettings
        api : ApiSettings
    }

    let globalSettings = ref {
        logging = {fileName = "yield-map.log"}
        quotes = {midIfBoth = true}
        source = {defaultFeed = "IDN"}
        api = {port = 8089}
    }