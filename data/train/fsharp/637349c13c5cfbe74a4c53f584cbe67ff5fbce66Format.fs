namespace Format

module Text = 

    let Process (value:string) (index:int) (suffix:string) = 
        value.[0 .. index] + suffix
        |> fun x -> x.Insert (x.Length - 2, ".")

    let PrettyPrint (value:string) = 
        let len = value.Length

        if (value.Length > 4) then
            match (value.[0] = '-') with
            | true  when len > 10 -> Process value (len - 9) "b"
            | true  when len > 7  -> Process value (len - 6) "m"
            | true  when len > 4  -> Process value (len - 3) "k"
            | false when len > 9  -> Process value (len - 9) "b"
            | false when len > 6  -> Process value (len - 6) "m"
            | false when len > 3  -> Process value (len - 3) "k"
            | _ -> value
        else
            value

    let PrettyPrintFromInt (value:bigint) =
        PrettyPrint (string value)
        
    let PrettyPrintFromSingle (value:single) = 
        match value with
        | x when x < single infinity -> PrettyPrint (string (bigint value))
        | _ -> "0"

    let PrettyPrintFromDouble (value:double) = 
        PrettyPrint (string (bigint value))