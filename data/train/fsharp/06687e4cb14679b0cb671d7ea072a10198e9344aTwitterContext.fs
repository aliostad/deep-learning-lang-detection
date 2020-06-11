module TwitterContext

open LinqToTwitter

(*
// Please get the keys below from http://dev.twitter.com
// and copy the comment to a file TwitterCredential.fs
module TwitterCredential

open LinqToTwitter

let credential = 
    {
        new SingleUserInMemoryCredentials() with 
                member this.ConsumerKey = ""
                member this.ConsumerSecret = ""
                member this.TwitterAccessToken = ""
                member this.TwitterAccessTokenSecret = "" 
    }
*)

let ctx = 
    let mutable auth = new SingleUserAuthorizer()
    auth.Credentials <- TwitterCredential.credential
    new TwitterContext(auth)

