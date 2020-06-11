namespace Validator

open System
open Models

module internal  Infrastructure =

    type ValidationProcessData = {
            Violations: Violation list
            Data: Employee
        }

    let isNotEmptyString data = not <| System.String.IsNullOrWhiteSpace(data)
    let isGreaterThan threshold (data:Money) = data > threshold
    let isLowerThan threshold (data:Money) = data < threshold
    let occurredBefore (firstDate:DateTime, secondDate:DateTime) = firstDate < secondDate
    let occuredAtLeastYearsAgo (years:int) (date:DateTime) = date <= DateTime.Now.AddYears(-1 * years) 

    let appendViolation severity message data = 
        { data with Violations = { Message = message; Severity = severity } :: data.Violations }
        
    let packItem item = 
        { Violations = []; Data = item }
    
    let returnValidationResult item =
        item.Violations |> Seq.ofList

    let (>=>) (item:Employee) (validationAction: ValidationProcessData -> ValidationProcessData) =
        packItem item |> validationAction

    let check (predicate: _ -> bool) (input: Option<_>) =
        match input with
        | Option.None -> Option.None
        | Option.Some x -> match predicate x with
                            | true -> Option.Some x
                            | false -> Option.None
         
    let given input =
        Option.Some input

    let thenIfNot severity (data:ValidationProcessData) message result =
        match result with
        | Option.None -> data |> appendViolation severity message
        | _ -> data
    
    let thenIfNotAddError (data:ValidationProcessData) message result =
        thenIfNot SeverityLevels.High data message result

    let thenIfNotAddWarning (data:ValidationProcessData) message result =
        thenIfNot SeverityLevels.Low data message result

    let andAlso f e =
        f e

    let needsTo f e =
        e >=> f