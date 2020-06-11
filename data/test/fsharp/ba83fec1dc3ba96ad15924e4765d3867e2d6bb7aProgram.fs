open PushSharp
open PushSharp.Android

let pushBroker = new PushBroker()

let apiKey = "AIzaSyAUBS4xlS02e47DbevW_jNgp_lquphSk_c"

pushBroker.OnDeviceSubscriptionChanged.Add(fun (a,b,c) -> 
    printfn "device connected: %s %s %A" a b c.Tag)

pushBroker.RegisterGcmService(GcmPushChannelSettings(apiKey))
            
let regId = "APA91bGQQvKTIyIsDaPBmLUj8cPVKptgM6Q1152rRT6fHjYaNRsZykYtyu-oCQ8EtQrtiA-TvQH2FafMXO-89v6O5cl36Xd6I76Afr74ypsOc3EON8roX2ll-xjpqKfpQ6H0DjcyBocAf9cXqCVliiOwGAIaZSVL1hH4s8d3uS0WHTq2y_KizxA"

let mutable message = ""
while message <> "dupa" do
    message <- System.Console.ReadLine()
    pushBroker.QueueNotification(
        GcmNotification()
            .ForDeviceRegistrationId(regId)
            .WithJson(sprintf "{\"message\":\"%s!\"}" message))