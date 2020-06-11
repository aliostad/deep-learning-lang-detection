open System.Windows.Forms
open System.IO
open System.Diagnostics
open System.Threading
open System.Drawing
open System

let dirToWatch = @"C:\dev\Lacjam\src\WebApi\app\js\"
let processToRun = @"C:\dev\Grunt.bat"
let mutable runProcess = true

let form = new Form(Text = "Watching: " + dirToWatch, Top=1)
form.Width <- 700
form.Height <- 100
let button3 = new Button(Text = "Run", Width=150, Top=1)
let label1 = new Label(Width = 500, Top=1, Left=151)
label1.MaximumSize <- new Size(500,0)
label1.AutoSize <- true

let output msg =          printfn "%s" msg
                          label1.Text <- msg
                          form.Update() |> ignore
                          form.Refresh() |> ignore

let runBatchFile  =
                       async {      
                                    form.TopMost <- true
                                    form.BackColor <- Drawing.Color.IndianRed
                                    Cursor.Current <- Cursors.WaitCursor
                                    output ("Batch file started: " + System.DateTime.Now.ToShortTimeString())    
                                    // System.IO.File.AppendAllText(@"c:\temp\aaaa.txt", (System.DateTime.Now.ToString()))
                                    let processInfo = new ProcessStartInfo("cmd.exe", "/c " + processToRun)
                                    processInfo.CreateNoWindow <- true
                                    processInfo.UseShellExecute <- false
                                    processInfo.RedirectStandardError <- true
                                    processInfo.RedirectStandardOutput <- true
                                  
                                    output "Running batch file -- started"
                                    //try
                                    let proc = Process.Start(processInfo)
                                    proc.Start() |> ignore
                                    // *** Read the streams ***
                                    let so = proc.StandardOutput.ReadToEnd();
                                    let error = proc.StandardError.ReadToEnd();

                                    let exitCode = proc.Exited

                                    output("output>>" + so);
                                    output("error>>" + error);
                                    output("ExitCode: " + (exitCode.ToString()));
                                    proc.Close();
//                                    with ex -> 
//                                        output (ex.ToString())
                                    output ("Batch file completed: " + System.DateTime.Now.ToShortTimeString())  
                                    Cursor.Current <- Cursors.Default
                                    form.BackColor <- Drawing.Color.Ivory
                                    form.TopMost <- true
                                    ()
                            }

button3.Click.Add(fun _ ->
                          output "Manually run"
                          Async.StartImmediate runBatchFile  |> ignore
                          ()
                  )

do
    form.Controls.AddRange [| button3; label1; |]
//    form.Controls.Add(button1)
//    form.Controls.Add(button2)
    form.Controls.Add(button3)

             
let htmlWatcher = new FileSystemWatcher(Path = dirToWatch)                       // only one filter is supported  -- workaround http://stackoverflow.com/questions/6965184/how-to-set-filter-for-filesystemwatcher-for-multiple-file-types
htmlWatcher.EnableRaisingEvents <- true 
htmlWatcher.IncludeSubdirectories <- true
htmlWatcher.WaitForChanged(WatcherChangeTypes.All)
htmlWatcher.Changed.Add(fun _ -> Async.StartImmediate runBatchFile )
htmlWatcher.Deleted.Add(fun _ -> Async.StartImmediate runBatchFile )
htmlWatcher.Created.Add(fun _ -> Async.StartImmediate runBatchFile )


form.ShowDialog()
System.Windows.Forms.Application.Run(form) 

Async.StartImmediate runBatchFile  |> ignore