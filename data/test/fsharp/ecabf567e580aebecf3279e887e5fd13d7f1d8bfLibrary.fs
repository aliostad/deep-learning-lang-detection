namespace MessageRouter.Tests

open FsCheck
open MessageRouter.Common
open MessageRouter.SampleDomains.Arithmetic.Addition
open MessageRouter.SampleDomains.Arithmetic.Subtraction
open MessageRouter.SampleDomains.Arithmetic.Multiplication
open MessageRouter.SampleDomains.Arithmetic.Division
open MessageRouter.SampleDomains.Banking
open System
open System.Collections.Concurrent
open System.Collections.Generic

/// An IResolver backed by a ConcurrentDictionary
type SimpleResolver (items) =
  let kvPair (k,v) = KeyValuePair (k,v)
  let catalog = ConcurrentDictionary<_,_> (items |> Seq.map kvPair)

  new () = SimpleResolver (Seq.empty)

  member __.Add (info,item) = 
    if item.GetType () <> info then failwith "Type mismatch!"
    catalog.AddOrUpdate (info,item,fun _ _ -> item) |> ignore

  member __.CanResolve info = catalog.ContainsKey info

  member __.Get info = match catalog.TryGetValue info with
                       | true,value  -> value
                       | _           -> null

  member R.Get () : 'info = typeof<'info> 
                            |> R.Get 
                            |> unbox<_>

  interface IResolver with
    member R.CanResolve info  = R.CanResolve info
    member R.Get        info  = R.Get        info
    member R.Get        ()    = R.Get        () 

/// Utilities to help building resolvers for various sample domains
module DomainResolvers =
  /// Builds a new IResolver pre-loaded with all handlers from the Arithmentic domain
  let arithmetic store cache =
    let items = 
      [ // addition
        (typeof<AddCommandHandler>,box <| AddCommandHandler store)
        (typeof<AddedEventHandler>,box <| AddedEventHandler ())
        // multiplication
        (typeof<MultiplyCommandHandler>       ,box <| MultiplyCommandHandler        ()   )
        (typeof<InfixMultipliedEventHandler>  ,box <| InfixMultipliedEventHandler   cache)
        (typeof<PrefixMultipliedEventHandler> ,box <| PrefixMultipliedEventHandler  cache)
        (typeof<PostfixMultipliedEventHandler>,box <| PostfixMultipliedEventHandler cache)
        // subtraction
        (typeof<FailingSubtractedEventHandler>,box <| FailingSubtractedEventHandler ())
        // division
        (typeof<FailingDivideCommandHandler>,box <| FailingDivideCommandHandler ()) ]
    (SimpleResolver items :> IResolver)

  /// Fills an existing SimpleResolver with all handlers from the Banking domain
  let fillBanking commandRouter eventRouter (resolver:SimpleResolver) =
    [ // command handlers
      (typeof<DebitCommandHandler> , box <| DebitCommandHandler  commandRouter)
      (typeof<CreditCommandHandler>, box <| CreditCommandHandler eventRouter  )
      // event handlers
      (typeof<DebitOkEventHandler>   , box <| DebitOkEventHandler    ()           )
      (typeof<DebitErrorEventHandler>, box <| DebitErrorEventHandler commandRouter)
      (typeof<CreditEventHandler>    , box <| CreditEventHandler     ()           )]
    |> Seq.iter resolver.Add
    resolver :> IResolver
 
/// Utilities to help random generation of types from various sample domains
module Gen =
  /// Provides a generator for random commands or events from the Arithmetic domain
  let arithmeticMsg ctor =
    gen { let!  NonZeroInt one,
                NonZeroInt two =  Arb.generate<NonZeroInt> |> Gen.two
          return ctor (one,two) |> (box >> unbox<_>) }
  
  /// Provides a generator for random commands or events from the Banking domain  
  let bankingPos ctor =
    gen { let! amount = Arb.generate<decimal> 
                        |> Gen.suchThat (fun amt -> sign amt <> -1)
          return ctor amount }

  /// Provides a generator for random commands or events from the Banking domain  
  let bankingNeg ctor =
    gen { let! amount = Arb.generate<decimal> 
                        |> Gen.suchThat (fun amt -> sign amt = -1)
          return ctor amount }
  
/// Generates commands or events from the Arithmetic sample domain
type Arithmetic =

  /// Generates an ICommand randomly (favoring Multiplication, then Addition)
  static member Command :Arbitrary<ICommand> =
    Gen.frequency [ (2,Gen.arithmeticMsg (fun (a,b) -> AddCommand       (a,b)))
                    (4,Gen.arithmeticMsg (fun (a,b) -> MultiplyCommand  (a,b)))
                    (1,Gen.arithmeticMsg (fun (a,b) -> SubtractCommand  (a,b)))
                    (1,Gen.arithmeticMsg (fun (a,b) -> DivideCommand    (a,b))) ]
    |> Arb.fromGen
  
  /// Generates an IEvent randomly
  static member Event :Arbitrary<IEvent> =
    Gen.oneof [ Gen.arithmeticMsg (fun (a,b) -> AddedEvent      (a,b,a + b))
                Gen.arithmeticMsg (fun (a,b) -> MultipliedEvent (a,b,a * b))
                Gen.arithmeticMsg (fun (a,b) -> SubtractedEvent (a,b,a - b))
                Gen.arithmeticMsg (fun (a,b) -> DividedEvent    (a,b,a / b)) ]
    |> Arb.fromGen

/// Generates commands or events from the Banking sample domain
type Banking =

  /// Generates an ICommand randomly (favoring Debits over Credits)
  static member Command =
    let isNegative,notNegative = true,false
    Gen.frequency [ (2,Gen.bankingNeg (fun amt -> let act = Guid.NewGuid ()
                                                  DebitCommand (act,amt)
                                                  :> ICommand) )
                    (1,Gen.bankingPos (fun amt -> let act = Guid.NewGuid ()
                                                  CreditCommand (act,amt)
                                                  :> ICommand)) ]
    |> Arb.fromGen

  /// Generates an IEvent randomly
  static member Event =
    Gen.oneof [ Gen.bankingNeg (fun amt ->  let act = Guid.NewGuid ()
                                            let now = DateTime.UtcNow
                                            DebitOkEvent (act,amt,now)
                                            :> IEvent)
                Gen.bankingNeg (fun amt ->  let act = Guid.NewGuid ()
                                            let now = DateTime.UtcNow
                                            DebitErrorEvent (act,amt,now)
                                            :> IEvent)
                Gen.bankingPos (fun amt ->  let act = Guid.NewGuid ()
                                            let now = DateTime.UtcNow
                                            CreditEvent (act,amt,now)
                                            :> IEvent) ]
    |> Arb.fromGen
