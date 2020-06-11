module LatestCurrencyExchangeRates

open FSharp.Data
open FinantilaMathematics.Currency

let latestRateApi symbols =
    let str =
        ("http://api.fixer.io/latest?symbols=" + symbols) |> Http.RequestString
    1M

let latestRate ((c1:Currency), (c2:Currency)) =
    let key = (c1|>currencyString) + "," + (c2|>currencyString)
    latestRateApi key

let latestRate' ((c1:Currency), (c2:Currency)) = c1, c2, (latestRate <| (c1,c2))

let rateToUsdTable currency : ExchanegRate =
    match currency with
    | Usd -> Usd, Usd, 1M
    | Eur -> latestRate' <| (Eur, Usd)
    | Gbp -> latestRate' <| (Gbp, Usd)
    | Pln -> latestRate' <| (Pln, Usd)
    | Ypy -> latestRate' <| (Ypy, Usd)
