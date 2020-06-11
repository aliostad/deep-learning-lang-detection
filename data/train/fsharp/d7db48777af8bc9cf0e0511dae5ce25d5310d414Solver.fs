namespace runner

module Solver =
  open System
  open helpers

  let addToBot v bot bots = 
    match bots |> Map.tryFind bot with
    | Some (xs, z, w) -> bots |> Map.add bot (v::xs |> List.truncate 2 |> List.sort, z, w)
    | None -> bots |> Map.add bot ([v], "", "") // add bot/output

  // a bot can be processed if it has at least two values to pass along (lo and hi)
  let canProcess (bot:string) (xs, _, _) = bot.[0] = 'b' && xs |> Seq.length = 2

  // move values from one bot to its lo and hi destinations
  // does nothing if the bot does not have enough values to pass through
  let passValues from bots =
    match Map.tryFind from bots with
    | Some ([loVal; hiVal], loBot, hiBot) ->
        bots
        |> addToBot loVal loBot // add to low bot 
        |> addToBot hiVal hiBot // add to high bot
        |> Map.add from ([], loBot, hiBot) // remove values from "from" bot
    | Some _ -> bots // there are not enough values to pass through (ie. this bot cannot be processed)
    | None -> failwithf "There's no bot '%s'" from

  // process until predicate returns true or there are no more bots to process
  let rec processUntil predicate bots = 
    match Map.tryFindKey canProcess bots with
    | Some bot when not <| predicate bots.[bot]->
      passValues bot bots
      |> processUntil predicate
    | _ -> bots

  let parseInput input = 
      input
      |> Seq.fold (fun state line ->
            match line with
            | Match.RegexMatch @"bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)" [_; origin; lowType; low; highType; high] ->
                let lowBot = match lowType.Value with "bot" -> "b" + low.Value | _ -> "o" + low.Value
                let highBot = match highType.Value with "bot" -> "b" + high.Value | _ -> "o" + high.Value
                state |> Map.add ("b" + origin.Value) ([], lowBot, highBot)
            | Match.RegexMatch @"value (\d+) goes to bot (\d+)" [_; value; bot] -> addToBot (int value.Value) ("b" + bot.Value) state
            | x -> failwithf "%s is not a valid input" x
      ) Map.empty
      
  let findCommon x y bots = 
    let botContainsXAndY = (fun (xs, _, _) -> xs = [x;y] || xs = [y;x])
    let res = processUntil botContainsXAndY bots |> Map.toArray |> Array.where (fun (_, value) -> botContainsXAndY value) |> Array.head |> fst
    res.[1..]

  // returns final values of bots which satisfy the predicate
  let finalValuesOf predicate bots = 
    bots
    |> processUntil (fun _ -> false) // process everything
    |> Map.toSeq
    |> Seq.where (fun (bot, _) -> predicate bot)
    |> Seq.collect (fun (_, (xs, _, _)) -> xs)
