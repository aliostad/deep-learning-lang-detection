
module Botijo.Bot

open System
open IRCbot.Util
open Botijo.Plugins

let nick = "botijo"

let CommandHandler (user: string) (dest: string) (text: string) (write: string -> unit) =
    let say text = write (sprintf "PRIVMSG %s :%s" dest text)
    
    match text with
    | Match @"^!(?:g(?:oogle)?) (.*)$" [what] -> say (Google.ImFeelingLucky what)
    | Match @"^!(?:date)(?: .*)?$" _ -> say (sprintf "%A" DateTime.Now)
    | Match @"^!(?:lol)?cat(?: .*)?$" _ -> say (Lolcats.RandomLolcat())
    | _ -> say "I don't have such command"
    

let msgHandler (line: string) (write: string -> unit) =

    let say dest text = write (sprintf "PRIVMSG %s :%s" dest text)
    
    match line with
    | Message (JOIN(user, channel)) when user = nick -> say channel "Hello world!"
    | Message (PRIVMSG(user, dest, text) as privmsg) when text.StartsWith "!" -> (CommandHandler user dest text write)
    | _ -> ()