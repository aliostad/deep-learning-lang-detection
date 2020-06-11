module matchrunner

open common
open config
open siteProps

open canopy
open runner

open System

let init _ =  
  siteType <- 1
  email <- random 5 + "@gmail.com"
  username <- random 5
  password <- random 5

let createAccount _ =
  test(fun _ ->
    describe "can create an account"

    url matchCreateAccountUrl
    genderInput << "Man seeking a Woman"
    postalCodeInput << "75034"
    click viewSinglesButton
    emailRegisterInput << email
    next ()
    passwordRegisterInput << password
    birthMonthInput << "Dec"
    birthDayInput << "29"
    birthYearInput << "1987"
    next ()
    handleInput << username
    next ()
    on profileWelcomeVerifyUrl //logged in
    url matchUrl
  )

let signOut _ =
  test(fun _ ->
    describe "can create an account"

    hover signOutNav
    click signOutButton
    browser.Manage().Cookies.DeleteAllCookies()
  )

let signIn _ =
  test(fun _ ->
    describe "can sign in"
    
    browser.Manage().Cookies.DeleteAllCookies()
    url loginUrl
    assignSiteType()
    emailLoginInput << email
    passwordLoginInput << password
    click signInButton
    closeEmailAlert()
  )

let addFavorite _ =
  test(fun _ ->
    describe "can add favorite"
    
    url matchUrl
    let firstMatch = first matchOptionClass
    myFavorite <- firstMatch.Text.Split(' ').[0].Split('\r', '\n').[0]
    click myFavorite
    click favoriteMatchClass
    on addEntryVerifulUrl
  )

let verifyFavorite _ =
  test(fun _ ->
    describe "can verify the favorite we added"

    click favoritesButton
    closeEmailAlert()
    click myFavesButton
    displayed favoriteCardsClass
    displayed myFavorite
  )


let runTests _ =
  context "match challenge tests"

  init()
  createAccount()
  signOut()
  signIn()
  addFavorite()
  signOut()
  signIn()
  verifyFavorite()
  signOut()
