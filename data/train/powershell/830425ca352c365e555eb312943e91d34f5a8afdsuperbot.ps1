param ($Message, $Bot)

$Bot.State.Counter += 1
Write-Verbose "Counter = $($Bot.State.Counter)"
#throw "wtf"

"/pipe $($Message.Line)"
switch -regex ($Message.Text)
{
    "lol"
    {
        "haha :)"
        $bot.TimerInterval = 5000
    }
    "throw" { throw 'oh crap' }
    "dienow" { "no!"; "/quit" }
    "diebot" { "/quit :cya guys!" }
    "ls" { ls | out-string }
    default { }
}

switch ($Message.Command)
{
    "BOT_INIT"
    {
        if ($bot.State.DieImmediately) { throw "shit!" }
    }
    "join" { "/msg $($Message.Arguments[0]) /me says hi to everyone on $($Message.Arguments[0])"}
    "ping" { "pong! $(Get-Date)" }
    "BOT_TICK" { "haha LOCALS RULE -- $(Get-Date)" }
    default
    {
        #Write-Host "CMD $Message"
        return
    }
}

#Write-Host $Command