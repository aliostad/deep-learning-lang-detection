namespace Pdg.Splorr.MerchantsAndTraders.BusinessLayer

module ServiceResult = 
    type ServiceResult<'TPayload> =
        | Success of 'TPayload
        | Failure of seq<string>

    type ServiceListResult<'TPayload> =
        ServiceResult<seq<'TPayload>>

    let bind processFunction payload =
        match payload with
        | Success s -> processFunction s
        | Failure f -> Failure f

    let map processFunction =
        bind (processFunction >> Success)

    let (>>=) payload processFunction =
        bind processFunction payload

