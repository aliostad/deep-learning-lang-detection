namespace Excho.Trading

open System
open Excho.Logistics

type IExchange<'m, 'p> =
  abstract member Merchandise : HalfExchange<'m, 'p> seq
  abstract member Price : HalfExchange<'p, 'm> seq
and HalfExchange<'m, 'p> = 'm Quantitizable * ExchangeChannel<'m, 'p>
and ExchangeChannel<'m, 'p> = Outbox<'m> * Inbox<'p>

type Exchange<'m, 'p> = Merchandise<'m, 'p> * Price<'p, 'm>
and Merchandise<'m, 'p> = HalfExchange<'m, 'p>
and Price<'p, 'm> = HalfExchange<'p, 'm>

module Exchange =
  let toTransfers (exchanges : Exchange<'m, 'p> seq) =
    let fullTransfers =
      exchanges
      |> Seq.map (fun ((qm, (om, ip)), (qp, (op, im))) ->
        let delivery : Transfer<_> = if om <=> im then (om, qm), im else raise (Exception())
        let payment : Transfer<_> = if op <=> ip then (op, qp), ip else raise (Exception())
        delivery, payment
      )
      |> Seq.toArray
    let halfTransfers f = fullTransfers |> Seq.map f |> mergeTransfers

    fst |> halfTransfers,
    snd |> halfTransfers
  let (<->) (merchandise : HalfExchange<'m, 'p> seq) (price : HalfExchange<'p, 'm> seq) =
    let deliveries, payments = Seq.zip merchandise price |> toTransfers

    deliveries  |> Seq.iter processTransfer
    payments    |> Seq.iter processTransfer
  let inline processExchange (exch : IExchange<'m, 'p>) = exch.Merchandise <-> exch.Price