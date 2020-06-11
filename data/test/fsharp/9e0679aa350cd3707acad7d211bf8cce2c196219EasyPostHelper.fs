module EasyPostHelper

open EasyPost

let setApiKey key = EasyPost.Client.apiKey <- key
let setApiBase baseUrl = EasyPost.Client.apiBase <- baseUrl
let url = ""
let testKey = ""


let getRates = 
    setApiKey testKey
    setApiBase url

    let fromAddress = Address(
        company = "",
        street1 = "",
        street2 = "",
        city = "",
        state = "",
        zip = "",
        phone = "",
        residential = false
    )

    let toAddress = Address(
        company = "",
        street1 = "",
        street2 = "",
        city = "",
        state = "",
        zip = "",
        phone = "",
        residential = false
    )

    let parcel = 
        ["length", box 1.; "width", box 1.; "height", box 2.; "weight", box 2.]
        |> dict
        |> Parcel.Create

    let options = System.Collections.Generic.Dictionary(dict [("date_advance", box 3)])

    Shipment(to_address = toAddress, from_address = fromAddress, parcel = parcel, options=options, return_address = fromAddress)
