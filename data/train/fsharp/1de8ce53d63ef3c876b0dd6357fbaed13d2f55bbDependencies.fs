// $begin{copyright}
//
// This file is confidential and proprietary.
//
// Copyright (c) IntelliFactory, 2004-2010.
//
// All rights reserved.  Reproduction or use in whole or in part is
// prohibited without the written consent of the copyright holder.
//-----------------------------------------------------------------
// $end{copyright}
namespace WebSharper.Google.Visualization

module Dependencies =
    open System
    open System.Configuration
    open System.IO
    open WebSharper
    module R = WebSharper.Resources
    module CR = WebSharper.Core.Resources

    /// Requires the Google JS API.
    [<Sealed>]
    type JsApi() =
        inherit R.BaseResource("https://www.google.com/jsapi")
    //    interface R.IResource with
    //        member this.Render ctx html =
    //            let src =
    //                String.concat "" [
    //                    defaultArg (ctx.GetSetting "Google.JsAPI")
    //                        "http://www.google.com/jsapi"
    //                    "?key="
    //                    defaultArg (ctx.GetSetting "google.jsapi.key")
    //                        "your-key-here"
    //                ]
    //            html.AddAttribute("type", "text/javascript")
    //            html.AddAttribute("src", src)
    //            html.RenderBeginTag "script"
    //            html.RenderEndTag()

    let private render (html: System.Web.UI.HtmlTextWriter) (code: string) =
        html.AddAttribute("type", "text/javascript")
        html.RenderBeginTag "script"
        html.WriteLine code
        html.RenderEndTag()

    [<Sealed>]
    type Visualization() =
        interface R.IResource with
#if ZAFIR
            member this.Render ctx =
                fun html -> render (html CR.Scripts) "google.load('visualization', '1');"
#else
            member this.Render ctx html =
                render (html CR.Scripts) "google.load('visualization', '1');"
#endif

    [<AbstractClass>]
    type BaseResourceDefinition(package: string) =
        interface R.IResource with
#if ZAFIR
            member this.Render ctx =
                let code =
                    String.Format("google.load(\"visualization\",\
                        \"1\", {{packages:[\"{0}\"]}});", package)
                fun html -> render (html CR.Scripts) code
#else
            member this.Render ctx html =
                String.Format("google.load(\"visualization\",\
                    \"1\", {{packages:[\"{0}\"]}});", package)
                |> render (html CR.Scripts)
#endif

    type internal B = BaseResourceDefinition

    [<Require(typeof<JsApi>)>]
    type Table() =
        inherit B("table")

    [<Require(typeof<JsApi>)>]
    type Timeline() =
        inherit B("timeline")

    [<Require(typeof<JsApi>)>]
    type AreaChart() =
        inherit B("corechart")

    [<Require(typeof<JsApi>)>]
    type Gauge() =
        inherit B("gauge")

    [<Require(typeof<JsApi>)>]
    type CoreChart() =
        inherit B("corechart")

    [<Require(typeof<JsApi>)>]
    type GeoChart() =
        inherit B("geochart")

    [<Require(typeof<JsApi>)>]
    type IntensityMap() =
        inherit B("intensitymap")

    [<Require(typeof<JsApi>)>]
    type MotionChart() =
        inherit B("motionchart")

    [<Require(typeof<JsApi>)>]
    type OrgChart() =
        inherit B("orgchart")

    [<Require(typeof<JsApi>)>]
    type TreeMap() =
        inherit B("treemap")

    [<assembly:Require(typeof<JsApi>)>]
    do ()
