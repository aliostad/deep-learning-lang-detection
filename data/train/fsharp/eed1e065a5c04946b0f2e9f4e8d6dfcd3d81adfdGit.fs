namespace GitShow

module Git =
    open Chessie.ErrorHandling
    open Slide
    open Presentation
    open Logary.Logger
    type GitImpl() =
        let logger = Logary.Logging.getCurrentLogger()
        let run = ignore << Process.runProcess
                                (Logary.Message.eventVerbosef "%s" >> logSimple logger)
                                (Logary.Message.eventVerbosef "%s" >> logSimple logger)
                                "git"
    
        let runf args =
            let mutable r = []
            let _ = Process.runProcess (fun x -> r <- x :: r)
                        (Logary.Message.eventVerbosef "%s" >> logSimple logger)
                        "git" args
            Seq.toArray r

        interface IImpl with
            override x.SetSlide(s:T) =
                run ["checkout"; "-q"; s.commit]
                match s.command with
                | _ -> ()
                ok ()
            override x.GetMessage(t:T): Result<string, Error> =
                let msg = runf ["show"; "-s"; "--format=%B"; t.commit] |> Array.rev |> String.concat " "
                ok msg
            override x.GetCurrent(p:Presentation) =
                trial {
                    let! curId = runf ["rev-parse"; "HEAD"] |> Array.tryItem 0 |> failIfNone GitError
                    let! i = p |> Array.tryFindIndex (fun s -> s.commit = curId) |> failIfNone Unknown
                    return (p.[i],i)
                }