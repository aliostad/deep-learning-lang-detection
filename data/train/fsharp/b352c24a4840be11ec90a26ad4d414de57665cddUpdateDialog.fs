namespace Cursed.Base

open System
open System.Diagnostics
open Eto.Forms
open Eto.Drawing

type UpdateDialog() as this =
    inherit Dialog()
    

    do
        let latestVersion, currentVersion =
            let versions =
                UpdateDialogController.Versions
                |> Async.RunSynchronously
            (fst versions).ToString(3), (snd versions).ToString(3)

        let layout = 
            let layout = new DynamicLayout()
            let updateTitle =
                let title = new Label(Text = (sprintf "Update Available - Changes since %s" currentVersion))
                title.TextAlignment <- TextAlignment.Center
                let fontFamily = title.Font.Family
                title.Font <- new Font(fontFamily, 14.0f)
                title

            let releaseNotes =
                let newNotes =
                    UpdateDialogController.GetReleaseNotes.Split [|'\n'|]
                    |> List.ofArray
                    |> List.takeWhile (fun line ->
                        not <| line.Contains(currentVersion)
                    )
                    |> String.concat Environment.NewLine

                let textArea = new TextArea(Text = newNotes)
                textArea

            let actionButtonsRow =
                let updateButton = 
                    let button = new Button(Text = "Download")
                    let downloadHandler _ =
                        Process.Start("https://github.com/kaeedo/Cursed/releases/latest") |> ignore
                        this.Close() |> ignore

                    Observable.subscribe downloadHandler button.MouseUp |> ignore

                    button

                let skipButton = 
                    let button = new Button(Text = sprintf "Skip version %s" latestVersion)

                    let skipVersionHandler _ =
                        CacheActor.FileLoop.Post <| SaveVersionSkip latestVersion
                        this.Close() |> ignore

                    Observable.subscribe skipVersionHandler button.MouseUp |> ignore

                    button
                let laterButton = 
                    let button = new Button(Text = "Later")

                    let laterHandler _ =
                        this.Close() |> ignore

                    Observable.subscribe laterHandler button.MouseUp |> ignore

                    button

                let cells = 
                    [ new TableCell(updateButton)
                      new TableCell(null, true)
                      new TableCell(skipButton)
                      new TableCell(laterButton) ]

                let tableLayout = new TableLayout()
                tableLayout.Spacing <- new Size(5, 0)
                tableLayout.Padding <- new Padding(0, 10, 0, 0)
                tableLayout.Rows.Add(new TableRow(cells))
                tableLayout

            layout.Padding <- Nullable <| new Padding(10)
            layout.Add(updateTitle) |> ignore
            layout.Add(releaseNotes, yscale = Nullable true) |> ignore
            layout.Add(actionButtonsRow) |> ignore
            layout

        base.Title <- "Update"
        base.ClientSize <- new Size(500, 500)
        base.Content <- layout
