namespace Phoneword

open System
open Xamarin.Forms
open System.Threading.Tasks

type FSMainPage() as self =
    inherit MainPage()
    do
        self.translateButton.Clicked.AddHandler(new EventHandler(self.OnTranslate))
        self.callButton.Clicked.AddHandler(new EventHandler(self.OnCallAsync))
        self.callHistoryButton.Clicked.AddHandler(new EventHandler(self.OnCallHistoryAsync))

    let mutable translatedNumber = String.Empty 

    member self.OnTranslate sender e = 
      translatedNumber <- Core.PhonewordTranslator.ToNumber (self.phoneNumberText.Text)
      if not (String.IsNullOrWhiteSpace(translatedNumber)) then
          self.callButton.IsEnabled <- true
          self.callButton.Text <- "Call " + translatedNumber
        else
          self.callButton.IsEnabled <- false
          self.callButton.Text <- "Call"

    member self.OnCallAsync sender e = Async.StartImmediate(async {
            let! result = Async.AwaitTask(self.DisplayAlert("Dial a Number", "Would you like to call " + translatedNumber + "?", "Yes", "No"))
            if result then
                let dialer = DependencyService.Get<IDialer> ();
                if not (Object.ReferenceEquals(dialer, null)) then
                    FSApp2.PhoneNumbers.Add(translatedNumber);
                    self.callHistoryButton.IsEnabled <- true
                    dialer.Dial (translatedNumber) |> ignore
        })

    member self.OnCallHistoryAsync sender e = Async.StartImmediate(async {
            let! result = self.Navigation.PushAsync(new CallHistoryPage()) |> Async.AwaitIAsyncResult |> Async.Ignore
            ()
        })
