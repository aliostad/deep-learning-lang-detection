module PiTools

open System

// save the previous read page
let mutable backPage = 0

/// list of differents actions allowed
type SequenceKeyEnum =
        | First
        | Numbers
        | Quit
        | Previous
        | Next
        | Home
        | End
        | Back
        | None

/// link between the differents actions allowed and keyboard touch
let SequenceKey = dict
                    [
                        (SequenceKeyEnum.Numbers, seq {48 .. 54} |> Seq.cast<ConsoleKey>); // Key.D0 to key.D6
                        (SequenceKeyEnum.Quit, seq [ConsoleKey.Escape; ConsoleKey.Q]);
                        (SequenceKeyEnum.Previous, seq [ConsoleKey.P; ConsoleKey.PageUp; ConsoleKey.UpArrow; ConsoleKey.LeftArrow]);
                        (SequenceKeyEnum.Next, seq [ConsoleKey.N; ConsoleKey.PageDown; ConsoleKey.DownArrow; ConsoleKey.RightArrow; ConsoleKey.Tab]);
                        (SequenceKeyEnum.Home, seq [ConsoleKey.Home; ConsoleKey.H]);
                        (SequenceKeyEnum.End, seq [ConsoleKey.End; ConsoleKey.E; ConsoleKey.L]);
                        (SequenceKeyEnum.Back, seq [ConsoleKey.B]);
                        (SequenceKeyEnum.First, seq [ConsoleKey.F])
                    ]

/// test if the entering key is include into a sequence of keys
let isKeyInSequence(sequenceKeyEnum : SequenceKeyEnum, keyToFind : ConsoleKeyInfo) : bool =
        SequenceKey.Item sequenceKeyEnum
            |> Seq.exists( fun tmpKey -> tmpKey.Equals(keyToFind.Key))

/// Get the Sequence Name enum by using a Key sequence enum
/// Have a look on the dictionnary of sequences keys
/// <return>Sequence Key Enum option</return>
let getSequenceByKey (keyToFind : ConsoleKeyInfo) : SequenceKeyEnum =
        match SequenceKey
                    |> Seq.tryFind(fun seqKeyValue -> isKeyInSequence(seqKeyValue.Key, keyToFind)) with
        | Some keyval -> keyval.Key // if found
        | _ -> SequenceKeyEnum.None // if not found

/// <summary>Extract the number on for the Key Number string</summary>
/// <param name="varKey">key from the console entrance</param>
/// <return>number of the content key</return>
let extractNumberOnKey(varKey: ConsoleKeyInfo) =
    (*
       from "D0", get "0"
       from "D1", get "1"
       from "D2", get "2"
       ... 
    *)
    let numberKeyContaint = (varKey.Key.ToString().ToCharArray() |> Seq.last).ToString()
    let (tryParseKey, numKey) = Int32.TryParse(numberKeyContaint)
    numKey

/// Manage the console by listening the keyboard and changing chapters
/// <return>number of new selected chapter</return>
let functionNextSection (valDict: int) (lengthDict: int) : int =
    Console.WriteLine("\nPress a key to continue ...")

    let key = Console.ReadKey()
    Console.Clear()

    let newPage =
        match getSequenceByKey(key) with
        (* quit *)                 | SequenceKeyEnum.Quit -> -1
        (* backPage *)             | SequenceKeyEnum.Back -> backPage
        (* home *)                 | SequenceKeyEnum.Home -> 0
        (* first chapter *)        | SequenceKeyEnum.First -> 1
        (* end *)                  | SequenceKeyEnum.End -> lengthDict - 1
        (* directly pageNumber *)  | SequenceKeyEnum.Numbers -> extractNumberOnKey(key)
        (* previous *)             | SequenceKeyEnum.Previous when valDict > 0 -> valDict - 1
        (* next *)                 | SequenceKeyEnum.Next when valDict < lengthDict - 1 -> valDict + 1
        (* nothing *)              | _ -> valDict

    backPage <- valDict
    newPage
