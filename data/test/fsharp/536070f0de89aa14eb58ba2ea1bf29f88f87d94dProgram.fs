// Learn more about F# at http://fsharp.net
// See the 'F# Tutorial' project for more help.

open ManyConsole
open System

let action (f:'a->'b) : 'a -> unit =  fun x -> f x |> ignore

[<AbstractClass>]
type BaseCommand() as this =
    inherit ConsoleCommand()
    [<DefaultValue>] val mutable certificate : string
    [<DefaultValue>] val mutable jsonsecret : string
    [<DefaultValue>] val mutable domain : string
    [<DefaultValue>] val mutable answeryes : bool
    let mutable excludes = ResizeArray<string>();
    let mutable includes = ResizeArray<string>();

    do
        this
            .HasRequiredOption("c|certificate=", "path to .p12 certificate with 'notasecret' password", action(fun v -> this.certificate <- v))
            .HasRequiredOption("j|jsonsecret=", "path to json google service account credentials", action(fun v -> this.jsonsecret <- v))
            .HasRequiredOption("d|domain=", "google apps domain", action(fun v -> this.domain <- v))
            .HasOption("Y|answeryes","say yes to all questions", action(fun v -> this.answeryes <- true))
            .HasOption("x|exclude=","excluded accounts", action(fun v -> excludes.Add(v)))
            .HasOption("i|include=","include these accounts only", action(fun v-> includes.Add(v)))
            |> ignore

type ImportCommand() as this = 
    inherit BaseCommand()
     [<DefaultValue>] val mutable csvfile : string
    do 
        this.IsCommand("import","Import Outlook CSV")
            .HasRequiredOption("f|csvfile=", "outlook csv file", action (fun v -> this.csvfile <- v))
            |> ignore
    override this.Run(arguments: string[]) = Import.import (this.certificate, this.jsonsecret, this.domain, this.answeryes) this.csvfile 

type RestoreCommand() as this = 
    inherit BaseCommand()
     [<DefaultValue>] val mutable restorefile : string
     [<DefaultValue>] val mutable all : bool
    do 
        this.IsCommand("restore","restore from backup")
             .HasOption("a|all","delete all not just 'My Contacts'", action(fun v -> this.all <- true))
            .HasRequiredOption("f|file=", "file store restore from", action (fun v -> this.restorefile <- v))
            |> ignore
    override this.Run(arguments: string[]) = Restore.restore (this.certificate, this.jsonsecret, this.domain, this.answeryes) this.all this.restorefile 


type CopyCommand() as this = 
    inherit BaseCommand()
    let mutable src = ResizeArray<string>();
    let mutable dest = ResizeArray<string>();
    do 
        this.IsCommand("copy","copy from one account to another")
            .HasRequiredOption("s|src=", "account to copy from", action(fun v -> src.Add(v)))
            .HasRequiredOption("t|dest=", "account to copy to", action(fun v -> dest.Add(v)))
            |> ignore
    override this.Run(arguments: string[]) = Copy.copy (this.certificate, this.jsonsecret, this.domain, this.answeryes) src dest 

type BackupCommand() as this = 
    inherit BaseCommand()
     [<DefaultValue>] val mutable restorefile : string
     [<DefaultValue>] val mutable all : bool
    do 
        this.IsCommand("backup","backup to file")
             .HasOption("a|all","backup all not just 'My Contacts'", action(fun v -> this.all <- true))
            .HasRequiredOption("f|file=", "file to backup to", action (fun v -> this.restorefile <- v))
            |> ignore
    override this.Run(arguments: string[]) = Backup.backup (this.certificate, this.jsonsecret, this.domain) this.all this.restorefile 


type SyncCommand() as this = 
    inherit ConsoleCommand()
    do 
        this.IsCommand("sync","Sync all accounts.")
                |> ignore
    override this.Run(arguments: string[]) = 0 //Todo syncronise contacts across acounts

type ClearCommand() as this = 
    inherit BaseCommand()
    [<DefaultValue>] val mutable all : bool
    do 
        this.IsCommand("clear","Globally Clear all Contacts")
             .HasOption("a|all","delete all not just 'My Contacts'", action(fun v -> this.all <- true))

                |> ignore
    override this.Run(arguments: string[]) = Clear.clear (this.certificate, this.jsonsecret, this.domain, this.answeryes) (Some(this.all))

type FileAsCommand() as this = 
    inherit BaseCommand()
    do 
        this.IsCommand("fileas","Update File as by Company.")
                |> ignore
    override this.Run(arguments: string[]) = FileAs.fileAs (this.certificate, this.jsonsecret, this.domain, this.answeryes)

[<EntryPoint>]
let main argv = 
        
    let commands : ConsoleCommand list = [ImportCommand();SyncCommand();ClearCommand(); BackupCommand(); RestoreCommand(); CopyCommand(); FileAsCommand()]

    ConsoleCommandDispatcher.DispatchCommand(commands, argv, System.Console.Out)
