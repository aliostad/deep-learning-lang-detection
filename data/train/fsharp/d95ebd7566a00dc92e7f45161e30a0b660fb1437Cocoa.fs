// This sample shows how to use the Cocoa
// NS URL connection APIs for doing http
// transfers.
//
// It does not show all of the methods that could be
// overwritten for finer control though. 

namespace HttpClient

open System
open System.IO
open MonoTouch.Foundation
open MonoTouch.UIKit
open System.Runtime.InteropServices

    type Cocoa(ad) = 
        inherit NSUrlConnectionDelegate()
 
        let mutable result = Array.empty
        
        member x.HttpSample() =
            let req = new NSUrlRequest(new NSUrl(Application.WisdomUrl), NSUrlRequestCachePolicy.ReloadIgnoringCacheData, 10.0)
            NSUrlConnection.FromRequest(req, x)

        // Collect all the data
        override x.ReceivedData(connection,  data) =
            let nb = Array.init(result.Length + int data.Length) (fun _ -> 0uy)
            result.CopyTo(nb, 0)
            Marshal.Copy(data.Bytes, nb, result.Length, int data.Length)
            result <- nb
        
        override x.FinishedLoading(connection) =
            Application.Done()
            let ms = new MemoryStream(result)
            ad(ms)

        override x.FailedWithError ( connection: NSUrlConnection,  error:NSError) =
            Application.Done() |> ignore

