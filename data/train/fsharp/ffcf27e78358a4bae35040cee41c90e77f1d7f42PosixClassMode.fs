namespace RegexModeler

open RegexModeler.Interfaces
open ListHelpers

type PosixClassMode (quantifier, charGenerator, charSet) =
    
    let quantifier = quantifier :> IQuantifier
    let charGenerator = charGenerator :> ICharGenerator
    let charSet = charSet :> ICharSet

    member x.extractPosixClass input = 
        let rec extractReversePosixClass acc rest = 
            match rest with
            | ':'::']'::cs  -> (acc, cs)
            | c::cs         -> extractReversePosixClass (c::acc) cs
            | _otherwise    -> raise <| InvalidCharacterSetException "Malformed POSIX identifier"        
        
        let (posixClass, rest) = extractReversePosixClass [] input
        (posixClass |> List.rev |> chrsToString, rest)


    member x.processInMode = (x :> IParseMode).processInMode

    interface IParseMode with 

        member x.processInMode inputList = 
            let (posixClass, rest) = x.extractPosixClass inputList
            let classChars = charSet.GetPosixCharSet posixClass
            let n, remainder = quantifier.processQuantifier rest
            (charGenerator.GetNListChars n classChars, remainder)
