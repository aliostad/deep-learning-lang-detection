#light

namespace Comet.Chating

open Comet
open System
open System.Collections.Generic
open System.Web
open System.Web.Script.Serialization

type ReceiveHandler() =

    let mutable m_context = null
    let mutable m_endWork = null

    interface IHttpAsyncHandler with
        member h.IsReusable = false
        member h.ProcessRequest(context) = failwith "not supported"

        member h.BeginProcessRequest(c, cb, state) =
            m_context <- c

            let name = c.Request.QueryString.Item("name")
            let receive = Chat.receive name
            let beginWork, e, _ = Async.AsBeginEnd receive
            m_endWork <- new Func<_, _>(e)

            beginWork (cb, state)

        member h.EndProcessRequest(ar) =
            let convert (m: Chat.ChatMsg) =
                let o = new Dictionary<_, _>();
                o.Add("from", m.From)
                o.Add("text", m.Text)
                o

            let result = m_endWork.Invoke ar
            let serializer = new JavaScriptSerializer()
            result
            |> List.map convert
            |> serializer.Serialize
            |> m_context.Response.Write