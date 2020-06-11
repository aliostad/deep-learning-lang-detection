namespace FSharp.Control.RabbitMQ

exception GlobalExtensionNotFound of string
exception QueueAlreadyRegistered of string
exception ExchangeAlreadyRegistered of string

exception NoSuchQueueInRegister of string
exception NoSuchExchangeInRegister of string

exception BindingNotFound of string

/// dsc: we keep definitions about exchanges, queues, bindings, channels and connections here.
/// One day we may share this information, or persist it somewhere such as a DB or Redis blob server.  Maybe a configuration file.
/// perhaps code based & versionable configuration is best for anything that does not need to be real-time
module RegisterHelper =
  open System
  open System.Collections.Generic
  open FSharp.Control.RabbitMQ

  let registerExchanges (exchanges0 : ExDef list) (_to : Dictionary<string, ExRegEntry>) (passive:bool) =
    exchanges0 
        |> List.iter 
              (fun X->
                let isThere = _to.ContainsKey(X.name)
                if isThere && (not passive) then
                  raise <| QueueAlreadyRegistered(sprintf "'%s'" X.name)
                elif not isThere then
                  _to.Add(X.name,ExRegEntry(X))
                  )

  // dsc: registeres queue meta underneath the correct exchange umbrella
  // passive: when passive, no error is thrown when the queue already exists
  // if the exchange does not exist, we *do* throw an error.  "passive" does not change the need for exchange presence
  let registerQueues (queues0 : MQDef list) (_to : Dictionary<string, MQRegEntry>) (passive:bool) =
    queues0 
      |> List.iter 
            (fun q->
             let isThere = _to.ContainsKey(q.name)
             if isThere && (not passive) then
               raise <| QueueAlreadyRegistered(sprintf "'%s'" q.name)
             elif not isThere then
               _to.Add(q.name,MQRegEntry(q))
               )
  let getExchange0 nme (_fr : Dictionary<string, ExRegEntry>) =
    if _fr.ContainsKey(nme) then Some(_fr.[nme].Meta)else None
  let getQueue0 (queue:string) (_fr : Dictionary<string, MQRegEntry>) =
    if _fr.ContainsKey(queue) then 
      Some(_fr.[queue].Meta) 
    else 
      None

open RegisterHelper

/// dsc: this module defines all exchanges and queues
module Register =

  // TODO: queues can optionally be set to expire on the broker

  open System
  open System.Collections.Generic
  open FSharp.Control.RabbitMQ

  /// dsc: various custom queue, binding, exchange, channel, consumer, publisher settings that may be set
  /// this is a global cach of XPair items (eg. settings for queue, binding, exchange, channel, consumer, and publisher)
  let ns = Dictionary<string, Dictionary<string,Attribute>>()

  /// extensions are defined in code
  let Extensions = Dictionary<string, obj>()
  let Exchanges = Dictionary<string, ExRegEntry>()
  let Queues = Dictionary<string, MQRegEntry>()
  let ByType = Dictionary<Type, Attribute list>()

  let RegisterExchanges(exchanges : ExDef list) =
    registerExchanges exchanges Exchanges true
  let RegisterExchange(exchange) =
    registerExchanges [exchange] Exchanges true
    exchange

  let RegisterQueues(queues : MQDef list) =
    registerQueues queues Queues true
  let RegisterQueue(queue : MQDef) =
    registerQueues [queue] Queues true
    queue

  let getExchange (exchange:string option) = 
    if exchange.IsSome && (not <| String.IsNullOrEmpty(exchange.Value)) then
      getExchange0 exchange.Value Exchanges
    else
      None

  let getExRegEntry exchange =
    if Exchanges.ContainsKey(exchange) then
      Some(Exchanges.[exchange])
    else
      None

  let getMQRegEntry queue = 
    if Queues.ContainsKey(queue) then
      Some(Queues.[queue])
    else
      None

  let getQueue queue =
    getQueue0 queue Queues

  let setQueueOpen(queue:MQDef) = 
    try Queues.Add(queue.name, MQRegEntry(queue)) with | _ -> ()
    let item = Queues.[queue.name]
    item.IsOpen <- true

  let setExchangeOpen (exchange:ExDef) = 
    try Exchanges.Add(exchange.name, ExRegEntry(exchange)) with | _ -> ()
    let item = Exchanges.[exchange.name]
    item.IsOpen <- true

  /// dsc: did this instance know that the queue was once/could now still be declared?
  /// not a locked operation.  We trust in the "guaranteed delivery" promise
//  let isQueueOpen queue = 
//    Queues.[queue].IsOpened

  let isQueueBindingBound queue (routingPair: RoutingPair) = 
    let item = Queues.[queue]
    match item.Bindings |> List.filter(fun x->x.Meta = routingPair) with
    | [] -> raise<|BindingNotFound(sprintf "'%s' not found" (routingPair.ToString()))
    | [binding] -> binding.IsOpen
    | binding :: rest ->  binding.IsOpen

  let setQueueBindingBound queue (routingPair: RoutingPair) = 
    let item = Queues.[queue]
    let RoutingPairRegEntry =
      match item.Bindings |> List.filter(fun x->x.Meta = routingPair) with
      | [] -> 
          let RoutingPairRegEntry = RoutingPairRegEntry(routingPair)
          item.Bindings <- item.Bindings @ [RoutingPairRegEntry]
          RoutingPairRegEntry
      | [binding] -> binding
      | binding::rest -> binding
    RoutingPairRegEntry.IsOpen <- true

  /// dsc: has this instance declared this exchange at least once
  /// We trust in the guaranteed-delivery / guaranteed-existence (if durable) promise
  let isExchangeOpen exchange = 
    if Exchanges.ContainsKey exchange then
      Exchanges.[exchange].IsOpen
    else
      false

  let isExchangeRegistered exch = 
    Exchanges.ContainsKey exch

  let isQueueRegistered queue = 
    Queues.ContainsKey queue

  /// has queue yet been declared by this instance
  /// We trust in the guaranteed-delivery / guaranteed-existence (if durable) promise
  let isQueueOpen queue = 
    if Queues.ContainsKey(queue) then
      Queues.[queue].IsOpen
    else
      false

  let defaults = Some(PubSubContext())
