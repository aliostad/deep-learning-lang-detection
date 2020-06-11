open SuaveRestApi.Rest
open SuaveRestApi.Db
open Suave           
open Suave.Http      
open Suave.Http.Successful 
open Suave.Web 
open Suave.Http.Applicatives            

[<EntryPoint>]
    let main argv =

        let deafaultWebPart = path "/" >>= OK "
            <html>
                <body>
                    Hello to F# and Suave!<br/><br/>
                    API:</br>
                    <a href=\"/people\">Get people</a>
                </body>
            </html>"
            
        let personWebPart  = rest "people" {
            GetAll = Db.getPeople
        }

        startWebServer defaultConfig (choose[deafaultWebPart;personWebPart])
        0