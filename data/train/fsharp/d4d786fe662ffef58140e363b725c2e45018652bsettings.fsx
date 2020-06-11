#load "init.fsx"

open Xero.Api.Infrastructure.OAuth
open System.Security.Cryptography.X509Certificates
open Xero.Api.Example.Applications.Private

let BaseUrl = "https://api.xero.com/api.xro/2.0/"

let Consumer =
    let ConsumerKey = "{ Consumer Key }"
    let ConsumerSecret = "{ Consumer Secret }"
    new Consumer(ConsumerKey,ConsumerSecret)
let Authenticator =
    let certPassword = "{ Certificate Password }"
    let SigningCertificatePath = @"{ Path to Private Key  .pfx}"
    let cert = new X509Certificate2(SigningCertificatePath,certPassword)
    new PrivateAuthenticator(cert)
