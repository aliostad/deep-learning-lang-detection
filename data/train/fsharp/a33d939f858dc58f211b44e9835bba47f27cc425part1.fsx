open System;;
open System.Text.RegularExpressions;;

exception Ex of string;;

let rexmatch pat str =
    let m = Regex.Match(str, pat) in
    if m.Groups.Count = 0 then
        []
    else
        List.tail [ for g in m.Groups -> g.Value ]
;;

let parseTriangle line =
    let parts = rexmatch "^\s*(\d+)\s*(\d+)\s*(\d+)\s*$" line in
    match parts with
    | side1 :: side2 :: side3 :: [] -> (Convert.ToInt32(side1), Convert.ToInt32(side2), Convert.ToInt32(side3))
    | _ -> raise (Ex (sprintf "invalid triangle! %s" line))
;;

let isValidTriangle (s1, s2, s3) =
    ((s1 + s2) > s3) &&
    ((s2 + s3) > s1) &&
    ((s1 + s3) > s2)
;;

let rec processLines numValid =
    let line = Console.ReadLine() in
    if String.length line = 0 then
        numValid
    else
        let tri = parseTriangle line in
        let inc = if isValidTriangle tri then 1 else 0 in
        processLines (numValid + inc)
;;

printfn "%d valid triangles" (processLines 0)
