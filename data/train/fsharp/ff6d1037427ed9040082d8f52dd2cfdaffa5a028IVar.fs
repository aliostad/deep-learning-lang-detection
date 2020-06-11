namespace JoinCML.Examples

// An implementation of IVar supporting exceptions using only channels.
//
// Compared to CML, JoinCML seems to often require more complex implementations
// of concurrent abstractions in order to support the join operation.  In this
// respect JoinCML is similar to TE as described in
//
//   Programming Idioms for Transactional Events
//   http://arxiv.org/pdf/1002.0936.pdf
//
// In the case of IVar, the complication is that we want it to be possible to
// read a single IVar multiple times within a single synchronous operation.
// This is not necessary with CML, due to lack of join, so a simpler approach
// works in CML.
//
// In order to make multiple reads possible, we implement read operations in RPC
// -style.  Reads are replied to by the IVar server asynchronously. Furthermore,
// it is necessary to manage read requests before the IVar is filled.

open System.Collections.Generic
open JoinCML

type IVar<'x> =
  inherit AltDelegate<'x>
  val fill: Ch<Choice<'x, exn>>
  new () as xI =
    let read = Ch ()
    {inherit AltDelegate<_> (read *<+-> fun rCh n -> (rCh, n)
                             ^-> function Choice1Of2 x -> x
                                        | Choice2Of2 e -> raise e)
     fill = Ch ()} then
    let serveFull r =
      read ^-> fun (replyCh, _) ->
        replyCh *<-+ r
    let drainFull =
      xI.fill ^->. () // XXX log spurious fill error

    let reads = LinkedList<Ch<Choice<'x, exn>>> ()
    let nackCh = Ch ()

    let rec serveEmpty () =
          xI.fill ^-> fun r ->
            serveFull r |> forever |> Async.Start
            drainFull |> forever |> Async.Start
            reads |> Seq.iter (fun replyCh -> replyCh *<-+ r)
      <|> read ^=> fun (replyCh, nack) ->
            let node = newLinkedListNode replyCh
            Alt.start <| nack ^-> fun () -> nackCh *<-+ node
            reads.AddLast node
            serveEmpty ()
      <|> nackCh ^=> fun node ->
            reads.Remove node
            serveEmpty ()
       |> Alt.sync

    serveEmpty () |> Async.Start

module IVar =
  let fill (xI: IVar<_>) x = xI.fill *<-+ Choice1Of2 x
  let fillFailure (xI: IVar<_>) e = xI.fill *<-+ Choice2Of2 e

type IVar<'x> with
  new (x: 'x)  as xI = IVar<'x> () then IVar.fill xI x
  new (e: exn) as xI = IVar<'x> () then IVar.fillFailure xI e
