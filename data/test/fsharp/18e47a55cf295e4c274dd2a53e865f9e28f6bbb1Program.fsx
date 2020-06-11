//F# の詳細 (http://fsharp.net)

#if COMPILED
#else
#r "DShowVideo.dll"
#endif

open System
open System.Windows.Forms
open CommonManage
open System.Drawing

let form = new Form(Visible = true, Text = "Video")
let btn = new Button(Text = "Video")
form.Controls.Add(btn)
let mutable video : VideoCapture = null

btn.Click.Add(fun _ -> 
  let dialog = new OpenFileDialog()
  dialog.Title <- "動画ファイルを開く"
  dialog.Filter <- ".avi, .mpg, .wmv|*.avi;*.mpg;*.wmv|すべてのファイル|*.*"
  if (dialog.ShowDialog(form) = DialogResult.OK) then 
    if not(video = null) then
      video.Dispose()
      video <- null

    video <- new VideoCapture(dialog.FileName, form, VideoCapture.VMR.VMR9)
    form.Width <- video.Width
    form.Height <- video.Height
    ignore(video.Play())
)

form.SizeChanged.Add(fun _ -> 
  video.SetCtrl(form)
)
form.FormClosing.Add(fun _ -> 
  if not(video=null) then
    video.Dispose()
    video <- null
)

[<STAThread>]
Application.Run(form)