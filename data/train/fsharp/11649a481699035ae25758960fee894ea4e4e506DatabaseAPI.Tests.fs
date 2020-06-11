module TimEntry.Tests.DatabasAPI

open Expecto

open TimeEntry.DomainTypes
open TimeEntry.DBConversions
open TimeEntry.DBCommands
open TimeEntry.DBService
open TimeEntry.Result
open TimeEntry.ConstrainedTypes

let stopOnFailure = function
  | Success x   -> ()
  | Failure msg -> Expect.equal (Failure msg) (Success ()) msg

//Unit tests of Database API functions
//Inspired by : https://fsharpforfunandprofit.com/posts/low-risk-ways-to-use-fsharp-at-work-4/

[<Tests>]
let testSite = 
  let site = Site (String3 "F21")
  
  testList "Site Database API" [
    testCase "Insert & Get" <| fun _ -> 
      
      removeExistingData() 
      |> stopOnFailure
      
      let step1 = "We expect to get one site after insert."
      SiteAPI.insert site
      |> stopOnFailure
      
      let cnt = SiteAPI.getSiteCodes All |> List.length
      Expect.equal cnt 1 step1;

    testCase "Desactivate" <| fun _ ->

      let step2 = "We expect to get no active site after desactivation."
      SiteAPI.desactivate site
      |> stopOnFailure
      
      let cnt = SiteAPI.getSiteCodes Active |> List.length
      Expect.equal cnt 0 step2;

      let step2' = "We still have one site in DB after desactivation."
      let cnt = SiteAPI.getSiteCodes All |> List.length
      Expect.equal cnt 1 step2';


    testCase "Activate" <| fun _ ->
      let step3 = "We expect to get one site after reactivation."

      SiteAPI.activate site
      |> stopOnFailure

      let cnt = SiteAPI.getSiteCodes Active |> List.length
      Expect.equal cnt 1 step3 ]

[<Tests>]
let testShopfloor = 
  let sf: ShopFloorInfo = {Site = Site (String3 "F21"); ShopFloor = ShopFloor (String5 "F211A") }
  let sfCode = "F211A"

  testList "ShopFloor Database API" [
    testCase "Insert & Get" <| fun _ -> 
      removeExistingData() 
      |> stopOnFailure
      
      let step1 = "We expect to get one shopfloor after insert."
      
      ShopFloorAPI.insert(sf) 
      |> stopOnFailure

      let cnt = ShopFloorAPI.getShopFloorCodes Active |> List.length
      Expect.equal cnt 1 step1

      let step1' = "We get the same shopfloor."
      
      let dbsf = ShopFloorAPI.getShopFloorInfo Active sf.ShopFloor
      let expected = ShopFloor.toDB sf |> Success
      
      Expect.equal dbsf expected step1';

    testCase "Desactivate" <| fun _ ->
      let step2 = "We expect to get no shopfloor after desactivation."
      ShopFloorAPI.desactivate(sfCode)
      |> stopOnFailure

      let cnt = ShopFloorAPI.getShopFloorCodes Active |> List.length
      Expect.equal cnt 0 step2;

    testCase "Activate" <| fun _ ->
      let step3 = "We expect to get one shopfloor after reactivation."
      
      ShopFloorAPI.activate(sfCode)
      |> stopOnFailure

      let cnt = ShopFloorAPI.getShopFloorCodes Active |> List.length
      Expect.equal cnt 1 step3 ]

[<Tests>]
let testWorkCenter = 
  let site = Site (String3 "F21")
  let sf: ShopFloorInfo =  {Site = site; ShopFloor = ShopFloor (String5 "F211A")}
  let wc: WorkCenterInfo = {WorkCenterInfo.WorkCenter = WorkCenter (String5 "F1"); ShopFloorInfo = sf; StartHour = Hour 4u; EndHour = Hour 4u}
  let wcCode = "F1"

  testList "WorkCenter Database API" [
    testCase "Insert & Get" <| fun _ -> 
      removeExistingData() 
      |> stopOnFailure

      //Insert necessary data 
      SiteAPI.insert(site)    
      |> stopOnFailure
      ShopFloorAPI.insert(sf) 
      |> stopOnFailure

      let step1 = "We expect to get one workcenter after insert."
      
      WorkCenterAPI.insert(wc) 
      |> stopOnFailure

      let cnt = WorkCenterAPI.getWorkCenterCodes Active |> List.length
      Expect.equal cnt 1 step1
      
      let step1' = "We get the same workcenter after insert."
      
      let dbwc = WorkCenterAPI.getWorkCenter(wcCode)
      let expected = WorkCenter.toDB wc |> Success

      Expect.equal dbwc expected step1';

    testCase "Desactivate" <| fun _ ->
      let step2 = "We expect to get no workcenter after desactivation."
      WorkCenterAPI.desactivate(wcCode)
      |> stopOnFailure

      let cnt = WorkCenterAPI.getWorkCenterCodes Active |> List.length
      Expect.equal cnt 0 step2;

    testCase "Activate" <| fun _ ->
      let step3 = "We expect to get one workcenter after reactivation."
      
      WorkCenterAPI.activate(wcCode)
      |> stopOnFailure

      let cnt = WorkCenterAPI.getWorkCenterCodes Active |> List.length
      Expect.equal cnt 1 step3

    testCase "Update" <| fun _ -> 
      let step4 = "We get the updated workcenter after update."
      
      let wc2 = {wc with StartHour = Hour 5u; EndHour = Hour 5u}
      
      WorkCenterAPI.update(wc2)
      |> stopOnFailure

      let expected = Success <| WorkCenter.toDB wc2
      let dbwc = WorkCenterAPI.getWorkCenter(wcCode)

      Expect.equal dbwc expected step4 ]

[<Tests>]
let testMachine = 
  let sf: ShopFloorInfo = {Site = Site (String3 "F21"); ShopFloor = ShopFloor (String5 "F211A")}
  let m1: MachineInfo = {Machine = Machine (String10 "Rooslvo"); ShopFloorInfo = sf}
  let (Machine (String10 machCode)) = m1.Machine

  testList "Machine Database API" [
    testCase "Insert & Get" <| fun _ -> 
      removeExistingData() 
      |> stopOnFailure
      
      let step1 = "We expect to get one machine after insert."
      
      //Insert necessary data
      ShopFloorAPI.insert(sf) 
      |> stopOnFailure

      MachineAPI.insert m1
      |> stopOnFailure

      let cnt = MachineAPI.getMachineCodes() |> List.length
      Expect.equal cnt 1 step1;

    testCase "Desactivate" <| fun _ ->
      let step2 = "We expect to get no machine after desactivation."
      
      MachineAPI.desactivate(machCode)
      |> stopOnFailure

      let cnt = MachineAPI.getMachineCodes() |> List.length
      Expect.equal cnt 0 step2;

    testCase "Activate" <| fun _ ->
      let step3 = "We expect to get one machine after reactivation."
      
      MachineAPI.activate(machCode)
      |> stopOnFailure

      let cnt = MachineAPI.getMachineCodes() |> List.length
      Expect.equal cnt 1 step3 ]

[<Tests>]
let testActivity = 
  let pan = { 
                Site            = Site (String3 "F21"); 
                Code            = ActivityCode (String4 "PAN"); 
                RecordLevel     = RecordLevel.WorkCenter WorkCenterAccess.All; 
                TimeType        = MachineTime; 
                ActivityLink    = Linked <| ActivityCode (String4 "MPAN"); 
                ExtraInfo       = ExtraInfo.WithoutInfo
                }

  testList "Activity Database API" [
    testCase "Insert & Get" <| fun _ -> 
      removeExistingData() 
      |> stopOnFailure
      
      let step1 = "We expect to get one activity after insert."
      
      ActivityAPI.insert(pan)
      |> stopOnFailure

      let cnt = ActivityAPI.getActivityCodes Active |> List.length
      Expect.equal cnt 1 step1;

    testCase "Desactivate" <| fun _ ->
      let step2 = "We expect to get no activity after desactivation."
      
      ActivityAPI.desactivate("PAN")
      |> stopOnFailure

      let cnt = ActivityAPI.getActivityCodes Active |> List.length
      Expect.equal cnt 0 step2;

    testCase "Activate" <| fun _ ->
      let step3 = "We expect to get one activity after reactivation."
      
      ActivityAPI.activate("PAN")
      |> stopOnFailure

      let cnt = ActivityAPI.getActivityCodes Active |> List.length
      Expect.equal cnt 1 step3
      
    testCase "Update" <| fun _ -> 
      let step4 = "We get the updated activity after update."
      
      let pan' = {pan with ExtraInfo = WithInfo}
      
      ActivityAPI.update pan'
      |> stopOnFailure

      let expected = Success <| Activity.toDB pan'
      let dbwc = ActivityAPI.getActivity pan.Code

      Expect.equal dbwc expected step4]


[<Tests>]
let testWorkOrder =  
  let wo = { 
          WorkOrder   = WorkOrder (String10 "0123456789"); 
          ItemCode    = ItemCode (String6 "099148"); 
          WorkCenter  = WorkCenter (String5 "F1"); 
          TotalMachineTimeHr = TimeHr 0.f; 
          TotalLabourTimeHr = TimeHr 0.f; 
          Status      =  Open }

  let woCode = wo.WorkOrder.ToString()
  testList "WorkOrder Database API" [    
    testCase "Insert & Get" <| fun () -> 
      removeExistingData()
      |> stopOnFailure
      
      //Insert Reference data
      insertReferenceData()
      
      let step1 = "We expect to get one work order after insert."
      
      WorkOrderInfoAPI.insert wo 
      |> stopOnFailure

      let cnt = WorkOrderInfoAPI.getWorkOrderCodes Active |> List.length
      Expect.equal cnt 1 step1;

    testCase "Update" <| fun _ -> 
      let step4 = "We get the updated work order after update."
      
      //change all fields except workorder code (Id)
      let wo' = { 
          WorkOrder   = wo.WorkOrder
          ItemCode    = ItemCode (String6 "099146"); 
          WorkCenter  = WorkCenter (String5 "F2"); 
          TotalMachineTimeHr = TimeHr 230.f; 
          TotalLabourTimeHr = TimeHr 120.f; 
          Status      =  Closed }
      
      WorkOrderInfoAPI.update wo'
      |> stopOnFailure

      let expected = Success <| WorkOrderInfo.toDB wo'
      let dbwo = WorkOrderInfoAPI.getWorkOrder Active wo.WorkOrder

      Expect.equal dbwo expected step4]

[<Tests>]
let testUserInfo =  
  let login = Login (String8 "andrecl1")

  let user = { 
                Login           = Login (String8 "andrecl1"); 
                Password        = Password (String50 "peroux2010"); 
                Name            = UserName (String50 "Clotilde"); 
                SiteAccess      = AllSites
                Level           = Admin
            }

  testList "UserInfoAPI" [    
    testCase "Insert & Get" <| fun () -> 
      removeExistingData()
      |> stopOnFailure
           
      insertReferenceData()

      let step1 = "We expect to get one more user after insert."
      
      let cnt = UserInfoAPI.getUserLogins() |> List.length

      UserInfoAPI.insert user 
      |> stopOnFailure

      let cnt' = UserInfoAPI.getUserLogins() |> List.length
      Expect.equal cnt' (cnt + 1) step1;

    testCase "Update Name, Password, AuthLevel" <| fun _ -> 
      let step4 = "We get the updated user after update."
      
      let user' = { 
                Login           = Login (String8 "andrecl1"); 
                Password        = Password (String50 "aba2oies"); 
                Name            = UserName (String50 "Clo"); 
                SiteAccess      = SiteAccess.AllSites
                Level           = KeyUser
            }

      UserInfoAPI.update user'
      |> stopOnFailure

      let expected = Success <| UserInfo.toDB user'
      let dbus = UserInfoAPI.getUser(login)

      Expect.equal dbus expected step4
    
    testCase "UpdatePassword" <| fun _ -> 
      let step5 = "We get the updated user with updated password after update."
      
      UserInfoAPI.update user
      |> stopOnFailure

      let newPassword = Password (String50 "HELLO")
      
      let user' = { user with Password = newPassword }

      UserInfoAPI.updatePassword login newPassword
      |> stopOnFailure

      let expected = Success <| UserInfo.toDB user'
      let dbus = UserInfoAPI.getUser(login)

      Expect.equal dbus expected step5 ]
    
[<EntryPoint>]
let main args =
  let config = { defaultConfig with parallel  = false }
  runTestsInAssembly config args