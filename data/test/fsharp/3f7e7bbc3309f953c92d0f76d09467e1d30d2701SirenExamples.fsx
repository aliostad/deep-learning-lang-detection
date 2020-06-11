#load "paket-files/include-scripts/net40/include.fsharp.data.fsx"
#load "src/Hypermedia/Hypermedia.fs"
#load "src/Hypermedia/FsharpDataInterpreter.fs"

open System
open Hypermedia
open Siren
open FSharp.Data

let itemsLink = 
    Link.create (Rel "http://x.io/rels/order-items") (Href (Uri "http://api.x.io/orders/42/items"))
    |> Link.withClasses [ "collection"; "items" ]

let customer =
    Entity.empty
    |> Entity.withClasses [ "customer"; "info" ]
    |> Entity.addProperty "customerId" (JsonValue.String "pj123")
    |> Entity.addProperty "name" (JsonValue.String "Peter Joseph")
    |> Entity.withLinks [ Link.create (Rel "self") (Href (Uri "http://api.x.io/customers/pj123")) ]

let addItemAction = {
    Action.create (Href (Uri "http://api.x.io/orders/42/items")) with
        title = Some (Title "Add Item")
        httpMethod = Some HttpMethod.POST
        mediaType = Some (MediaType "application/x-www-form-urlencoded")
        fields = Map.ofList [ Name "orderNumber", { Field.empty with inputType = Some InputType.Hidden; value = Some (Value "42") }
                              Name "productCode", { Field.empty with inputType = Some InputType.Text }
                              Name "quantity", { Field.empty with inputType = Some InputType.Number } ]
}

let entity =
    Entity.empty
    |> Entity.addProperty "orderNumber" (JsonValue.Number 42m)
    |> Entity.addProperty "itemCount" (JsonValue.Number 3m)
    |> Entity.addProperty "status" (JsonValue.String "pending")
    |> Entity.withClasses [ "order" ]       
    |> Entity.addEmbeddedLink itemsLink
    |> Entity.addEmbeddedEntity customer "http://x.io/rels/customer"
    |> Entity.withActions [ "", addItemAction ] 
    |> Entity.withLinks [ Link.create (Rel "self") (Href (Uri "http://api.x.io/orders/42"))
                          Link.create (Rel "previous") (Href (Uri "http://api.x.io/orders/41"))
                          Link.create (Rel "next") (Href (Uri "http://api.x.io/orders/43")) ]

FSharpDataIntepreter.Siren.toJSon entity
|> fun x -> x.ToString()
|> printfn "%A"

(*
    {
  "actions": [
    {
      "fields": [
        {
          "name": "orderNumber",
          "type": "hidden",
          "value": "42"
        },
        {
          "name": "productCode",
          "type": "text"
        },
        {
          "name": "quantity",
          "type": "number"
        }
      ],
      "href": "http://api.x.io/orders/42/items",
      "method": "POST",
      "name": "",
      "title": "Add Item",
      "type": "application/x-www-form-urlencoded"
    }
  ],
  "class": [
    "order"
  ],
  "entities": [
    {
      "class": [
        "customer",
        "info"
      ],
      "links": [
        {
          "href": "http://api.x.io/customers/pj123",
          "rel": [
            "self"
          ]
        }
      ],
      "properties": {
        "customerId": "pj123",
        "name": "Peter Joseph"
      },
      "rel": [
        "http://x.io/rels/customer"
      ]
    },
    {
      "class": [
        "collection",
        "items"
      ],
      "href": "http://api.x.io/orders/42/items",
      "rel": [
        "http://x.io/rels/order-items"
      ]
    }
  ],
  "links": [
    {
      "href": "http://api.x.io/orders/42",
      "rel": [
        "self"
      ]
    },
    {
      "href": "http://api.x.io/orders/41",
      "rel": [
        "previous"
      ]
    },
    {
      "href": "http://api.x.io/orders/43",
      "rel": [
        "next"
      ]
    }
  ],
  "properties": {
    "itemCount": 3,
    "orderNumber": 42,
    "status": "pending"
  }
}
*)