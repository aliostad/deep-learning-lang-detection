namespace WPFApp

open System
open System.Text
open System.Text.RegularExpressions
open System.Windows

open FSharp.Data

open FsXaml
open ViewModule
open ViewModule.FSharp
open ViewModule.Validation.FSharp

module MarketMonitorModelFunctions =             
    open System.Windows.Forms
    open System.Windows.Controls

    // public market crest url
    // https://crest-tq.eveonline.com/market/10000002/orders/sell/?type=https://crest-tq.eveonline.com/inventory/types/17888/

    // api market orders
    // https://api.eveonline.com/corp/MarketOrders.xml.aspx?keyID=6087058&vCode=aQ7vRp0jmlsGYaTgmByv4I4A1ns8GU0kJtuk7uQeShJhhaympQk0AWfuoIrauc4K&characterID=96868921

    ()


open MarketMonitorModelFunctions
type MarketMonitorViewModel () as this = 
    inherit ViewModelBase()

    let processMenu x = ()
    let mutable inputHtml = ""    
    let processMenuHtml = 
        this.Factory.CommandSync (fun x -> 
            let page = FunEve.Utility.HttpTools.loadWithEmptyResponse @"https://www.leafly.com/dispensary-info/nectar-3/menu" ""
            page.ToString() |> processMenu)


    member this.InputHtml 
        with get () = inputHtml
        and set (value) = inputHtml <- value

    member this.ProcessMenu = processMenuHtml
    