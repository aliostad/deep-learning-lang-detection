namespace PiCamCV.Capture

    open Emgu.CV
    open Emgu.CV.Structure
    open System
    open Kraken.Core
    
    type CameraProcessOutput() = 
        member val CapturedImage : Image<Bgr, byte> = null with get, set
        member val Elapsed: TimeSpan = TimeSpan.FromDays(1.0) with get, set

        override this.ToString() = 
            String.Format("Elapsed={0}", this.Elapsed.ToHumanReadable())

    type CameraProcessInput() =         
        member val SetCapturedImage : bool = true with get, set
        member val Captured: Mat  = null with get, set

