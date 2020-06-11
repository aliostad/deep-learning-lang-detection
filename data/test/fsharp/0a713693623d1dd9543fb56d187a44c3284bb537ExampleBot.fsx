#I "/Users/santialbo/Developer/IRCbot/IRCbot/"
#load "Util.fs"
#load "Bot.fs"
open IRCbot.Bot
open IRCbot.Util

let server = "irc.quakenet.org"
let port = 6667
let nick = "botijo"
let channels = ["#testchannel"]

let msgHandler (line: string) (write: string -> unit) =

    let say channel text = write (sprintf "PRIVMSG %s :%s" channel text)
    
    match line with
    | Message (JOIN(user, channel)) when user = nick -> say channel "Hello world!"
    | _ -> ()
    
let bot = new SimpleBot(server, port, nick, channels, msgHandler)
bot.Start()
