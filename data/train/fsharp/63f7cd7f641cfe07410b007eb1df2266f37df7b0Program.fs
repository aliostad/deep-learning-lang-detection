open System
open System.Windows.Forms
open System.Collections.Generic

type cars(price : int, model : string, earn : int) =
  
  let price = price
  let model = model

  member this.Coasts = price
  member this.Earn = earn
  member this.ShowModel = model
  member this.IsEnough(balance : int) = balance >= this.Coasts

let CarsArray = [|new cars(0, "Foot", 100); new cars(1000, "Audi", 500); new cars(5000, "Toyota", 1000); new cars(15000, "Honda", 3000); new cars(30000, "VolksWagen", 10000); new cars(100000, "Ford", 25000); new cars(300000, "Mitsubishi", 100000); new cars(1000000, "Mersedes", 500000)|]

let mutable balance = 0
let mutable (CurrentCar : cars) = CarsArray.[0]  


let buttonArray = [|for i in 0..(CarsArray.Length - 1) -> new Button(Text = "Buy " + CarsArray.[i].ShowModel, Left = 10, Top = 10 + i * 30, Width = 100, Enabled = false)|]

let WorkWithButtonsEnabledAndBalance(carsArray : cars array, buttonArray : Button array, carNumber : int) =
  
  for i in 1..(carsArray.Length - 1) do
    if balance < carsArray.[i].Coasts || not (CurrentCar <> carsArray.[i]) then buttonArray.[i - 1].Enabled <- false
  CurrentCar <- carsArray.[carNumber]
  balance <- balance - carsArray.[carNumber].Coasts

//Форма для покупки машины. Нажимаем на кнопку - покупаем машину, всё просто.

let CarForm = 
    
  let form = new Form(Text = "Choosing the car")

  let textBox = new TextBox(Text = "Congratulations! You win!", Top = 100, Left = 150)

  let buttonPressArray = [|for i in 0..CarsArray.Length - 2 -> fun (o:Object) (e : EventArgs) -> WorkWithButtonsEnabledAndBalance(CarsArray, buttonArray, i)
                                                                                                 if CurrentCar = CarsArray.[7] then MessageBox.Show(textBox.Text) |> ignore
                                                                                                                                    failwith "The game ends"
                         |]

  let handlersArray = [|for i in 0..CarsArray.Length - 2 -> new EventHandler(buttonPressArray.[i])|]
  
  for i in 1..CarsArray.Length - 2 do
    buttonArray.[i].Click.AddHandler(handlersArray.[i])

  let dc c = (c :> Control)

  form.Controls.AddRange([|for i in 1..CarsArray.Length - 1 -> dc buttonArray.[i]|])

  form.FormClosing |> Event.add (fun e -> form.Hide(); e.Cancel <- true)

  form

//Форма-лохотрон(на везение). Нажимаем на кнопку, получаем машину от Audi до Ford, или же теряем текущую.

let LuckyForm = 
    
  let rand = new Random()
  let form = new Form(Text = "Lucky or Not")
  let button = new Button(Text = "Press it!", Left = 40,
                            Top = 20, Width = 80, Enabled = true)

  let MainbuttonPress _ _ = 
        match rand.Next(8) with
        | 0 -> CurrentCar <- CarsArray.[0]
        | 1 -> CurrentCar <- CarsArray.[1]
        | 2 -> CurrentCar <- CarsArray.[2]
        | 3 -> CurrentCar <- CarsArray.[3]
        | 4 -> CurrentCar <- CarsArray.[4]
        | 5 -> CurrentCar <- CarsArray.[5]
        | 6 -> CurrentCar <- CarsArray.[0]
        | 7 -> CurrentCar <- CarsArray.[0]
        | 8 -> CurrentCar <- CarsArray.[0]
        | _ -> failwith "WrongCar"
        MessageBox.Show(CurrentCar.ShowModel) |> ignore

  form.FormClosing |> Event.add (fun e -> form.Hide(); e.Cancel <- true)

  let MaineventHandler = new EventHandler(MainbuttonPress)

  button.Click.AddHandler(MaineventHandler)

  let dc c = (c :> Control)

  form.Controls.AddRange([| dc button |])

  form

//Основная форма. 4 кнопки: Вызвать форму "Buy car", вызвать форму "Lucky or not", посмотреть текущую машину и получить деньги.
//Деньги получаем в зависимости от модели машины, Побеждаем, если покупаем Mersedes.

let mainForm = 

    let form = new Form(Text = "Cars&Money")

    let yourBalance = new TextBox(Text = balance.ToString(),
                            Top = 100, Left = 150)
    let yourCar = new TextBox(Text = CurrentCar.ShowModel,
                            Top = 100, Left = 150)

    let chooseCarButton = new Button(Text = "ChooseYourCar", Left = 10,
                                 Top = 10, Width = 100, Enabled = true)
    let yourLuckButton = new Button(Text = "TestYourLuck", Left = 10,
                                  Top = 100, Width = 100, Enabled = true)
    let earnYourMoneyButton = new Button(Text = "Earn your money", Left = 150,
                                 Top = 10, Width = 100, Enabled = true)
    let yourCarButton = new Button(Text = "Your car", Left = 150,
                                 Top = 100, Width = 100, Enabled = true)                                                                                         
    let ChooseCarbuttonPress _ _ = CarForm.Show()
    let LuckyFormbuttonPress _ _ = LuckyForm.Show()
    let GetMoneybuttonPress _ _  = balance <- balance + CurrentCar.Earn
                                   yourBalance.Text <- balance.ToString()
                                   MessageBox.Show(yourBalance.Text) |> ignore
                                   for i in 1..CarsArray.Length - 1 do if balance >= CarsArray.[i].Coasts && CurrentCar <> CarsArray.[i] then buttonArray.[i].Enabled <- true

    let ShowCarbuttonPress _ _   = yourCar.Text <- CurrentCar.ShowModel
                                   MessageBox.Show(yourCar.Text) |> ignore


    let ChooseCareventHandler = new EventHandler(ChooseCarbuttonPress)
    let LuckyFormeventHandler = new EventHandler(LuckyFormbuttonPress)
    let GetMoneyeventHandler  = new EventHandler(GetMoneybuttonPress)
    let ShowCareventHandler   = new EventHandler(ShowCarbuttonPress)

    chooseCarButton.Click.AddHandler(ChooseCareventHandler)
    yourLuckButton.Click.AddHandler(LuckyFormeventHandler) 
    earnYourMoneyButton.Click.AddHandler(GetMoneyeventHandler)
    yourCarButton.Click.AddHandler(ShowCareventHandler)

    let dc c = (c :> Control)

    form.Controls.AddRange([| dc chooseCarButton; dc yourLuckButton; dc earnYourMoneyButton; dc yourCarButton|])

    form

do Application.Run(mainForm)