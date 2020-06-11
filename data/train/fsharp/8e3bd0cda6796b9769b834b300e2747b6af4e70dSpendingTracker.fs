namespace SpendingTracker

open System
open System.IO
open System.ComponentModel
open System.Diagnostics
open Xamarin.Forms
open Xamarin.Forms.Xaml
open System.Threading.Tasks
open SQLite
open DatabaseMigration
open Database

type ApiAction<'a> = ApiAction of (ApiClient -> 'a)

module ApiAction =
    let run api (ApiAction action) = 
        let resultOfAction = action api
        resultOfAction

    let map f action = 
        let newAction api =
            let x = run api action 
            f x
        ApiAction newAction

    let retn x = 
        let newAction api =
            x
        ApiAction newAction

    let apply fAction xAction = 
        let newAction api =
            let f = run api fAction 
            let x = run api xAction 
            f x
        ApiAction newAction

    let bind f xAction = 
        let newAction api =
            let x = run api xAction 
            run api (f x)
        ApiAction newAction

    let execute path provider action =
        use api = new ApiClient()
        api.Open(path, provider)
        let result = run api action
        api.Close()
        result

    
//module ApiActionResult = 

//    let map f = ApiAction.map <| Result.map f
//    let retn x = ApiAction.retn <| Result.Success x

//    let apply fActionResult xActionResult = 
//        let newAction api =
//            let fResult = ApiAction.run api fActionResult 
//            let xResult = ApiAction.run api xActionResult 
//            Result.apply fResult xResult 
//        ApiAction newAction

//    let bind f xActionResult = 
//        let newAction api =
//            let xResult = ApiAction.run api xActionResult 
//            let yAction = 
//                match xResult with
//                | Success x -> 
//                    f x
//                | Failure err -> 
//                    Failure err |> ApiAction.retn
//            ApiAction.run api yAction  
//        ApiAction newAction
    

//open Database
//---------------------------------------
// __Modeled domain__

module Models = 

  type IExporter = IExporter of (string -> unit)

  type AppData = {
    DbPath: string
    Exporter: IExporter
    Provider: SQLitePCL.ISQLite3Provider
    Items : string list}

  //let traverse f list =
  //  // define the applicative functions
  //  let (<*>) = ApiActionResult.apply
  //  let retn = ApiActionResult.retn

  //  // define a "cons" function
  //  let cons head tail = head :: tail

  //  // right fold over the list
  //  let initState = retn []
  //  let folder head tail = 
  //      retn cons <*> f head <*> tail

  //  List.foldBack folder list initState 


  let getProductInfos() = 
    let action (api:ApiClient) = 
      api.GetProductInfo()
    ApiAction action

  let setProductInfo(item:ProductInfo) = 
    let action (api:ApiClient) = 
      api.Set(item)

    ApiAction action

  let getPurchaseIds (custId:CustId) =
      let action (api:ApiClient) = 
          api.GetProductIds custId
      ApiAction action
   
  let getProductInfo (productId:ProductId) =
      let action (api:ApiClient) = 
          api.GetProductInfo productId
      ApiAction action

  //let getPurchaseInfo =
  //    let getProductInfoLifted =
  //        getProductInfo
  //        |> traverse 
  //        |> ApiActionResult.bind 
  //    getPurchaseIds >> getProductInfoLifted


//---------------------------------------
// __App state__

open Models
type AppRepo(state: AppData) as this = 
  let mutable appState = state
  let dataLock = new obj()
  let updatedData = Event<unit> ()

  let loadData () =
    lock dataLock (fun () ->
      let executor = ApiAction.execute appState.DbPath appState.Provider
      let items = getProductInfos () |> executor 

      let updateAndPublish xs = 
        appState <- {appState with Items = xs}
        //Task.Run updatedData.Trigger |> ignore

      match items with 
      | Success xs -> 
          xs 
          |> Seq.toList 
          |> List.map (fun x -> x.ProductName) 
          |> updateAndPublish
                      
      | Failure xs -> ()
    )
  do loadData()
   
  member this.Data = appState
  member this.UpdatedData = updatedData.Publish




  member this.UpdateData (update : AppData -> AppData option) =

    let now () = 
      DateTime.Now
    
    let mutable updated = false
    lock dataLock (fun () ->
        match update appState with
        | None -> ()
        | Some newData ->
            let executor = ApiAction.execute appState.DbPath appState.Provider
            let s1 = appState.Items |> Set.ofList
            let s2 = newData.Items |> Set.ofList
            let newItems = Set.difference s2 s1
            let result = newItems 
                          |> Seq.toList
                          |> List.map (fun x -> {Id = None; ProductName = x; DateCreated = now() }) 
                          |> List.map (fun x -> setProductInfo x)
                          |> List.map executor

            appState <- newData
            updated <- true)

    if updated then
        Debug.WriteLine "Item added to repo"
        Task.Run updatedData.Trigger |> ignore


  member this.ExportDb () = 
    lock dataLock (fun () -> 
      let (IExporter exporter) = appState.Exporter
      exporter DatabaseMigration.dbName
    )
       


//---------------------------------------
// __User actions__

type UserCommands(currentState: AppRepo) = 
  member this.Repo = currentState

  member this.AddItem newItem = 
    currentState.UpdateData (fun x -> 
      Some {x with Items = newItem :: x.Items}
      )

  member this.ExportDb () = currentState.ExportDb()


//---------------------------------------
// __ViewsModels__

module ViewModels = 
  open Models

  let runTask task = 
    do 
      async {
        do! task
            |> Async.AwaitIAsyncResult 
            |> Async.Ignore
        return ()
      } |> Async.StartImmediate

  let runUiUpdate f = 
    Device.BeginInvokeOnMainThread <| Action(f)


//---------------------------------------
// __Views__

open ViewModels

type Pages = Contact | Main

[<CLIMutable>]
type MenuItem = {
  Title:string
  TargetType: Pages
  }

type AddTransaction(cmds: UserCommands) as this= 
  inherit ContentPage()
  let text = "Add Transaction"

  let constructLabel text = 

    let label = (Label(Text = text, AutomationId = "label" + text, FontSize = 20., TextColor = Color.FromHex("DD2C00")));
    let entry = (Entry(AutomationId = "category" + text, FontSize = 20., HorizontalOptions = LayoutOptions.FillAndExpand))
    let stack = StackLayout(
                  Orientation = StackOrientation.Horizontal, 
                  HorizontalOptions = LayoutOptions.FillAndExpand)
    stack.Children.Add(label)
    stack.Children.Add(entry)
    (stack, entry) 

  let title = Label(Text = "Add Item", HorizontalOptions = LayoutOptions.CenterAndExpand, FontSize = 26., TextColor = Color.FromHex("DD2C00"))

  let amount = constructLabel "Amount"
  let category = constructLabel "Category"

  let add = Button(Text = "Add", 
                   AutomationId = "add", 
                   FontSize = 26.,
                   VerticalOptions = LayoutOptions.Start, 
                   HorizontalOptions = LayoutOptions.FillAndExpand,
                   TextColor = Color.White,
                   BackgroundColor = Color.FromHex("2196F3"))

  let stack = StackLayout(VerticalOptions = LayoutOptions.FillAndExpand, 
                          HorizontalOptions = LayoutOptions.FillAndExpand, 
                          Padding = Thickness(20.,20.,20.,20.))

  do 
    let handleAdd args = 
      cmds.AddItem (snd category).Text
      Debug.WriteLine "Adding item"
      runTask (this.Navigation.PopAsync())

    let t = add.Clicked |> Observable.subscribe handleAdd

    stack.Children.Add title
    stack.Children.Add (fst amount)
    stack.Children.Add (fst category)
    stack.Children.Add add

    this.Content <- stack
    this.Title <- "Add Transaction" 
    (snd amount).Keyboard <- Keyboard.Numeric

  override this.OnAppearing() = 
    (snd amount).Focus() |> ignore



type TransactionsPage(cmds: UserCommands) as this =
  inherit ContentPage()

  let listView = ListView(HorizontalOptions = LayoutOptions.Fill, VerticalOptions = LayoutOptions.Fill)

  let updateUI x =
    runUiUpdate <| fun () ->
      listView.ItemsSource <- cmds.Repo.Data.Items |> List.toSeq
      this.Content <- listView

  do
    let x = cmds.Repo.UpdatedData |> Observable.subscribe updateUI
    this.Title <- "Transactions"
    updateUI()



type SummaryPage(cmds: UserCommands) as this =
  inherit ContentPage()
  let text = "Summary"
  do 
    this.Content <- Label(Text = text, AutomationId = "label")
    this.Title <- "Summary" 


type TabPage(cmds: UserCommands) as this =
  inherit TabbedPage()

  let tbItem = ToolbarItem(Text = "Add", AutomationId = "add")
  let exportDb = ToolbarItem(Text = "Export", AutomationId = "exportDb")

  let showAddTransactionModel event = 
    runTask <| this.Navigation.PushAsync (AddTransaction(cmds))

  let copyToDevceStorage e = 
    cmds.ExportDb()

  do 
    let t = tbItem.Clicked |> Observable.subscribe showAddTransactionModel
    let t = exportDb.Clicked |> Observable.subscribe copyToDevceStorage
    this.ToolbarItems.Add(tbItem)
    this.ToolbarItems.Add(exportDb)
    this.Children.Add(TransactionsPage(cmds))
    this.Children.Add(SummaryPage(cmds))


type ContactsPage(cmds: UserCommands) =
    inherit ContentPage()
    do base.Content <- Label(Text = "willsam100@gmail.com", AutomationId = "email")


type MainMenu() =
    inherit ContentPage() 

    let _ = base.LoadFromXaml(typeof<MainMenu>)
    let listView = base.FindByName<ListView>("listView")
    let masterPageItems = [
      {Title = "Transactions"; TargetType = Main}
      {Title = "Contacts"; TargetType =  Contact} ]

    do listView.ItemsSource <- masterPageItems |> List.toSeq

    member this.ListView = listView


type MainPage(cmds: UserCommands) as this = 
  inherit MasterDetailPage()
  let master = MainMenu() 

  let createDetailPage = function 
    | Contact -> NavigationPage(ContactsPage(cmds)) :> Page
    | Main -> NavigationPage(TabPage(cmds)) :> Page

  let clearSelection () = 
    master.ListView.SelectedItem <- null
    this.IsPresented <- false

  let changeDetail item = 
    Debug.WriteLine "Change detail"
    this.Detail <- createDetailPage (item.TargetType)
    clearSelection ()

  let d = master.ListView.ItemSelected.Subscribe (fun x -> 
    do match x.SelectedItem with 
        | null -> clearSelection ()
        | y -> changeDetail (y :?> MenuItem ) )

  do
    this.Master <- master
    this.Detail <- createDetailPage Main

  //override this.OnAppearing() = 
    //cmds.LoadData()

  

type FormsApp(path: String, provider: SQLitePCL.ISQLite3Provider, writeDb: string -> unit) as this = 
  inherit Application()
  let exporter = IExporter writeDb

  let model = {Items = []; DbPath = path; Provider = provider; Exporter = exporter}
  let repo = AppRepo(model)
  let cmds = UserCommands(repo)
  do this.MainPage <- MainPage(cmds)

