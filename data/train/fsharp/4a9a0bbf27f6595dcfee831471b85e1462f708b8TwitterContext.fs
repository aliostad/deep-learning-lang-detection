module TwitterContext

open LinqToTwitter

(*
// Please get the keys below from http://dev.twitter.com
// and copy the comment to a file TwitterCredential.fs
module TwitterCredential

open LinqToTwitter

let credential = 
    {
        new SingleUserInMemoryCredentialStore() with 
                member this.ConsumerKey = ""
                member this.ConsumerSecret = ""
                member this.AccessToken = ""
                member this.AccessTokenSecret = "" 
    }
*)

let ctx = 
    let mutable auth = new SingleUserAuthorizer()
    auth.CredentialStore <- TwitterCredential.credential
    new TwitterContext(auth)

