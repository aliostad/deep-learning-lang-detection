namespace AyinExcelAddIn.Backoffice

open System.Drawing
open System.Linq
open System.Windows.Forms

open AyinExcelAddIn
open AyinExcelAddIn.Utils
open AyinExcelAddIn.Backoffice
open AyinExcelAddIn.Gui

[<AutoOpen>]
module BrokerFunctions =

    type BrokerInfoForm() as this =
        inherit Form(Text = "Broker Info",
                     FormBorderStyle = FormBorderStyle.FixedSingle,
                     Height = 400,
                     Width = 400,
                     BackColor = Color.White)

        // Broker field
        static let brokerLabel = new Label(Text = "Broker", Top = 27, Left = 10, Height = 23, Width = 80)
        let brokerBox = new ComboBox(Top = 27, Left = 90, Height = 23, Width = 160)

        static let notesLabel = new Label(Text = "Notes", Top = 55, Left = 10, Height = 23, Width = 80)
        let notesBox = new RichTextBox(Top = 55, Left = 90, Height = 250, Width = 290)

        let okButton = new Button(Text = "Ok", Top = 330, Left = 230, Width = 65, BackColor = Color.LightGray)
        let cancelButton = new Button(Text = "Cancel", Top = 330, Left = 125, Width = 65, BackColor = Color.LightGray)

        let showNote (b: Broker.T) = notesBox.Text <- b.notes

        do 
            // Populate the broker combo box
            brokerBox.DataSource <- Broker.allBrokers |> List.sortBy (fun b -> b.name) |> function bs -> bs.ToList()
            brokerBox.DisplayMember <- "name"
            brokerBox.ValueMember <- "id"
            brokerBox.SelectedIndexChanged.Add(fun _ -> showNote <| unbox brokerBox.SelectedItem)

            notesBox.Multiline <- true
            // Add scroll bars
            notesBox.ScrollBars <- RichTextBoxScrollBars.Vertical
            // Allow the TAB key to be entered
            notesBox.AcceptsTab <- true
            // Allow text to wrap to the next line
            notesBox.WordWrap <- true
            // Add event handler to process clicked links
            notesBox.LinkClicked.Add(fun l -> System.Diagnostics.Process.Start(l.LinkText) |> ignore)

            okButton.Click.Add(fun _ -> this.Save()
                                        this.Hide()
                              )

            cancelButton.Click.Add(fun _ -> this.Hide())

            // Create the form window
            this.Controls.Add(brokerBox)
            this.Controls.Add(brokerLabel)
            this.Controls.Add(notesBox)
            this.Controls.Add(notesLabel)

            this.Controls.Add(okButton)
            this.Controls.Add(cancelButton)

            this.AcceptButton <- okButton

            this.Load.Add(fun _ -> showNote <| unbox brokerBox.SelectedItem)

            this.ShowDialog() |> ignore

        member private this.Save() =
            let db = Db.nyabsDbCon.GetDataContext()
            let bid = unbox brokerBox.SelectedValue

            let b = query {
                for x in db.Backoffice.Brokers do
                where (x.Id = bid)
                headOrDefault
            }

            match b with
            | null -> ErrorBox "Couldn't find broker"
            | _    -> 
                    b.Notes <- notesBox.Text
                    db.SubmitUpdates()

    ///
    ///
    ///
    let public brokersDialog () = new BrokerInfoForm()

    ///
    ///
    ///
    type BondBrokerForm() as this =
        inherit Form(Text = "Bond Brokers",
                     FormBorderStyle = FormBorderStyle.FixedSingle,
                     Height = 320,
                     Width = 275,
                     BackColor = Color.White)

        // Security field
        static let securityLabel = new Label(Text = "Security", Top = 27, Left = 10, Height = 23, Width = 80)
        let securityBox = new ComboBox(Top = 27, Left = 90, Height = 23, Width = 160)

        // Broker field
        static let brokersLabel = new Label(Text = "Brokers", Top = 55, Left = 10, Height = 23, Width = 80)
        let brokersBox = new CheckedListBox(Top = 55 , Left = 90, Height = 180, Width = 160)

        let okButton = new Button(Text = "Ok", Top = 250, Left = 150, Width = 65, BackColor = Color.LightGray)
        let cancelButton = new Button(Text = "Cancel", Top = 250, Left = 45, Width = 65, BackColor = Color.LightGray)

        let securities = Security.allSecurities
                         |> List.filter (fun s -> (s.sectype = Security.ABS) || (s.sectype = Security.CONVERTIBLE))
                         |> List.sortBy (fun s -> s.symbol)

        let checkedBrokers (s: Security.T) = 
            // First clear all the checked items
            brokersBox.CheckedIndices
            |> Seq.cast<int>
            |> Seq.iter (fun i -> brokersBox.SetItemChecked(i, false))


            Broker.quotingBrokers s
            |>  List.iter (fun b -> brokersBox.SetItemChecked(brokersBox.FindStringExact(b.name), true))


        // Auto-complete list for the security symbols
        let symbolCompCol = new AutoCompleteStringCollection()
        do 
            securities
            |> List.map (fun s -> symbolCompCol.Add(s.symbol))
            |> ignore

            securityBox.DataSource <- securities.ToList()
            securityBox.DisplayMember <- "symbol"
            securityBox.ValueMember <- "id"
            securityBox.AutoCompleteMode <- AutoCompleteMode.Suggest
            securityBox.AutoCompleteSource <- AutoCompleteSource.CustomSource
            securityBox.AutoCompleteCustomSource <- symbolCompCol
            securityBox.SelectedIndexChanged.Add(fun _ -> checkedBrokers <| unbox securityBox.SelectedItem)

            // Populate the broker list box
            brokersBox.DataSource <- Broker.allBrokers |> List.sortBy (fun b -> b.name) |> function bs -> bs.ToList()
            brokersBox.DisplayMember <- "name"
            brokersBox.ValueMember <- "id"
            brokersBox.CheckOnClick <- true

            okButton.Click.Add(fun _ -> 
                                    this.Save()
                                    this.Hide()
                              )

            cancelButton.Click.Add(fun _ -> this.Hide())

            // Create the form window
            this.Controls.Add(securityBox)
            this.Controls.Add(securityLabel)
            this.Controls.Add(brokersBox)
            this.Controls.Add(brokersLabel)
            this.Controls.Add(okButton)
            this.Controls.Add(cancelButton)

            this.AcceptButton <- okButton

            this.Load.Add(fun _ -> checkedBrokers <| List.head securities)

            this.ShowDialog() |> ignore

        member private this.Save() =
            let db = Db.nyabsDbCon.GetDataContext()
            let sid = unbox securityBox.SelectedValue
            let brokers = db.Backoffice.QuotingBrokers

            query {
                for x in db.Backoffice.QuotingBrokers do
                where (x.SecurityId = sid)
            }
            |> Seq.iter (fun qb -> qb.Delete())

            brokersBox.CheckedItems
            |> Seq.cast<Broker.T>
            |> Seq.iter (fun b ->
                                let newBroker = brokers.Create()
                                newBroker.SecurityId <- sid
                                newBroker.BrokerId <- b.id)

            db.SubmitUpdates()

             
    ///
    ///
    ///
    let public bondBrokersDialog c = new BondBrokerForm()



