#r @"System.ServiceModel"
#r @"Microsoft.IdentityModel"
#r @"Delegate.SPOcopy.dll"

(** Open libraries for use *)
open System
open Delegate
open Delegate.SPOcopy

(**
Sample script
=============

Setup of values *)
let domain = @"sharepointonlinecopy"
let usr = sprintf @"admin@%s.onmicrosoft.com" domain
let pwd = @"pass@word1"
let source = @"D:\tmp\spo-copy"
let host = Uri( sprintf @"https://%s.sharepoint.com" domain)
let target = Uri(host.ToString() + @"Shared%20Documents")
let o365 = 
    Office365.getCookieContainer host usr pwd,
    Office365.userAgent

(** Copy from local source to online target *)
copy source target usr pwd LogLevel.Info