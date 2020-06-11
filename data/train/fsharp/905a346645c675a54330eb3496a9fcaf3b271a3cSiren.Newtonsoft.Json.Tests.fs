module Siren.NewtonsoftJson.Tests

open Expecto
open System

open Hypermedia
open Siren
open Newtonsoft.Json

[<Tests>]
let ``Siren`` =
    let itmes = {
        Link.create (Rel "http://x.io/rels/order-items") (Href (Uri "http://api.x.io/orders/42/items")) with
            classes = [ Class "collection"; Class "items" ]
    }

    let customer = {
        Entity.empty with
            classes = [ Class "customer"; Class "info" ]
            properties = Map.ofList [ Name "customerId", JString "pj123"
                                      Name "name", JString "Peter Joseph" ]
            links = [ Link.create (Rel "self") (Href (Uri "http://api.x.io/customers/pj123")) ]
    }

    let addItem = {
        Action.create (Href (Uri "http://api.x.io/orders/42/items")) with
            title = Some (Title "Add Item")
            httpMethod = Some HttpMethod.POST
            mediaType = Some (MediaType "application/x-www-form-urlencoded")
            fields = Map.ofList [ Name "orderNumber", { Field.empty with inputType = Some InputType.Hidden; value = Some (Value "42") }
                                  Name "productCode", { Field.empty with inputType = Some InputType.Text }
                                  Name "quantity", { Field.empty with inputType = Some InputType.Number } ]
    }

    let actions = 
        Map.ofList
            [ Name "add-item", addItem ]

    let entity = {
        Entity.empty with
            properties = Map.ofList [ Name "orderNumber", JObject (42 :> obj)
                                      Name "itemCount", JObject (3 :> obj)
                                      Name "status", JString "pending" ]
            classes = [ Class "order" ]
            entities = [ EmbeddedRepresentation (customer, (Rel "http://x.io/rels/customer"))
                         EmbeddedLink itmes ]
            actions = actions
            links = [ Link.create (Rel "self") (Href (Uri "http://api.x.io/orders/42"))
                      Link.create (Rel "previous") (Href (Uri "http://api.x.io/orders/41"))
                      Link.create (Rel "next") (Href (Uri "http://api.x.io/orders/43")) ]
    }

    testList "siren tests" [
        testCase "correctly serialize a siren resource with newtonsoft.json" <| fun _ ->
            Expect.equal 
                (entity |> ObjectInterpreter.Siren.toJson |> JsonConvert.SerializeObject)
                """{"actions":[{"fields":[{"name":"orderNumber","type":"hidden","value":"42"},{"name":"productCode","type":"text"},{"name":"quantity","type":"number"}],"href":"http://api.x.io/orders/42/items","method":"POST","name":"add-item","title":"Add Item","type":"application/x-www-form-urlencoded"}],"class":["order"],"entities":[{"class":["customer","info"],"links":[{"href":"http://api.x.io/customers/pj123","rel":["self"]}],"properties":{"customerId":"pj123","name":"Peter Joseph"},"rel":["http://x.io/rels/customer"]},{"class":["collection","items"],"href":"http://api.x.io/orders/42/items","rel":["http://x.io/rels/order-items"]}],"links":[{"href":"http://api.x.io/orders/42","rel":["self"]},{"href":"http://api.x.io/orders/41","rel":["previous"]},{"href":"http://api.x.io/orders/43","rel":["next"]}],"properties":{"itemCount":3,"orderNumber":42,"status":"pending"}}"""
                "should return create link with href attribute" 
  ]



