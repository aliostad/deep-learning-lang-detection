namespace Giftee.Core

open System
open System.Net

type formData = System.Collections.Specialized.NameValueCollection
type cfgMgr   = System.Configuration.ConfigurationManager

module R = Giftee.Core.Resources

module Mail =

  let apiUrl = Uri(cfgMgr.AppSettings.["MAILGUN_API_URL"])
  let apiKey =     cfgMgr.AppSettings.["MAILGUN_API_KEY"]
  
  let systemAddress = cfgMgr.AppSettings.["POSTMASTER_ADDR"]
  
  let credential =
    let cc = CredentialCache()
    cc.Remove(apiUrl,"Basic")
    cc.Add(apiUrl,"Basic",NetworkCredential("api",apiKey))
    cc
    
  let poster = 
    new WebClient(UseDefaultCredentials=false,Credentials=credential)

  let toForm items =
    let data = formData()
    for (key,value) in items do 
      data.Add(key,value)
    data

  let send from tos subject message tags =
    let url   = Uri(apiUrl,"messages")
    let data  = [ ("from"   ,from   )
                  ("subject",subject) 
                  ("text"   ,message) ]
                |> Seq.append (tos  |> Seq.map (fun r -> ("to"   ,r)))
                |> Seq.append (tags |> Seq.map (fun t -> ("o:tag",t)))
                |> toForm
    poster.UploadValues(url,data) |> ignore

  let sendRegistered email password =
      send  systemAddress [email]
            R.MailSubj.registered
            (String.Format(R.MailMsg.registered,email,password))
            ["registration"] 

  let sendPasswordReset email password =
    send  systemAddress [email]
          R.MailSubj.pwdChanged
          (String.Format(R.MailMsg.pwdChanged,email,password))
          ["password_reset"] 

  let sendWishlistChange email =
    send  systemAddress [email]
          R.MailSubj.listChanged
          R.MailMsg.listChanged
          ["password_reset"] 
