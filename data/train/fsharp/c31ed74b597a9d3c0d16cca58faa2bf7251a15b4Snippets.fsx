#r @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.1\System.dll"
#r @"C:\Users\Abelardo\OneDrive - Cipher Business Solutions\Clientes\Houston\CIPHERTool\FSharp.Data.SqlClient\FSharp.Data.SqlClient.dll"
# 1 @" F# namespace FSharpStationNS.fsx"
#if INTERACTIVE
//#I @"../WebServer/bin"
module FSharpStationNS =
#else
namespace FSharpStationNS
#nowarn "1182"
#endif

# 1 @" F# Evaluate F# Code.fsx"
// Code to be evaluated using FSI: `Evaluate F#`
# 1 @"(4) F# Useful.fsx"
    module Useful =
# 1 @"(6) F# let doSTA act =.fsx"
      let doSTA act =
          let thread = System.Threading.Thread(System.Threading.ThreadStart act)
          thread.SetApartmentState(System.Threading.ApartmentState.STA)
          thread.Start()
          
      let sCopy       txt = 
          doSTA (fun () -> System.Windows.Forms.Clipboard.SetText txt)
          sprintf "Copied to clipboard: %s... (%d characters)\n\n" <| txt.[..min (txt.Length - 1) 100 ] <| txt.Length 
          
      let Copy        txt = 
          sCopy txt
          |> printf "%s"
          
      let Paste f        = doSTA (fun () -> f System.Windows.Forms.Clipboard.GetText)   
# 1 @"(4) F# SlowlyChangingDimensions.fsx"
//#r @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.1\System.dll"
//#r @"C:\Users\Abelardo\OneDrive - Cipher Business Solutions\Clientes\Houston\CIPHERTool\FSharp.Data.SqlClient\FSharp.Data.SqlClient.dll"
    
    module SlowlyChangingDimensions =
# 1 @"(6) F# Fields.fsx"
      type TargetField =
           | CURR_ASSIGNED_VEND
           | ORIG_ASSIGNED_VEND
           | ORIG_INV_NUM                  