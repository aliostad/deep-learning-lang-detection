module SplashScreen
open canopy
open runner
open Constants
open NUnit.Framework
    
    [<Test>]
    let All url= 
        context "Open Home Page"

        "Logged Out user should go to splash screen" &&& fun _ ->
            Actions.GoToHomePage url
            let currentUrl = canopy.runner.safelyGetUrl()
            Assert.AreEqual(currentUrl, url)

        "Logged In user with a team should be redirected to the stubs page" &&& fun _ ->
            let fakeApi = FakeApi.WithTeams
            Actions.GoToHomePage url |>
            Actions.LogIn
            Actions.GoToHomePage url
            let currentUrl = canopy.runner.safelyGetUrl()
            Assert.AreEqual(currentUrl.ToLower(), url+"stubs")
            //fakeApi.Cancel()
