namespace TimeEntry

module DBService = 
    open Result
    open ConstrainedTypes
    open Constructors
    open DomainTypes
    open DBCommands
    open DTO

    let removeExistingData: unit -> Result<unit> = 
        TimeRecordAPI.deleteAll 
        >=> ActivityInfoAPI.deleteAll
        >=> UserAuthAPI.deleteAll
        >=> UserInfoAPI.deleteAll
        >=> ActivityAPI.deleteAll
        >=> ActivityInfoAPI.deleteAll
        >=> WorkOrderInfoAPI.deleteAll
        >=> MachineAPI.deleteAll
        >=> WorkCenterAPI.deleteAll
        >=> ShopFloorAPI.deleteAll
        >=> SiteAPI.deleteAll
        
    let insertReferenceData () = 
        let s1 = Site (String3 "F21")
        let s2 = Site (String3 "F22")

        let sf1 = {ShopFloorInfo.ShopFloor = ShopFloor (String5 "F211A"); Site = s1}
        let sf2 = {ShopFloorInfo.ShopFloor = ShopFloor (String5 "F221A"); Site = s2}

        let wc1 = {WorkCenterInfo.WorkCenter = WorkCenter (String5 "F1"); ShopFloorInfo = sf1; StartHour = Hour 4u; EndHour = Hour 4u}
        let wc2 = {WorkCenterInfo.WorkCenter = WorkCenter (String5 "F2"); ShopFloorInfo = sf1; StartHour = Hour 4u; EndHour = Hour 4u}

        let m1: MachineInfo = {Machine = Machine (String10 "Rooslvo"); ShopFloorInfo = sf1}
        let m2: MachineInfo = {Machine = Machine (String10 "Scoel12"); ShopFloorInfo = sf2}
        
        let formatF21 = { 
                Site            = s1; 
                Code            = ActivityCode (String4 "FOR"); 
                RecordLevel     = RecordLevel.WorkCenter WorkCenterAccess.All; 
                TimeType        = MachineTime; 
                ActivityLink    = Linked <| ActivityCode (String4 "MFOR"); 
                ExtraInfo       = ExtraInfo.WithoutInfo
                }
        let mformatF21 = {formatF21 with Code = ActivityCode (String4 "MFOR"); ActivityLink = Linked <| ActivityCode (String4 "FOR"); TimeType = LabourTime}

        let divF21 = { 
                Site            = s1; 
                Code            = ActivityCode (String4 "DIV"); 
                RecordLevel     = RecordLevel.WorkCenter WorkCenterAccess.All; 
                TimeType        = MachineTime; 
                ActivityLink    = Linked <| ActivityCode (String4 "MDIV"); 
                ExtraInfo       = ExtraInfo.WithoutInfo
                }

        let mdivF21 = {formatF21 with Code = ActivityCode (String4 "MDIV"); ActivityLink = Linked <| ActivityCode (String4 "DIV"); TimeType = LabourTime}

        let arrF21 = { 
                Site            = s1; 
                Code            = ActivityCode (String4 "ARR"); 
                RecordLevel     = RecordLevel.WorkCenter WorkCenterAccess.All; 
                TimeType        = MachineTime; 
                ActivityLink    = Linked <| ActivityCode (String4 "MARR"); 
                ExtraInfo       = ExtraInfo.WithInfo
                }

        let marrF21 = {arrF21 with Code = ActivityCode (String4 "MARR"); ActivityLink = Linked <| ActivityCode (String4 "ARR"); TimeType = LabourTime}
(*
        let extrainfo = {
                                Machine  = Machine (String10 "ZX"); 
                                Cause    = String50 "Arrêt imprévu";
                                Solution = String50 "Brancher la prise";
                                Comments = String200 "A retenir" 
                        }
        let actInfo2 = Detailed (ActivityCode (String4 "ARR"), extrainfo )
*)

        let wo1 = { 
                WorkOrder = WorkOrder (String10 "12243");
                ItemCode = ItemCode (String6 "099148") ; 
                WorkCenter = WorkCenter (String5 "F1");
                TotalMachineTimeHr = TimeHr 0.f;
                TotalLabourTimeHr = TimeHr 0.f;
                Status =  Open }
        
        let actInfo1 = Normal (ActivityCode (String4 "FOR"))
        
        SiteAPI.insert(s1) |> ignore
        SiteAPI.insert(s2) |> ignore

        ShopFloorAPI.insert(sf1) |> ignore        
        ShopFloorAPI.insert(sf2) |> ignore

        WorkCenterAPI.insert(wc1) |> ignore
        WorkCenterAPI.insert(wc2) |> ignore

        MachineAPI.insert(m1) |> ignore

        MachineAPI.insert(m2) |> ignore

        [formatF21; mformatF21; divF21; mdivF21; arrF21; marrF21]
        |> List.map ActivityAPI.insert
        |> ignore
//       ActivityInfoAPI.insert actInfo1 |> ignore
//        ActivityInfoAPI.insert actInfo2 |> ignore

        let user = { 
                Login           = Login (String8 "moureed1"); 
                Password        = Password (String50 "indaclub"); 
                Name            = UserName (String50 "Edouard"); 
                SiteAccess      = AllSites
                Level           = Admin
                  }
        UserInfoAPI.insert user |> ignore

    let validateUsercredential usercredential =
        let logins = UserInfoAPI.getUserLogins()
        UserCredential.fromDTO logins usercredential

    let validateLogin login = 
        let logins = UserInfoAPI.getUserLogins()
        Login.validate logins login


    let getUserInfo login = 
        let sites = SiteAPI.getSiteCodes All
        let logins = UserInfoAPI.getUserLogins()

        UserInfoAPI.getUser login
        |> Result.bind (DBConversions.UserInfo.fromDB sites logins)
    
    let updatePassword 
        login 
        password = 
                UserInfoAPI.updatePassword login password
                |> Result.bind(fun () -> getUserInfo login)
    
    let getAuthSiteCodes = 
        function 
            | AllSites    -> SiteAPI.getSiteCodes Active
            | SiteList ls ->
                let s = 
                    ls 
                    |> List.map(fun site -> site.ToString()) 
                    |> Set.ofList 
                
                SiteAPI.getSiteCodes Active
                |> Set.ofList
                |> Set.intersect s
                |> Set.toList

    let validateSite input = 
        let sites = SiteAPI.getSiteCodes All
        Site.validate sites input
    
    let newSite site = 
        let sites = SiteAPI.getSiteCodes All
        Site.create sites site

    let desactivateSite = SiteAPI.desactivate
    let activateSite = SiteAPI.activate

    let getActiveShopFloorCodesBySite site = ShopFloorAPI.getShopFloorCodesBySite Active site

    let getActiveWorkCenters () = async { return WorkCenterAPI.getWorkCenterCodes Active }

    let getActiveWorkCentersByShopfloor shopfloor = 
        WorkCenterAPI.getWorkCenterCodesByShopfloor Active shopfloor

    let validateShopFloor site input =
        let shopfloors = ShopFloorAPI.getShopFloorCodesBySite Active site
        ShopFloor.validate shopfloors input

    let validateWorkCenter shopfloor input =
        let workcenters = WorkCenterAPI.getWorkCenterCodesByShopfloor Active shopfloor
        WorkCenter.validate workcenters input

    let getWorkOrderByWorkCenter workcenter = 
        WorkOrderInfoAPI.getWorkOrderByWorkCenter Active workcenter

    let getActivityCodeByTimeTypeAndWorkCenter timetype workcenter = 
        //Retrieves activities linked to one workcenter
        let wcList = ActivityWorkCenterAccessAPI.getActivityCodeByTimeTypAndWorkCenter Active timetype workcenter
        //Add activities of level = WorkCenter + Access ALL = True
        let level = RecordLevel.WorkCenter WorkCenterAccess.All
        let accessallList = ActivityAPI.getActivityCodesWithAllAccessByLevelAndTimeType Active level timetype
        List.append wcList accessallList
        
    let getActivityCodeByTimeTypeAndShopFloor timetype shopfloor = 
        let sfList = ActivityShopFloorAccessAPI.getActivityCodeByTimeTypeAndShopFloor Active timetype shopfloor
        
        let level = RecordLevel.ShopFloor ShopFloorAccess.All
        let accessallList = ActivityAPI.getActivityCodesWithAllAccessByLevelAndTimeType Active level timetype
        List.append sfList accessallList

    let validateActivityCode entrylevel timetype shopfloor workcenter input = 
        let activities = 
                match entrylevel, workcenter with
                | EntryLevel.WorkCenter, Some wc -> 
                    getActivityCodeByTimeTypeAndWorkCenter timetype wc
                
                | EntryLevel.ShopFloor, _ -> 
                    getActivityCodeByTimeTypeAndShopFloor timetype shopfloor
                
                | EntryLevel.WorkCenter, None -> []
        
        ActivityCode.validate activities input

    let validateWorkOrder workcenter input = 
        let workorders = getWorkOrderByWorkCenter workcenter
        WorkOrder.validate workorders input

    let insertOrUpdateWorkOrder wo = 
         WorkOrderInfoAPI.updateStatus wo
         |> Result.either succeed (fun _ -> WorkOrderInfoAPI.insert wo)


    let saveTimeRecords userinfo (timerecords: TimeRecord list) = 
        timerecords
        |> Result.traverse (TimeRecordAPI.insert userinfo)
