/// our RabbitMQ correlated object model reside here

namespace FSharp.Control.RabbitMQ

open System
open System.IO
open System.Text
open System.Reflection
open System.Collections
open System.Collections.Generic
open RabbitMQ.Client
open FSharp.Control.RabbitMQ
open FSharp.Control.X_FSharp

exception UnknownKey of string
exception EmptyRoutingKey of string

module Const =
  let direct = "direct"
  let fanout = "fanout"
  let topic = "topic"
  let header = "headers"

  let msgpack = "msgpack" 
  let protobuf = "protobuf"
  let json = "json" 
  let headers = "headers" 
  let csv = "csv" 
  let jsv = "jsv" 

  // INTERESTING: https://developers.google.com/protocol-buffers/docs/reference/cpp/google.protobuf.text_format
  // http://tools.ietf.org/html/rfc6648

  let msgPackMime = "application/x-msgpack"
  let protobufMime = "application/x-protobuf"
  let JSONmime = "application/json"
  let CSVmime = "text/csv"
  let JSVmime = "text/jsv"

  let EmptyString = ""
  let RAW = "raw"
  let UTF_7 = "utf-7"
  let UTF_8 = "utf-8"
  let UTF_16 = "utf-16"
  let UTF_32 = "utf-32"
  let NoEncoding = "NoEncoding"
  let GZip = "gzip"

  let NoMatchType = "no-match-type"
  let MatchAny = "any"
  let MatchAll = "all"

open System.Runtime.CompilerServices

[<Extension>]
type X_DateTime() =

  static let unixEpoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)

  [<Extension>]
  static member toTime_t_s (dt:DateTime) = 
    int64 (dt - unixEpoch).TotalSeconds

  [<Extension>]
  static member toTime_t_ms (dt:DateTime) = 
    int64 (dt - unixEpoch).TotalMilliseconds

  [<Extension>]
  static member fromTime_t_s (i:Int64) = 
    unixEpoch.AddSeconds(float i)

  [<Extension>]
  static member fromTime_t_ms (i:Int64) = 
    unixEpoch.AddMilliseconds(float i)

exception UnrecognisedExchangeType of string
exception UnrecognisedEncodingType of string
exception UnrecognisedContentType of string

/// nme: Exchange Type
/// dsc: Rabbit MQ has different exchange types ranging from simple to complex.
/// see: http://www.rabbitmq.com/tutorials/amqp-concepts.html
type ExchangeType =
  /// brief: binding=(ex,k,mq).  Multiple bindings are Possible.  
  /// 
  /// dsc: A queue gets messages that are routed to a routing pattern that matches the queue name.  Exchange->Queue binding is automatic
  /// A direct exchange delivers messages to queues based on the message routing key. A direct exchange is ideal for the unicast routing of messages (although they can be used for multicast routing as well). Here is how it works:
  ///
  /// A queue binds to the exchange with a routing key K
  /// When a new message with routing key R arrives at the direct exchange, the exchange routes it to the queue if K = R
  /// Direct exchanges are often used to distribute tasks between multiple workers (instances of the same application) in a round robin manner. When doing so, it is important to understand that, in AMQP 0-9-1, messages are load balanced between consumers and not between queues.
  | Direct
  /// dsc: Broadcast to all subscripbed queues and ignore the routing key that is supplied when binding a queue to an exchange.  
  ///
  /// A fanout exchange routes messages to all of the queues that are bound to it and the routing key is ignored. If N queues are bound to a fanout exchange, when a new message is published to that exchange a copy of the message is delivered to all N queues. Fanout exchanges are ideal for the broadcast routing of messages.
  ///
  /// Because a fanout exchange delivers a copy of a message to every queue bound to it, its use cases are quite similar:
  ///
  /// Massively multi-player online (MMO) games can use it for leaderboard updates or other global events
  /// Sport news sites can use fanout exchanges for distributing score updates to mobile clients in near real-time
  /// Distributed systems can broadcast various state and configuration updates
  /// Group chats can distribute messages between participants using a fanout exchange (although AMQP does not have a built-in concept of presence, so XMPP may be a better choice)
  | Fanout
  /// dsc: Messages sent to a topic exchange can't have an arbitrary routing_key - it must be a list of words, delimited by dots. The words can be anything, but usually they specify some features connected to the message. A few valid routing key examples: "stock.usd.nyse", "nyse.vmw", "quick.orange.rabbit". There can be as many words in the routing key as you like, up to the limit of 255 bytes.
  /// * (star) can substitute for exactly one word. # (hash) can substitute for zero or more words.
  | Topic
  /// dsc: we define a set of key-value pairs and push these into a headers field.  We publish with these and also subscribe with a "spec" of these
  /// ref: http://lostechies.com/derekgreer/2012/05/29/rabbitmq-for-windows-headers-exchanges
  | Headers
  static member fromString (x:string) = 
    match x with
    | "direct" -> Direct
    | "fanout" -> Fanout
    | "topic" -> Topic
    | "headers" -> Headers
    | _ -> raise<|UnrecognisedExchangeType(sprintf "unrecognised exchange type '%s'" x)
  member public this.toString() = 
    match this with
    | Direct -> Const.direct
    | Fanout -> Const.fanout
    | Topic -> Const.topic
    | Headers -> Const.header

/// dsc: message compression type (if used)
type EncodingType = 
  | NoEncoding
  | GZip
  static member fromString x = 
    match x with
    | ""
    | "NoEncoding"
    | null -> NoEncoding
    | "gzip" -> GZip
    | _ -> raise<|UnrecognisedEncodingType(sprintf "'%s' is not a recognised encoding type" x)
  member this.toString = 
    match this with
    | GZip -> Const.GZip
    | NoEncoding -> Const.NoEncoding

/// dsc: the type of headers exchange matching
type MatchType = 
  | NoMatchType
  | MatchAny
  | MatchAll
  static member fromString x = 
    match x with
    | ""
    | null 
    | "no-match-type" -> NoMatchType
    | "any" -> MatchAny
    | "all" -> MatchAll
    | _ -> raise<|UnrecognisedEncodingType(sprintf "'%s' is not a recognised encoding type" x)
  member this.toString = 
    match this with
    | NoMatchType -> Const.NoMatchType
    | MatchAny -> Const.MatchAny
    | MatchAll -> Const.MatchAll

/// dsc: different character set definitions for text based message formats
type CharsetType = 
  | NoCharset
  | RAW
  | UTF_7
  | UTF_8
  | UTF_16
  | UTF_32
  member this.toString = 
    match this with
    | NoCharset -> Const.EmptyString
    | RAW -> Const.RAW
    | UTF_7 -> Const.UTF_7
    | UTF_8 -> Const.UTF_8
    | UTF_16 -> Const.UTF_16
    | UTF_32 -> Const.UTF_32
  static member fromString x = 
    match x with
    | "raw" -> RAW
    | "utf-7" -> UTF_7
    | "utf-8" -> UTF_8
    | "utf-16" -> UTF_16
    | "utf-32" -> UTF_32
    | _ -> NoCharset
  
  /// if x is NoCharset, use y
  static member merge x y =
    x|>(function | NoCharset -> y | x->x)

/// dsc: mime definitions for message content formats
type ContentType = 
  | NoContentType
  | MsgPack
  | ProtoBuf
  | JSON
  | CSV
  | JSV
  // | TODO: include fspickler
  static member isTextBased (ct:ContentType) =
    match ct with
    | JSON 
    | CSV
    | JSV -> true
    | _ -> false
  member this.toString = 
    match this with
    | NoContentType -> Const.EmptyString
    | MsgPack -> Const.msgpack
    | ProtoBuf -> Const.protobuf
    | JSON -> Const.json
    | CSV -> Const.csv
    | JSV -> Const.jsv
  static member fromMime (x:string) = 
    match x with
    | null 
    | "" -> NoContentType
    | "application/x-msgpack" -> MsgPack 
    | "application/x-protobuf" -> ProtoBuf
    | "application/json" -> JSON
    | "text/csv" -> CSV
    | "text/jsv" -> JSV
    | _ -> raise<|UnrecognisedContentType(sprintf "unrecognised content type '%s'" x)
  member this.toMime = 
    match this with
    | NoContentType -> Const.EmptyString
    | MsgPack -> Const.msgPackMime
    | ProtoBuf -> Const.protobufMime
    | JSON -> Const.JSONmime
    | CSV -> Const.CSVmime
    | JSV -> Const.JSVmime

/// dsc: constants for the key portion of the XPair extension
module XPairConst =
  let c_X_AlternateExchange = "alternate-exchange"
  let c_X_PerMsgTTL = "x-message-ttl"
  let c_X_PerQueueMsgTTL = "x-message-ttl"
  let c_X_QueueTTL = "x-expires"
  let c_X_DeadLetterExchange = "x-dead-letter-exchange"
  let c_X_DeadLetterExchangeRoutingKey = "x-dead-letter-exchange-routing-key"
  let c_X_MaxLength = "x-max-length"
  let c_X_UserId = "user-id"
  let c_X_TrustUserId = "trust-user-id"
  let c_X_CC = "cc"
  let c_X_BCC = "bcc"
  let c_X_ApplicationType = "application-type"
  let c_X_Charset = "charset"
  let c_X_Encoding = "encoding-type"
  let c_X_Content = "content-type"
  let c_X_MessageType= "message-type"
  let c_X_CorrelationId = "correlation-id"
  let c_X_Priority = "priority"
  let c_X_ReplyTo = "reply-to"
  let c_X_MessageId = "message-id"
  let c_X_TimeStamp = "timestamp"
  let c_X_AppId = "app-id"
  let c_X_Match = "x-match"
  //let c_expiration = "expiration"
  let c_basic_type = "basic.type"
  let c_general_argument = "argument"

open XPairConst

/// registry namespace for other decorations that only have a variable key as part of their reference
/// defaults: variable key becomes the class name (minus the "Attribute" part)
/// formats my.namespace.
/// ref could be group1., ch1.mq, or ch1.return, etc.
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = false)>]
type RegNs(ns)=
  inherit Attribute()
  member val Ns : string = ns with get,set
  new() = RegNs("")

/// dsc: a mostly RabbitMQ defined, but also could be and application defined extension argument. 
/// Some attributes may need special basicProperty packing requirements (cc/bcc)
/// an XPair was originally setup to cater for extensions to the AQMP protocol.
/// Currently xpairs do not cover AQMP features, but they may in the future.
[<AbstractClass>]
type XPair(ref,key) =
  inherit Attribute()
  /// dsc: shorthand way to reference the attribute from other places (ie. it might be a global setting, or the setting might have some kind of to-be-determined local scope)
  member val Nskk : string = key with get,set
  ////member val Ref : string = ref with get,set
  /// the transport based key that gets used in BasicProperties
  member val Key : string = key with get,set
  abstract member oVal : obj with get,set
  interface INskk with
    member this.Nskk  with get() = this.Nskk and set(value)=this.Nskk<-value
  member val Grp : string = "" with get,set
  interface IMatchGrp with member this.Grp with get() = this.Grp
  interface IMatchWhen with member this.When with get() = this.Nskk

[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type XoPair(ref,key,_val:obj) =
  inherit XPair(ref,key)
  member val Val : obj = _val with get,set
  override this.oVal 
    with get() : obj = this.Val
    and set(value:obj) = this.Val <- value

[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type XhPair(ref,key,_val) =
  inherit XPair(ref,key)
  member val Val : Int16 = _val with get,set
  override this.oVal 
    with get() : obj = this.Val :> obj
     and set(value : obj) = this.Val <- value :?> Int16
  new(key,_val) = XhPair(null,key,_val)
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type XiPair(ref,key,_val) =
  inherit XPair(ref,key)
  member val Val : Int32 = _val with get,set
  override this.oVal 
    with get() : obj = this.Val :> obj
     and set(value : obj) = this.Val <- value :?> Int32
  new(key,_val) = XiPair(null,key,_val)
/// dsc: octet / byte
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type XxPair(ref,key,_val) =
  inherit XPair(ref,key)
  member val Val : Byte = _val with get,set
  override this.oVal 
    with get() : obj = this.Val :> obj
     and set(value : obj) = this.Val <- value :?> Byte
  new(key,_val) = XxPair(null,key,_val)
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type XlPair(ref,key,_val) =
  inherit XPair(ref,key)
  member val Val : Int64 = _val with get,set
  override this.oVal 
    with get() : obj = this.Val :> obj
     and set(value : obj) = this.Val <- value :?> Int64
  new(key,_val) = XlPair(null,key,_val)
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type XsPair(ref,key,_val) =
  inherit XPair(ref,key)
  member val Val : string = _val with get,set
  override this.oVal 
    with get() : obj = this.Val :> obj
     and set(value : obj) = this.Val <- value :?> string
  new(key,_val) = XsPair(null,key,_val)
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type XfPair(ref,key,_val) =
  inherit XPair(ref,key)
  member val Val : double = _val with get,set
  override this.oVal 
    with get() : obj = this.Val :> obj
     and set(value : obj) = this.Val <- value :?> double
  new(key,_val) = XfPair(null,key,_val)
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type XePair(ref,key,_val) =
  inherit XPair(ref,key)
  member val Val : single = _val with get,set
  override this.oVal 
    with get() : obj = this.Val :> obj
     and set(value : obj) = this.Val <- value :?> single
  new(key,_val) = XePair(null,key,_val)
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type XuhPair(ref,key,_val) =
  inherit XPair(ref,key)
  member val Val : UInt16 = _val with get,set
  override this.oVal 
    with get() : obj = this.Val :> obj
     and set(value : obj) = this.Val <- value :?> UInt16
  new(key,_val) = XuhPair(null,key,_val)
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type XuiPair(ref,key,_val) =
  inherit XPair(ref,key)
  member val Val : UInt32 = _val with get,set
  override this.oVal 
    with get() : obj = this.Val :> obj
     and set(value : obj) = this.Val <- value :?> UInt32
  new(key,_val) = XuiPair(null,key,_val)
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type XulPair(ref,key,_val) =
  inherit XPair(ref,key)
  member val Val : UInt64 = _val with get,set
  override this.oVal 
    with get() : obj = this.Val :> obj
     and set(value : obj) = this.Val <- value :?> UInt64
  new(key,_val) = XulPair(null,key,_val)

[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_AlternateExchange(ref,_val) =
  inherit XsPair(ref,c_X_AlternateExchange,_val)
  new(_val) = X_AlternateExchange("",_val)
/// dsc: per message time to live
/// rule: can not be zero
/// NB: Setting the TTL to 0 causes messages to be expired upon reaching a queue unless they can be delivered to a consumer immediately. Thus this provides an alternative to basic.publish's immediate flag, which the RabbitMQ server does not support. Unlike that flag, no basic.returns are issued, and if a dead letter exchange is set then messages will be dead-lettered.
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_PerMsgTTL(ref,ms) =
  inherit XlPair(ref,c_X_PerMsgTTL,ms)
  interface IPrecondition with
    member this.Pass() = 
      if this.Val <= 0L then raise<|PreconditionFail(sprintf "rule: %s must be greater than zero" (this.GetType().Name))
  //new(_val:string) = X_PerMsgTTL("",_val)
  new(ms:int64) = X_PerMsgTTL("",ms)
  new(p:IDictionary<string,obj>) = 
    X_PerMsgTTL(p |> IDict.tryGet c_X_PerMsgTTL |> (function | Some x->x :?> int64 | _ -> 0L))
    // TODO: copy this basicproperties.Headers to X_ attribute constructor pattern to all X_

  //new(ref,_val:int) = X_PerMsgTTL(ref,_val.ToString())
/// dsc: per queue time to live
/// NB: Setting the TTL to 0 causes messages to be expired upon reaching a queue unless they can be delivered to a consumer immediately. Thus this provides an alternative to basic.publish's immediate flag, which the RabbitMQ server does not support. Unlike that flag, no basic.returns are issued, and if a dead letter exchange is set then messages will be dead-lettered.
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_PerQueueMsgTTL(ref,ms) =
  inherit XlPair(ref,c_X_PerQueueMsgTTL,ms)
  interface IPrecondition with
    member this.Pass() = 
      if this.Val <= 0L then raise<|PreconditionFail(sprintf "rule: %s must be greater than zero" (this.GetType().Name))
  new(ms:int64) = X_PerQueueMsgTTL("",ms)
// a time-to-live (ttl) of the queue itself.  ie. the queue will be deleted if it is unused after the specified period of time
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_QueueTTL(ref,ms) =
  inherit XlPair(ref,c_X_QueueTTL,ms)
  interface IPrecondition with
    member this.Pass() = 
      if this.Val <= 0L then raise<|PreconditionFail(sprintf "rule: %s must be greater than zero" (this.GetType().Name))
  new(ms:int64) = X_QueueTTL("",ms)
/// dsc: http://www.rabbitmq.com/dlx.html
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_DeadLetterExchange(ref,_val) =
  inherit XsPair(ref,c_X_DeadLetterExchange,_val)
   new(_val) = X_DeadLetterExchange("",_val)
/// dsc: when messages are undeliverable (various reasons), they can be delivered to a nominated dead-letter-exchange
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_DeadLetterExchangeRoutingKey(ref,_val) =
  inherit XsPair(ref,c_X_DeadLetterExchangeRoutingKey,_val)
   new(_val) = X_DeadLetterExchangeRoutingKey("",_val)
/// Q: is this the maximum length of the queue or the message body?
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_MaxLength(ref,_val) =
  inherit XiPair(ref,c_X_MaxLength,_val)
   new(_val) = X_MaxLength("",_val)
/// dsc: may have to set this with the setUserId method
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_UserId(ref,_val) =
  inherit XsPair(ref,c_X_UserId,_val)
   new(_val) = X_UserId("",_val)
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_TrustUserId(ref,_val) =
  inherit XsPair(ref,"trust-user-id",_val)
   new(_val) = X_TrustUserId("",_val)
/// dsc: provide a carbon copy
/// a sender determined destination
/// valid for: direct and topic exchanges
/// IMPORTANT: if the routingKey has the characters "`,;" then it is a QList and we parse accordingly
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_CC(ref,routingKey) =
  inherit XsPair(ref,c_X_CC,routingKey)
   new(routingKey) = X_CC("",routingKey)
/// dsc: a blind carbon copy
/// a sender determined destination
/// valid for: direct and topic exchanges
/// IMPORTANT: if the routingKey has the characters "`,;" then it is a QList and we parse accordingly
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_BCC(ref,routingKey) =
  inherit XsPair(ref,c_X_BCC,routingKey)
   new(routingKey) = X_BCC("",routingKey)

/// A type within an application
/// dsc: in this sense "Type" refers to a strongly typed "Type", and not an encoding format as defined by the http standard
/// please note that content-encoding in http refers to the type of compression that is used
//[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
//type X_ApplicationType(ref, domainType) =
//  inherit XsPair(ref,c_X_ApplicationType,domainType)
//  new(_val) = X_ApplicationType("",_val)

/// dsc: text based formats must have a characterset type.  e.g. UTF-7, UTF-8, UTF-32, Unicode, etc
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_Charset(ref,charset) =
  // TODO: integrate this attribute into publish and subscribe methods
  inherit XsPair(ref,c_X_Charset)
  member this.CharsetType with get() = CharsetType.fromString(this.Val)
  member this.CharsetType with set(value:CharsetType) = this.Val<- value.toString

  static member tryNew(p:IDictionary<string,obj>) = if p.ContainsKey(c_X_Charset) then Some <| X_Charset p else None

  new(charSet:CharsetType) = X_Charset("",charSet.toString)
  new(charSet:string) = X_Charset("",charSet)
  new(p:IDictionary<string,obj>) = 
    X_Charset("", p |> IDict.tryGet c_X_Charset |> (function | Some x->x:?>string | _ -> ""))

[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_Encoding(ref,encodingType) =
  // TODO: integrate this attribute into publish and subscribe methods
  //       ie. if present then gzip/un-gzip the contents when of type text
  //           otherwise, ignore it
  inherit XsPair(ref,c_X_Encoding)
  member this.EncodingType with get() = EncodingType.fromString(this.Val)
  member this.Encoding with set(value:EncodingType) = this.Val<- value.toString

  static member tryNew(p:IDictionary<string,obj>) = if p.ContainsKey(c_X_Charset) then Some <| X_Encoding p else None

  new(encodingType:EncodingType) = X_Encoding("",encodingType.toString)
  new(encodingType:string) = X_Encoding("",encodingType)
  new(p:IDictionary<string,obj>) = 
    X_Encoding("", p |> IDict.tryGet c_X_Encoding |> (function | Some x->x:?>string | _ -> ""))

[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_MessageType(ref,messageType) =
  inherit XsPair(ref,c_X_Encoding)
  member val TypeKey = messageType with get,set

  static member tryNew(p:IDictionary<string,obj>) = if p.ContainsKey(c_X_MessageType) then Some <| X_MessageType p else None

  new(messageType:string) = X_MessageType("",messageType)
  new(type0:Type) = X_MessageType("",type0.FullName)
  new(p:IDictionary<string,obj>) = 
    X_MessageType("", p |> IDict.tryGet c_X_MessageType |> (function | Some x->x:?>string | _ -> ""))
  // TODO: implement an interface so that an type-id can be pulled out of an instance?


/// eg. gzip
/// ref: http://en.wikipedia.org/wiki/HTTP_compression
/// ref: https://www.w3.org/International/O-HTTP-charset
/// see: information on the charset parameter
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_Content(ref,contentType,charSet) =
  inherit XPair(ref,c_X_Content)

  let part1 (x:string) = 
    x.Split(';').[0]

  let part2 (x:string) = 
    let p=x.Split(';')
    let pair=p.[1].Split([|'=';' '|],StringSplitOptions.RemoveEmptyEntries)
    if p.Length = 2 then
      (pair.[0],pair.[1])
    else
      (pair.[0],"")
  
  member val Type : string = contentType with get,set
  member val Charset : string = charSet with get,set

  member this.ContentType with get() = ContentType.fromMime(this.Type)
  member this.ContentType with set(value:ContentType) = this.Type<- value.toMime
  member this.CharsetType with get() = CharsetType.fromString(this.Charset)
  member this.CharsetType with set(value:CharsetType) = this.Type<- value.toString

  member this.Val
    with get() =
      this.Type + 
          match this.Charset with 
          | null 
          | "" -> ""
          | x -> "; charset=" + x
     and set(value) =
      this.Type <- part1 value
      let (k,v) = part2 value
      match k with 
      | "charset" -> this.Charset <- v
      | _ -> raise<|UnknownKey("unrecognised key.  Also, we only expect one additional kv pair.")

  override this.oVal 
    with get() : obj = this.Val :> obj
     and set(value : obj) = this.Val <- value :?> string

  /// HTML 5 seperates Charset into a seperate attribute.  We reflect this 
  member this.ResolveCharset (y:X_Charset) =
    CharsetType.merge this.CharsetType y.CharsetType

  static member tryNew(p:IDictionary<string,obj>) = if p.ContainsKey(c_X_Content) then Some <| X_Content p else None

  new(contentType) = X_Content("",contentType,UTF_8.toString)
  new(contentType:ContentType,charSet:CharsetType) = X_Content("",contentType.toMime, charSet.toString)
  new(contentType:ContentType) = X_Content("",contentType.toMime, CharsetType.UTF_8.toString)
  new(ref,contentType:ContentType,charSet:CharsetType) = X_Content(ref,contentType.toMime, charSet.toString)
  new(p:IDictionary<string,obj>) = 
    X_Content(p |> IDict.tryGet c_X_Content |> (function | Some x->x:?>string | _ -> ""))

/// dsc: used by an application to link messages
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_CorrelationId(ref, value) = 
  inherit XsPair(ref,c_X_CorrelationId,value)
  new(value) = X_CorrelationId("",value)

/// dsc: RabbitMQ can now define priorities for messages
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_Priority(ref, value) = 
  inherit XxPair(ref,c_X_Priority,value)
  new(value:byte) = X_Priority("",value)
  new(value:int) = X_Priority("",byte value)
  new(ref,value:int) = X_Priority(ref,byte value)

/// passed in a RabbitMQ message
/// dsc: specificies who a recipient should dynamically reply to after they've processed a message (often used in RPC)
/// NB: theoretically we could ask the service to reply to any routing key we like
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_ReplyTo(ref, value) = 
  inherit XsPair(ref,c_X_ReplyTo,value)
  //new(value) = X_ReplyTo("",value)

  static member tryNew(p:IDictionary<string,obj>) = if p.ContainsKey(c_X_ReplyTo) then Some <| X_ReplyTo(p.[c_X_ReplyTo] :?> string) else None

  new(qto:string) = 
    let rp = Parse.fromQKVs qto |> Array.toList
    let h = rp |> List.head
    let exch = fst h
    let q = (snd h) |> Array.toList |> List.head
    X_ReplyTo(exch,q)

/// what the value passed in a RabbitMQ message should be
/// this type is not implemented in any of the route finding measures
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_ReplyTo1(type_, when_, grp_, altWhen, altGrp) = 
  inherit Attribute()
  member val Type : Type = type_ with get,set
  member val Grp : string = grp_ with get,set
  member val When : string = when_ with get,set
  member val AltGrp : string = altGrp with get,set 
  member val AltWhen : string = altWhen with get,set
  interface IMatchGrp with member this.Grp with get() = this.Grp
  interface IMatchWhen with member this.When with get() = this.When
  new() = X_ReplyTo1(null, "", "", "", "")
  new(type_) = X_ReplyTo1(type_, "", "", "", "")
  new(type_, when_, grp_) = X_ReplyTo1(type_, when_, grp_, "", "")
  new(type_, when_, grp_, altWhen:string option, altGrp:string option) = X_ReplyTo1(type_, when_, grp_, altWhen|>(function | Some(x)->x | None ->""), altGrp|>(function | Some(x)->x | None ->""))
  new(type_, when_) = X_ReplyTo1(type_, when_, "", "", "")
  new(A : obj array) = X_ReplyTo1(A.[0]:?>Type,A.[1]:?>string,A.[2]:?>string,A.[3]:?>string option, A.[4]:?>string option)
  // TODO: translate IReply0 to this, then use this to resolve the actual type.  Allows us to resolve from code-first or attribute

/// what the value passed in a RabbitMQ message should be
/// this type is not implemented in any of the route finding measures

  
/// dsc: an application defined message identifier
//[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
//type X_MessageId(ref, value) = 
//  inherit XsPair(ref,c_X_MessageId,value)
//  new(value) = X_MessageId("",value)

/// dsc: a message timestamp 
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_TimeStamp(ref:string, value) = 
  inherit XlPair(ref,c_X_TimeStamp,value)
  member this.toAmqpTimestamp() =
    AmqpTimestamp(this.Val)
  new(value0:Int64) = X_TimeStamp("",value0)
  new(value:DateTime) = X_TimeStamp("",value.toTime_t_ms())
  new(ref:string,value:DateTime) = X_TimeStamp(ref,value.toTime_t_ms())

/// dsc: Application ID Extension
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_AppId(ref, value) = 
  inherit XsPair(ref,c_X_AppId,value)
  new(value) = X_AppId("",value)

[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_BasicType(ref, value) = 
  inherit XsPair(ref,c_basic_type,value)
  new(value) = X_BasicType("",value)

/// dsc: general argument.  A catch all type for when we can't work out what it is
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_Argument(ref, key, value) =
  inherit XoPair(ref, key, value)
  new(key,value) = X_Argument("", key, value)

/// used by: Headers Exchange
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_Match(ref, value) =
  inherit XsPair(ref, c_X_Match, value)
  member this._Val  
    with get() = MatchType.fromString(this.Val)
    and set(value:MatchType) = this.Val <- value.toString
  new(value) = X_Match(value)

/// dsc: a key value specification for the X_Match queue bindings for exchange type of "headers" 
/// see: http://www.rabbitmq.com/amqp-0-9-1-errata.html#section_3 for data types
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_Spec(ref, key, value) =
  inherit XoPair(ref, key, value)
  new(key,value:string) = X_Spec("",key,value :> obj)
  new(key,value:bool) = X_Spec("",key,value :> obj)
  new(key,value:Int16) = X_Spec("",key,value :> obj)
  new(key,value:Int32) = X_Spec("",key,value :> obj)
  new(key,value:Int64) = X_Spec("",key,value :> obj)
  new(key,value:UInt16) = X_Spec("",key,value :> obj)
  new(key,value:UInt32) = X_Spec("",key,value :> obj)
  new(key,value:UInt64) = X_Spec("",key,value :> obj)
  new(key,value:Byte[]) = X_Spec("",key,value :> obj)
  new(key,value:DateTime) = X_Spec("",key,value :> obj)
  new(key,value:Single) = X_Spec("",key,value :> obj)
  new(key,value:Double) = X_Spec("",key,value :> obj)
  new(key,value:Decimal) = X_Spec("",key,value :> obj)
  new(ref,key,value:bool) = X_Spec(ref,key,value :> obj)
  new(ref,key,value:Int16) = X_Spec(ref,key,value :> obj)
  new(ref,key,value:Int32) = X_Spec(ref,key,value :> obj)
  new(ref,key,value:Int64) = X_Spec(ref,key,value :> obj)
  new(ref,key,value:UInt16) = X_Spec(ref,key,value :> obj)
  new(ref,key,value:UInt32) = X_Spec(ref,key,value :> obj)
  new(ref,key,value:UInt64) = X_Spec(ref,key,value :> obj)
  new(ref,key,value:Byte[]) = X_Spec(ref,key,value :> obj)
  new(ref,key,value:DateTime) = X_Spec(ref,key,value :> obj)
  new(ref,key,value:Single) = X_Spec(ref,key,value :> obj)
  new(ref,key,value:Double) = X_Spec(ref,key,value :> obj)
  new(ref,key,value:Decimal) = X_Spec(ref,key,value :> obj)

/// dsc: a key/value pair that is specified in meta and/or dynamically at run-time perhaps depending on a messages contents
/// a listenner specifies what to list for via the X_Spec attribute
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_KeyVal(ref, key, value) =
  inherit XoPair(ref, key, value)
  //new(key,value) = X_KeyVal("",key,value)
  new(key,value:string) = X_KeyVal("",key,value :> obj)
  new(key,value:bool) = X_KeyVal("",key,value :> obj)
  new(key,value:Int16) = X_KeyVal("",key,value :> obj)
  new(key,value:Int32) = X_KeyVal("",key,value :> obj)
  new(key,value:Int64) = X_KeyVal("",key,value :> obj)
  new(key,value:UInt16) = X_KeyVal("",key,value :> obj)
  new(key,value:UInt32) = X_KeyVal("",key,value :> obj)
  new(key,value:UInt64) = X_KeyVal("",key,value :> obj)
  new(key,value:Byte[]) = X_KeyVal("",key,value :> obj)
  new(key,value:DateTime) = X_KeyVal("",key,value :> obj)
  new(key,value:Single) = X_KeyVal("",key,value :> obj)
  new(key,value:Double) = X_KeyVal("",key,value :> obj)
  new(key,value:Decimal) = X_KeyVal("",key,value :> obj)
  new(ref,key,value:bool) = X_KeyVal(ref,key,value :> obj)
  new(ref,key,value:Int16) = X_KeyVal(ref,key,value :> obj)
  new(ref,key,value:Int32) = X_KeyVal(ref,key,value :> obj)
  new(ref,key,value:Int64) = X_KeyVal(ref,key,value :> obj)
  new(ref,key,value:UInt16) = X_KeyVal(ref,key,value :> obj)
  new(ref,key,value:UInt32) = X_KeyVal(ref,key,value :> obj)
  new(ref,key,value:UInt64) = X_KeyVal(ref,key,value :> obj)
  new(ref,key,value:Byte[]) = X_KeyVal(ref,key,value :> obj)
  new(ref,key,value:DateTime) = X_KeyVal(ref,key,value :> obj)
  new(ref,key,value:Single) = X_KeyVal(ref,key,value :> obj)
  new(ref,key,value:Double) = X_KeyVal(ref,key,value :> obj)
  new(ref,key,value:Decimal) = X_KeyVal(ref,key,value :> obj)

/// http://www.rabbitmq.com/shovel.html
/// used by: delete in mgmt plugins
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_Reason(r,v) =
  inherit XsPair(r,"x-reason",v)
  new(k) = X_Reason("",k)
/// used by: shovel
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_PrefetchCount(r,v) =
  inherit XsPair(r,"x-prefetch-count",v)
  new(k) = X_PrefetchCount("",k)
/// used by: shovel
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_AckMode(r,v) =
  inherit XsPair(r,"x-ack-mode",v)
  new(k) = X_AckMode("",k)
/// used by: shovel
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_DeliveryMode(r,v) =
  inherit XsPair(r,"x-delivery-mode",v)
  new(k) = X_DeliveryMode("",k)
/// used by: shovel
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type X_ReconnectDelay(r,v) =
  inherit XsPair(r,"x-reconnect-delay",v)
  new(k) = X_ReconnectDelay("",k)

/// dsc: vendor specific extensions to the AQMP spec
type IAmqpExtension =
  //abstract Arguments : IDictionary<string,obj> with get,set
  //abstract member Arguments : IDictionary<string,obj> with get,set
  /// dsc: The RabbitMQ Server implements a number of extensions of the AMQP specification
  /// use X_Argument to catch general BasicArguments that are not recognised
  abstract member X_Pairs : XPair list with get,set
  /// dsc: a csv list of references to extensions attributes
  abstract member X_Refs : string with get,set

// NOTE: meta messages were overloaded logically into n groups.  The spec is more precise and resolves around methods
//       however, we erred towards simpler configuration
// (see the AMQP0-9-1.xml specification)

/// nme: Connection define Meta Attribute
/// dsc: The rabbitMQ connection fatory has a number of options to choose from at connection time
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type CxDef(hostName0) =
  inherit Attribute()
  /// The host to connect to
  member val HostName : string = hostName0 with get,set //ConnectionFactory.DefaultVHost;
  /// Virtual host to access during this connection
  member val VirtualHost : string = null with get,set//ConnectionFactory.DefaultVHost;
  /// The port to connect on.
  ///              AmqpTcpEndpoint.UseDefaultPort indicates the default for
  ///              the protocol should be used.
  member val Port : int = 0 with get,set//ConnectionFactory.Default;
  /// Username to use when authenticating to the server
  member val UserName : string = null with get,set//ConnectionFactory.DefaultUser;
  /// Password to use when authenticating to the server
  member val Password : string = null with get,set//ConnectionFactory.DefaultPass;
  /// The AMQP protocol to be used
  member val Protocol : string = null with get,set//ConnectionFactory.def
  /// Frame-max parameter to ask for (in bytes)
  member val RequestedChannelMax : uint16 = 0us with get,set
  /// Timeout setting for connection attempts (in milliseconds)
  member val RequestedConnectionTimeout : int = 0 with get,set
  /// Default value for the desired maximum frame size,
  ///             with zero meaning unlimited (value: 0)
  member val RequestedFrameMax : uint32 = 0u with get,set
  /// Default value for desired heartbeat interval, in
  ///             seconds, with zero meaning none (value: 0)
  member val RequestedHeartbeat : uint16 = 0us with get,set
  /// Ssl options setting
  /// eg. hostName,certPath,querystring
  member val Ssl : string = "" with get,set// new SslOption(); // should this be an optional tuple server,certPath,enabled?  or server//path/enabled, server/path/disabled.  http/servername
  /// eg. "amqp://localhost"
  member val Uri : string = "" with get,set
  /// the maximum number of redirects to follow
  member val MaxRedirects = 0 with get,set
  /// when true autocreate a factory and a connection at the same time
  member val AutoConnect : bool = true with get,set
  member val Nskk : string = "" with get,set
  interface INskk with
    member this.Nskk  with get() = this.Nskk and set(value)=this.Nskk<-value
  member val Grp : string = "" with get,set
  interface IMatchGrp with member this.Grp with get() = this.Grp
  interface IAmqpExtension with
    /// vendor specific extensions to the AQMP specification.  NB. our extensions + extensionRefs properties are .Net based helper hacks to make this a little easier to deal with in attributed form
    //member val Arguments : IDictionary<string,obj> = null with get,set
    /// The RabbitMQ Server implements a number of extensions of the AMQP specification
    member val X_Pairs : XPair list = [] with get,set
    /// a csv list of references to extensions attributes
    member val X_Refs : string = null with get,set
  new() = CxDef(null)

// abc:queue`excl`mand`immed

// should tag be specified like this exchange:routingQueue?tag
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type RoutingPair(exchange,routingKey) = 
  inherit Attribute()
  member val exchange : string = exchange with get,set
  member val routingKey : string = routingKey with get,set
  member val tag : string = null with get,set
  override this.ToString() = sprintf "%s:%s" exchange routingKey 
  member val Nskk : string option = None with get,set
  //member val Ref : string option = None with get,set
  //member val Arguments : IDictionary<string,obj> = null with get,set          // this was put here for convenience when I was considering interacting with the RabbitMQ managemenet API
  interface INskk with
    member this.Nskk  with get() = this.Nskk |>(function|None->""|Some(x)->x) and set(value) = this.Nskk<-value|>(function|""|null->None|x->Some(x))
  member val Grp : string = "" with get,set
  interface IMatchGrp with member this.Grp with get() = this.Grp
  interface IMatchWhen with member this.When with get() = this.Nskk|>(function | Some(x)->x | _ -> "")

  new() = RoutingPair(null,null)

/// nme: Publish / Subscribe Context
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type PubSubContext() = 
  inherit Attribute()
  member val ExchangeDefault : string = null with get,set
  member val X_ContentDefault : X_Content option = None with get,set
  member val X_CharsetTypeDefault : X_Charset option = None with get,set
  member val X_EncodingDefault : X_Encoding option = None with get,set
  member val Grp : string = "" with get,set
  interface IMatchGrp with member this.Grp with get() = this.Grp

/// nme: Communication Channel Meta Attribute
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type CcDef() =
  inherit Attribute()
  member val name : string = null with get,set
  /// vendor specific extensions to the AQMP specification.  NB. our extensions + extensionRefs properties are .Net based helper hacks to make this a little easier to deal with in attributed form
  member val Nskk : string option = None with get,set
  //member val Ref : string option = None with get,set
  
  interface INskk with
    member this.Nskk  with get() = this.Nskk |>(function|None->""|Some(x)->x) and set(value) = this.Nskk<-value|>(function|""|null->None|x->Some(x))
    //member this._Tag  with get() = this.Ref |>(function|None->""|Some(x)->x) and set(value) = this.Ref<-value|>(function|""|null->None|x->Some(x))
  interface IAmqpExtension with
    //member val Arguments : IDictionary<string,obj> = null with get,set
    /// vendor specific extensions to the AQMP specification.  NB. our extensions + extensionRefs properties are .Net based helper hacks to make this a little easier to deal with in attributed form
    //member val Arguments : IDictionary<string,obj> = null with get,set
    /// The RabbitMQ Server implements a number of extensions of the AMQP specification
    member val X_Pairs : XPair list = [] with get,set
    /// a csv list of references to extensions attributes
    member val X_Refs: string = null with get,set
  member val Grp : string = "" with get,set
  interface IMatchGrp with member this.Grp with get() = this.Grp
  interface IMatchWhen with member this.When with get() = this.Nskk|>(function | Some(x)->x | _ -> "")

/// nme: Quality Of Service Definition
/// dsc: This method requests a specific quality of service. The QoS can be specified for the
/// current channel or for all channels on the connection. The particular properties and
/// semantics of a qos method always depend on the content class semantics. Though the
/// qos method could in principle apply to both peers, it is currently meaningful only
/// for the server.
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type QosDef(prefetchSize0,prefetchCount0,_global0) =
  inherit Attribute()
  /// The client can request that messages be sent in advance so that when the client
  /// finishes processing a message, the following message is already held locally,
  /// rather than needing to be sent down the channel. Prefetching gives a performance
  /// improvement. This field specifies the prefetch window size in octets. The server
  /// will send a message in advance if it is equal to or smaller in size than the
  /// available prefetch size (and also falls into other prefetch limits). May be set
  /// to zero, meaning "no specific limit", although other prefetch limits may still
  /// apply. The prefetch-size is ignored if the no-ack option is set.
  member val prefetchSize : UInt32 = prefetchSize0 with get,set
  /// Specifies a prefetch window in terms of whole messages. This field may be used
  /// in combination with the prefetch-size field; a message will only be sent in
  /// advance if both prefetch windows (and those at the channel and connection level)
  /// allow it. The prefetch-count is ignored if the no-ack option is set.
  member val prefetchCount : UInt16 = prefetchCount0 with get,set
  /// By default the QoS settings apply to the current channel only. If this field is
  /// set, they are applied to the entire connection.
  member val _global : bool = _global0 with get,set
  member val Nskk : string option = None with get,set
  //member val Ref : string option = None with get,set
  interface INskk with
    member this.Nskk  with get() = this.Nskk |>(function|None->""|Some(x)->x) and set(value) = this.Nskk<-value|>(function|""|null->None|x->Some(x))
    //member this._Tag  with get() = this.Ref |>(function|None->""|Some(x)->x) and set(value) = this.Ref<-value|>(function|""|null->None|x->Some(x))
  member val Grp : string = "" with get,set
  interface IMatchGrp with member this.Grp with get() = this.Grp
  interface IMatchWhen with member this.When with get() = this.Nskk|>(function | Some(x)->x | _ -> "")
  new() = QosDef(0u,0us,false)
  new(prefetchSize0,prefetchCount0) = QosDef(prefetchSize0,prefetchCount0,false)

/// nme: Consumer define Meta Attribute
/// dsc: This method asks the server to start a "consumer", which is a transient request for
/// messages from a specific queue. Consumers last as long as the channel they were
/// declared on, or until the client cancels them.
/// where: externalises parameters to QueueingBasicConsumer, RabbitMQ.Client.MessagePatterns.Subscription(), cc.BasicConsume
type ConsrDef() =
  inherit Attribute()
  /// Identifier for the consumer, valid within the current channel.
  member val consumerTag : string=null with get,set
  /// If this field is set the server does not expect acknowledgements for
  /// messages. That is, when a message is delivered to the client the server
  /// assumes the delivery will succeed and immediately dequeues it. This
  /// functionality may increase performance but at the cost of reliability.
  /// Messages can get lost if a client dies before they are delivered to the
  /// application.
  member val noAck= false with get,set
  ///  If the no-local field is set the server will not send messages to the connection that
  ///  published them.
  member val noLocal= false with get,set
  /// If not set and the queue exists, the server MUST check that the
  /// existing queue has the same values for durable, exclusive, auto-delete,
  /// and arguments fields.  The server MUST respond with Declare-Ok if the
  /// requested queue matches these fields, and MUST raise a channel exception
  /// if not.
  member val exclusive= false with get,set
  /// If set, the server will not respond to the method. The client should not wait
  /// for a reply method. If the server could not complete the method it will raise a
  /// channel or connection exception.
  member val noWait= false with get,set
  /// see: http://www.rabbitmq.com/consumer-priority.html + X_Priority()
  member val priority : int option = None with get,set
  member val Nskk : string option = None with get,set
  //member val Ref : string option = None with get,set
  interface INskk with
    member this.Nskk  with get() = this.Nskk |>(function|None->""|Some(x)->x) and set(value) = this.Nskk<-value|>(function|""|null->None|x->Some(x))
    //member this._Tag  with get() = this.Ref |>(function|None->""|Some(x)->x) and set(value) = this.Ref<-value|>(function|""|null->None|x->Some(x))
  member val Grp : string = "" with get,set
  interface IMatchGrp with member this.Grp with get() = this.Grp
  interface IMatchWhen with member this.When with get() = this.Nskk|>(function | Some(x)->x | _ -> "")
  interface IAmqpExtension with
    //member val Arguments : IDictionary<string,obj> = null with get,set
    /// vendor specific extensions to the AQMP specification.  NB. our extensions + extensionRefs properties are .Net based helper hacks to make this a little easier to deal with in attributed form
    //member val Arguments : IDictionary<string,obj> = null with get,set
    /// The RabbitMQ Server implements a number of extensions of the AMQP specification
    member val X_Pairs : XPair list = [] with get,set
    /// a csv list of references to extensions attributes
    member val X_Refs : string = null with get,set

/// nme: Publish define Meta Attribute
/// dsc: This method publishes a message to a specific exchange. The message will be routed
/// to queues as defined by the exchange configuration and distributed to any active
/// consumers when the transaction, if any, is committed.
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type PubDef() =
  inherit Attribute()

  // should the routing key here be represented as a queue?

  /// The exchange name is a client-selected string that identifies the exchange for
  /// publish methods.
  member val exchange = "" with get,set
  /// Specifies the routing key for the binding. The routing key is used for routing
  /// messages depending on the exchange configuration. Not all exchanges use a
  /// routing key - refer to the specific exchange documentation.  If the queue name
  /// is empty, the server uses the last queue declared on the channel.  If the
  /// routing key is also empty, the server uses this queue name for the routing
  /// key as well.  If the queue name is provided but the routing key is empty, the
  /// server does the binding with that empty routing key.  The meaning of empty
  /// routing keys depends on the exchange implementation.
  member val routingKey = "" with get,set

  member val Nskk : string option = None with get,set
  //member val Ref : string option = None with get,set
  interface INskk with
    member this.Nskk  with get() = this.Nskk |>(function|None->""|Some(x)->x) and set(value) = this.Nskk<-value|>(function|""|null->None|x->Some(x))
    //member this._Tag  with get() = this.Ref |>(function|None->""|Some(x)->x) and set(value) = this.Ref<-value|>(function|""|null->None|x->Some(x))
  interface IAmqpExtension with
    //member val Arguments : IDictionary<string,obj> = null with get,set
    /// vendor specific extensions to the AQMP specification.  NB. our extensions + extensionRefs properties are .Net based helper hacks to make this a little easier to deal with in attributed form
    //member val Arguments : IDictionary<string,obj> = null with get,set
    /// The RabbitMQ Server implements a number of extensions of the AMQP specification
    member val X_Pairs : XPair list = [] with get,set
    /// a csv list of references to extensions attributes
    member val X_Refs : string = null with get,set
  member val Grp : string = "" with get,set
  interface IMatchGrp with member this.Grp with get() = this.Grp
  interface IMatchWhen with member this.When with get() = this.Nskk|>(function | Some(x)->x | _ -> "")
  /// to routing pair
  member this.toRP() =
    RoutingPair(this.exchange,this.routingKey)

/// nme: Routing Pair Register Entry
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type RoutingPairRegEntry(meta) =
  member val Meta = meta : RoutingPair with get,set
  member val IsOpen : bool = false with get,set
  member val Last : DateTime = DateTime.MinValue with get,set  
  member val Fr : DateTime = DateTime.MinValue with get,set
  member val To : DateTime = DateTime.MaxValue with get,set

type RoutingPair with
  /// nme: blend routing pairs with defaults
  static member blendInDefaults (rpairs: RoutingPair list) mqKey defaultExchange =
    rpairs
    |> List.map(fun rp->
                  if String.IsNullOrEmpty(rp.routingKey) then 
                    rp.routingKey<-mqKey
                  if String.IsNullOrEmpty(rp.exchange) then
                    rp.exchange<-defaultExchange
                  rp)
    |> Seq.distinct
    |> Seq.toList

  static member fromQKVs (x:string) =
    x
    |> Parse.fromQKVs
    |> Array.map(fun (k,V)->
                  V
                  |> Array.map(fun v-> RoutingPair(k,v))
                  |> (fun RP->
                              match RP with
                              | [||] -> [|RoutingPair(k,"")|]           // when exchange only, default to exhange and an empty string, not an empty array.
                              | rp -> rp
                      )
               )
    |> Array.concat
    |> Array.toList
    |> List.map(fun rp->
                   let (rk,tag) = 
                     if not <| String.IsNullOrEmpty(rp.tag ) then
                       (rp.routingKey, rp.tag)
                     else
                       match rp.routingKey.Split([|'?'|]) with
                       | [|x|] -> (x,null)
                       | [|x;y|] -> (x,y)
                       | _ -> raise<|EmptyRoutingKey("routing key may not be empty")
                   RoutingPair(rp.exchange,rk,tag=tag)
               )  
  
  static member queueNameFrom (qrouting:string) =
      match RoutingPair.fromQKVs qrouting with
      | [] -> "" 
      | L -> L |> List.head |> (fun x->x.routingKey)

/// dsc: Exchanges match and distribute messages across queues. Exchanges can be configured in
/// the server or declared at runtime.
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type ExDef(name0, typ0) =
  inherit Attribute()
  member val Nskk : string option = None with get,set
  //member val Ref : string option = None with get,set
  /// dsc: The exchange name is a client-selected string that identifies the exchange for
  /// publish methods.
  member val name : string = name0 with get,set
  /// dsc: the type of exchange.  Valid types are: direct, fanout, topic
  //member val _type = "" with get,set
  member val _type = typ0 with get,set
  /// dsc: If set, the server will reply with Declare-Ok if the exchange already
  /// exists with the same name, and raise an error if not.  The client can
  /// use this to check whether an exchange exists without modifying the
  /// server state. When set, all other method fields except name and no-wait
  /// are ignored.  A declare with both passive and no-wait has no effect.
  /// Arguments are compared for semantic equivalence.
  member val passive = false with get,set
  /// dsc: If set when creating a new exchange, the exchange will be marked as durable.
  /// Durable exchanges remain active when a server restarts. Non-durable exchanges
  /// (transient exchanges) are purged if/when a server restarts.
  member val durable = false with get,set
  /// dsc: If set, the exchange is deleted when all queues have finished using it.
  /// The server SHOULD allow for a reasonable delay between the point when it determines that an exchange is not being used (or no longer used), and the point when it deletes the exchange. At the least it must allow a client to create an exchange and then bind a queue to it, with a small but non-zero delay between these two actions.
  /// The server MUST ignore the auto-delete field if the exchange already exists.
  member val autoDelete = false with get,set
  /// If set, the exchange may not be used directly by publishers, but only when bound to other exchanges. Internal exchanges are used to construct wiring that is not visible to applications.
  member val _internal = false with get,set
  /// dsc: these are provided seperately at exchange.declare time
  /// however, the management plugin also returns these in one document via the management plugin
  /// so although these items are presently ignored, they are provided here for completeness
  // TODO: work out what the compatibility between arguments (here) and a list of XPairs is
  member val arguments : KeyValuePair<string,obj> list = [] with get,set
  new(name) = ExDef(name,Direct)

  /// dsc: Exchange to Exchange routing
  member val QRouting = "" with get,set
  /// dsc: Exchange to Exchange routing
  member val RoutingPairs : RoutingPair list = [] with get,set
  member this.GetRoutingPairs() : RoutingPair list = 
    List.append (RoutingPair.fromQKVs this.QRouting) this.RoutingPairs
  
  interface IAmqpExtension with
    //member val Arguments : IDictionary<string,obj> = null with get,set
    /// dsc: vendor specific extensions to the AQMP specification.  NB. our extensions + extensionRefs properties are .Net based helper hacks to make this a little easier to deal with in attributed form
    //member val Arguments : IDictionary<string,obj> = null with get,set
    /// dsc: The RabbitMQ Server implements a number of extensions of the AMQP specification
    member val X_Pairs : XPair list = [] with get,set
    /// dsc: a csv list of references to extensions attributes
    member val X_Refs : string = null with get,set
  interface INskk with
    member this.Nskk  with get() = this.Nskk |>(function|None->""|Some(x)->x) and set(value) = this.Nskk<-value|>(function|""|null->None|x->Some(x))
    //member this._Tag  with get() = this.Ref |>(function|None->""|Some(x)->x) and set(value) = this.Ref<-value|>(function|""|null->None|x->Some(x))
  member val Grp : string = "" with get,set
  interface IMatchGrp with member this.Grp with get() = this.Grp
  interface IMatchWhen with member this.When with get() = this.Nskk|>(function | Some(x)->x | _ -> "")

/// dsc: This method binds a queue to an exchange. Until a queue is bound it will not
/// receive any messages. In a classic messaging model, store-and-forward queues
/// are bound to a direct exchange and subscription queues are bound to a topic
/// exchange.
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type MQBindingDef() =
  inherit Attribute()
  /// dsc: The queue name identifies the queue within the vhost.  In methods where the queue
  /// name may be blank, and that has no specific significance, this refers to the
  /// 'current' queue for the channel, meaning the last queue that the client declared
  /// on the channel.  If the client did not declare a queue, and the method needs a
  /// queue name, this will result in a 502 (syntax error) channel exception.
  member val queue = "" with get,set
  /// dsc: The exchange name is a client-selected string that identifies the exchange for
  /// publish methods.
  member val exchange = "" with get,set

  /// dsc: Specifies the routing key for the binding. The routing key is used for routing
  /// messages depending on the exchange configuration. Not all exchanges use a
  /// routing key - refer to the specific exchange documentation.  If the queue name
  /// is empty, the server uses the last queue declared on the channel.  If the
  /// routing key is also empty, the server uses this queue name for the routing
  /// key as well.  If the queue name is provided but the routing key is empty, the
  /// server does the binding with that empty routing key.  The meaning of empty
  /// routing keys depends on the exchange implementation.
  member val QRouting = "" with get,set
  member val RoutingPairs : RoutingPair list = [] with get,set
  member this.GetRoutingPairs() : RoutingPair list = 
    let L = List.append (RoutingPair.fromQKVs this.QRouting) this.RoutingPairs
    if L = [] then [RoutingPair("",this.queue)] else L

  /// dsc: declare queue and exchange if not present
  /// NOT FROM THE AQMP SPEC
  member val declare = false with get,set
  /// dsc: while declaring, be passive if the queues already exist (ie. do not cause a fuss by raising an exception)
  /// NOT FROM THE AQMP SPEC
  member val passive = false with get,set

  member val ifUnused= true with get,set
  /// dsc: If set, the server will only delete the queue if it has no messages.
  member val ifEmpty= true with get,set
  
  member val Nskk : string option = None with get,set
  interface INskk with
    member this.Nskk  with get() = this.Nskk |>(function|None->""|Some(x)->x) and set(value) = this.Nskk<-value|>(function|""|null->None|x->Some(x))
  interface IAmqpExtension with
    //member val Arguments : IDictionary<string,obj> = null with get,set
    /// vendor specific extensions to the AQMP specification.  NB. our extensions + extensionRefs properties are .Net based helper hacks to make this a little easier to deal with in attributed form
    //member val Arguments : IDictionary<string,obj> = null with get,set
    /// The RabbitMQ Server implements a number of extensions of the AMQP specification
    member val X_Pairs : XPair list = [] with get,set
    /// a csv list of references to extensions attributes
    member val X_Refs : string = null with get,set
  member val Grp : string = "" with get,set
  interface IMatchGrp with member this.Grp with get() = this.Grp
  interface IMatchWhen with member this.When with get() = this.Nskk|>(function | Some(x)->x | _ -> "")

/// dsc: declare queue, create if needed
/// This method creates or checks a queue. When creating a new queue the client can
/// specify various properties that control the durability of the queue and its
/// contents, and the level of sharing for the queue.
///
/// this attribute is overloaded in that a QList can be 1:1 or 1:n routing keys.  Publishing should be to the full queue name, and not 
/// some wild-carded name
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type MQDef(name0,qrouting0) =
  inherit Attribute()

  /// dsc: for convenience property
  let mutable _RoutingPairs : RoutingPair list option = None

  /// dsc: The queue name identifies the queue within the vhost.  In methods where the queue
  /// name may be blank, and that has no specific significance, this refers to the
  /// 'current' queue for the channel, meaning the last queue that the client declared
  /// on the channel.  If the client did not declare a queue, and the method needs a
  /// queue name, this will result in a 502 (syntax error) channel exception.
  member val name : string = name0 with get,set

  /// the broker defined name
  /// queues on the broker can be set to expire.  
  member val uniqueName : string = name0 with get,set

  /// when true, openQueue will check the broker to see if the queue still exists every time
  /// discussion:
  /// most queues are permanent or their presence/absence can be understood simply by the context.
  /// since the idea of the broker is to have guaranteed delivery, etc, this reduces error handling
  /// however, if you intentionally expire a queue, this switch suggests that you should check it's still if you get this from the queue
  /// TODO: implement a checkIfAlive policy so that clients do not have to dumbly hit the broker until some threshold is met
  ///       the default action is to hit the broker.  
  member val checkIfAlive : bool = false with get,set
  
  /// when true, do not cache this definition in a register.  Queue use probably results in a unique queue name each time such as when a subscriber is defined
  /// see: Register.fs
  member val noCache : bool = false with get,set

  /// eg. exchange1:`a.b.c`d.e.f`h.i.j;exchange2:`k.l`m.n`o.p;exchange3:`q.r`s.t`u.v
  /// OR exchange1:`a.b.c,`d.e.f,`h.i.j;exchange2:`k.l,`m.n,`o.p;exchange3:`q.r,`s.t,`u.v
  /// OR exchange1:`a.b.c`d.e.f`h.i.j;exchange2:`k.l`m.n`o.p;exchange3:`q.r`s.t`u.v
  member val QRouting : string = qrouting0 with get,set
  // e.g. (exchange,["";"";""])
  //member val FSRoutingPairs = "" with get,set
  member val RoutingPairs : RoutingPair list = [] with get,set

  /// dsc: there are two ways to provide a list of routing pairs: 1. in a Q-List
  member this.GetRoutingPairs0(defaultExchange) : RoutingPair list = 
    let L = List.append (RoutingPair.fromQKVs this.QRouting) this.RoutingPairs
    let RPL=(if L = [] then [RoutingPair("",this.name)] else L)
    RoutingPair.blendInDefaults RPL (this.name) defaultExchange
  member this.GetRoutingPairs0(defaultExchange:ExDef) : RoutingPair list = 
    this.GetRoutingPairs0(defaultExchange.name)
  member this.GetRoutingPairs0() : RoutingPair list = 
    this.GetRoutingPairs0("")

  member this.ResetRoutingPairs() = 
    _RoutingPairs <- None

  /// dsc: convenience property for the To syntax
  member this.GetRoutingPairs(defaultExchange:string) : RoutingPair list =
    if _RoutingPairs = None then
      _RoutingPairs <- Some(this.GetRoutingPairs0(defaultExchange))  // !!!<-- this doesn't have the ability to do a lazy link via an exchange.  We allow lazy exchange define in other places.  What should we do?
    _RoutingPairs.Value
  member this.GetRoutingPairs(defaultExchange:ExDef) : RoutingPair list =
    this.GetRoutingPairs(defaultExchange.name)
  member this.GetRoutingPairs() : RoutingPair list =
    this.GetRoutingPairs("")

  // queues are bound to n (exchange, routingKey) pairs

  /// dsc: If set, the server will reply with Declare-Ok if the queue already
  /// exists with the same name, and raise an error if not.  The client can
  /// use this to check whether a queue exists without modifying the
  /// server state.  When set, all other method fields except name and no-wait
  /// are ignored.  A declare with both passive and no-wait has no effect.
  /// Arguments are compared for semantic equivalence.
  member val passive = false with get,set
  /// dsc: If set when creating a new queue, the queue will be marked as durable. Durable
  /// queues remain active when a server restarts. Non-durable queues (transient
  /// queues) are purged if/when a server restarts. Note that durable queues do not
  /// necessarily hold persistent messages, although it does not make sense to send
  /// persistent messages to a transient queue.
  member val durable = false with get,set
  /// dsc: Exclusive queues may only be accessed by the current connection, and are
  /// deleted when that connection closes.  Passive declaration of an exclusive
  /// queue by other connections are not allowed.
  member val exclusive = false with get,set
  /// dsc: If set, the queue is deleted when all consumers have finished using it.  The last
  /// consumer can be cancelled either explicitly or because its channel is closed. If
  /// there was no consumer ever on the queue, it won't be deleted.  Applications can
  /// explicitly delete auto-delete queues using the Delete method as normal.
  member val autoDelete = false with get,set
  /// dsc: If set, the server will not respond to the method. The client should not wait
  /// for a reply method. If the server could not complete the method it will raise a
  /// channel or connection exception.
  member val noWait = false with get,set
  /// dsc: a placeholder.  When true, this record was created after the queue was found on the broker.
  /// the configuration has to be handled elsewhere
  member val isStub = false with get,set
  /// This flag tells the server how to react if the message cannot be routed to a
  /// queue. If this flag is set, the server will return an unroutable message with a
  /// Return method. If this flag is zero, the server silently drops the message.
  /// usage: use when publishing to the queue
  member val mandatory = false with get,set
  /// This flag tells the server how to react if the message cannot be routed to a
  /// queue consumer immediately. If this flag is set, the server will return an
  /// undeliverable message with a Return method. If this flag is zero, the server
  /// will queue the message, but with no guarantee that it will ever be consumed.
  /// usage: use when publishing to the queue
  member val immediate = false with get,set
  member val Nskk : string option = None with get,set
  //member val Ref : string option = None with get,set
  interface INskk with
    member this.Nskk  with get() = this.Nskk |>(function|None->""|Some(x)->x) and set(value) = this.Nskk<-value|>(function|""|null->None|x->Some(x))
  
  /// dsc: these are provided seperately at queue.declare time
  /// however, the management plugin also returns these in one document via the management plugin
  /// so although these items are presently ignored, they are provided here for completeness
  // TODO: work out what the compatibility between arguments (here) and a list of XPairs is
  member val arguments : KeyValuePair<string,obj> list = [] with get,set

  interface IAmqpExtension with
    //member val Arguments : IDictionary<string,obj> = null with get,set
    /// dsc: vendor specific extensions to the AQMP specification.  NB. our extensions + extensionRefs properties are .Net based helper hacks to make this a little easier to deal with in attributed form
    //member val Arguments : IDictionary<string,obj> = null with get,set
    /// dsc: The RabbitMQ Server implements a number of extensions of the AMQP specification
    member val X_Pairs : XPair list = [] with get,set
    /// dsc: a csv list of references to extensions attributes
    member val X_Refs : string = null with get,set

  member val Grp : string = "" with get,set

  // TODO: do we care about Nskk in this situation?  For now no unless a scenario comes up that needs it.
  interface IMatchGrp with member this.Grp with get() = this.Grp
  interface IMatchWhen with member this.When with get() = this.name

  new(qrouting) = 
    // unique queue name might be assigned by the RabbitMQ broker.  
    //MQDef(Guid.NewGuid().ToString(),qrouting)
    let nme = RoutingPair.queueNameFrom qrouting
    // This make sense for multiple worker nodes, but how about but what about other routing styles?  
    MQDef(nme,qrouting)
  new() = MQDef("","")
  
/// nme: federation upstream
/// ref: http://www.rabbitmq.com/federation.html
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type FedUpstreamDef() = 
  inherit Attribute()
  
  // TODO: add an actual convenient Uri
  member val uri : string = "" with get,set

  member val arguments : KeyValuePair<string,obj> list = [] with get,set

  interface IAmqpExtension with
    /// The RabbitMQ Server implements a number of extensions of the AMQP specification
    member val X_Pairs : XPair list = [] with get,set
    /// a csv list of references to extensions attributes
    member val X_Refs : string = null with get,set

  member val Grp : string = "" with get,set
  interface IMatchGrp with member this.Grp with get() = this.Grp

/// nme: High Availability Definition
/// ref: http://www.rabbitmq.com/ha.html
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
type HaDef() = 
  inherit Attribute()

  member val haMode : string = "" with get,set
  member val haParams : string = "" with get,set
  member val haSyncMode : string = "" with get,set

/// nme: Exchange Register Entry
type ExRegEntry(meta) =
  member val Meta = meta : ExDef with get,set
  member val IsOpen : bool = false with get,set
  member val Last : DateTime = DateTime.MinValue with get,set
  member val Fr : DateTime = DateTime.MinValue with get,set
  member val To : DateTime = DateTime.MaxValue with get,set

/// nme: Message Queue Register Entry
type MQRegEntry(meta) = 
  member val Meta = meta : MQDef with get,set
  member val IsOpen : bool = false with get,set
  member val Last : DateTime = DateTime.MinValue with get,set
  member val Bindings : RoutingPairRegEntry list = [] with get,set
  member val Fr : DateTime = DateTime.MinValue with get,set
  member val To : DateTime = DateTime.MaxValue with get,set

type Ns(ns) = 
  inherit Attribute()
  member val Ns : string = ns with get,set
  new(ns) = Ns(ns)
  new() = Ns("")

/// allows methods and classes to filter 
/// rules: expect only one entry with no selector.  If caller does not specify a selector, then we take the first available with no selector, or the first available second.  When specified, we select we take empty (when empty), or match based on the provided value.
/// with: match patterns in QList format
/// when: when these rules should appy.  A selector to choose when these patterns should apply
[<AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)>]
// TODO: apply AttributeUsage to all attribute types
type MatchDef(when_,grp_) =
  inherit Attribute()
  /// currently this is just a single filter, and not a QList of filters
  /// TODO: integrate the QList approach so that we can provide a list of filters that are blended together using the "or" relational operator.
  member val When : string = when_ with get,set
  /// the selector is another tag.  Say there is information relating to two different channels here, and we refer to them programatically
  member val Grp : string = grp_ with get,set
  member val Nskk : string = "" with get,set
  member this.Matcher with get() = if String.IsNullOrEmpty(this.When) then None else Some(Parse.getWildcardSearch(this.When))
  new(when_) = MatchDef(when_,"")
  new() = MatchDef("","")

module DefHelper =

  open FSharp.Control.X_FSharp
  
  let filterMQAttributes(attributes : Attribute list) =
    let xpairType = typedefof<XPair>
    attributes |> List.filter
      (fun x->        
        if xpairType.Is1 x then
          true
        else 
          match x with
          | :? ExDef -> true
          | :? RoutingPair -> true
          | :? PubSubContext -> true
          | :? MQBindingDef -> true
          | :? MQDef -> true
          | :? CcDef -> true
          | :? QosDef -> true
          | :? ConsrDef -> true
          | :? PubDef -> true
          | :? CxDef -> true
          | _ -> false
      )

// Q) should we deprecate our "Ref" scheme in favour of the RabbitMQ "Policy" scheme

// Q) what namespace should these MQ functions migrate to?
//    I do not want a company name in the namespace
//    X_RMQ
//    but is it an extension to RabbitMQ, or is it generic to message queues in general? 
