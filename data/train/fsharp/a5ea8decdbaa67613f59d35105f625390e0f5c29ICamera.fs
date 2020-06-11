namespace PiCamCV.Capture.Interfaces

open Emgu.Util
open System.Diagnostics
open PiCamCV
open Emgu.CV.Structure
open PiCamCV.Capture

type ICameraConsumer = 
        abstract member CameraCapture : ICaptureGrab with get, set
        abstract member ImageGrabbedHandler : byte[] with get

type ICameraProcessor<'TInput, 'TResult when 'TInput :> CameraProcessInput  and 'TResult :> CameraProcessOutput> = 
    abstract member Process: 'TInput -> 'TResult

[<AbstractClass; Sealed>]
type CameraProcessor<'TInput, 'TResult when 'TInput :> CameraProcessInput and 'TResult :> CameraProcessOutput>() =
    inherit DisposableObject()
                
    abstract member DoProcess: 'TInput -> 'TResult

    interface ICameraProcessor<'TInput, 'TResult> with
        member this.Process(input: 'TInput): 'TResult = 
            let result = this.DoProcess(input)
            let stopWatch = Stopwatch.StartNew()
            if(result.CapturedImage = null && input.SetCapturedImage) then
                result.CapturedImage <- input.Captured.ToImage<Bgr, byte>()
            result.Elapsed <- stopWatch.Elapsed
            result