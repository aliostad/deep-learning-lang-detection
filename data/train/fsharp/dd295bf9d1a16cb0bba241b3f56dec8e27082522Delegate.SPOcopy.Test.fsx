#r @"System.ServiceModel"
#r @"Microsoft.IdentityModel"
#r @"Delegate.SPOcopy.dll"

(** Open libraries for use *)
open System
open Delegate
open Delegate.SPOcopy

(**
Unittest setup
==============

Setup of shared values *)
let domain = @"sharepointonlinecopy"
let usr = sprintf @"admin@%s.onmicrosoft.com" domain
let pwd = @"pass@word1"
let source = @"D:\tmp\spo-copy"
let host = Uri( sprintf @"https://%s.sharepoint.com" domain)
let target = Uri(host.ToString() + @"Shared%20Documents")
let o365 = 
    Office365.getCookieContainer host usr pwd,
    Office365.userAgent

(**
Test cases
==========

Define *)
let tc1 () = copy source target usr pwd LogLevel.Verbose = ()

(**
Run test cases
==============

Place test cases result in a list *)
let unitTest  = [| tc1; |]
let unitTest' = unitTest |> Array.Parallel.map(fun x -> x())

(** Combine results *)
let result = unitTest' |> Array.reduce ( && )