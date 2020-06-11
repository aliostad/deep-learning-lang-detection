namespace Opportunity.Controllers
open System
open System.Collections.Generic
open System.Linq
open System.Net.Http
open System.Web.Http

open Opportunity.Domain
open Opportunity.DataTransferObjects
open System.Runtime.InteropServices

/// Retrieves values.
[<Authorize>]
[<RoutePrefix("api")>]
type ValuesController() =
    inherit ApiController()

    [<Route("referenceData")>]
    member x.GetReferenceData (): IHttpActionResult = 
        x.Ok(Opportunity.ReferenceData.RefData) :> _

    /// Gets all values.
    [<Route("users/current")>]
    member x.Get(): IHttpActionResult = 
        let acc = x.User.Identity.Name
        let u = DataAccess.getUser acc
        x.Ok({UserDetails.Id = u.Id
              Account = u.AccountName
              FirstName = u.FirstName; 
              FamilyName=u.FamilyName; 
              Email = u.EmailAddress; 
              ProfileUrl = u.ProfileUrl
              PhotoUrl = u.ImageUrl
              HasOpenApplications = Option.isSome u.AppId
              HasOpenOpportunities = Option.isSome u.OpId
              CanManageOpportunities = true
              Following = [||]}) :> _

    [<Route("initiatives/{id:int}", Name="GetInitiative")>]
    member x.GetInitiative (id: int) : IHttpActionResult =
        let maybeInit = DataAccess.getInitiative id
        match maybeInit with
        | None -> x.NotFound() :> _
        | Some init -> x.Ok({Initiative.Id = init.Id
                             Name = init.Name
                             Description = init.Description
                             Link  = init.Link
                             LogoUrl = init.LogoUrl
                             StartDate = init.StartDate
                             EndDate = init.EndDate
                             OrganizationalUnitId = init.OrganizationalUnitId
                             UpdatedAt = init.UpdatedAt
                             UpdatedBy = init.UpdatedBy 
                             Version = Convert.ToBase64String(init.Version) }) :> _

    [<Route("initiatives/current")>]
    member x.GetCurrentInitiatives([<Optional;DefaultParameterValue(0)>]pageIndex: Nullable<int>, 
                                   [<Optional;DefaultParameterValue(20)>]pageSize: Nullable<int>): IHttpActionResult =
        let inits = DataAccess.getActiveInitiatives (pageSize.GetValueOrDefault(20)) 
                                                    (pageIndex.GetValueOrDefault(0)) 
                                                    DateTime.Today
                    |> Array.map (fun init -> {Initiative.Id = init.Id
                                               Name = init.Name
                                               Description = init.Description
                                               Link  = init.Link
                                               LogoUrl = init.LogoUrl
                                               StartDate = init.StartDate
                                               EndDate = init.EndDate
                                               OrganizationalUnitId = init.OrganizationalUnitId
                                               UpdatedAt = init.UpdatedAt
                                               UpdatedBy = init.UpdatedBy 
                                               Version = Convert.ToBase64String(init.Version) })
        x.Ok(inits) :> _
    
    
    [<Route("initiatives/all")>]
    member x.GetAllInitiatives ([<Optional;DefaultParameterValue(0)>]pageIndex: Nullable<int>, 
                                [<Optional;DefaultParameterValue(20)>]pageSize: Nullable<int>): IHttpActionResult =
        let inits = DataAccess.getAllInitiatives (pageSize.GetValueOrDefault(20)) 
                                                 (pageIndex.GetValueOrDefault(0)) 
                                                 
                    |> Array.map (fun init -> {Initiative.Id = init.Id
                                               Name = init.Name
                                               Description = init.Description
                                               Link  = init.Link
                                               LogoUrl = init.LogoUrl
                                               StartDate = init.StartDate
                                               EndDate = init.EndDate
                                               OrganizationalUnitId = init.OrganizationalUnitId
                                               UpdatedAt = init.UpdatedAt
                                               UpdatedBy = init.UpdatedBy 
                                               Version = Convert.ToBase64String(init.Version) })
        x.Ok(inits) :> _

    [<Route("initiatives/new")>]
    member x.PostNewInitiative (initiative: NewInitiative): IHttpActionResult =
        let userName = x.User.Identity.Name
        let result = DataAccess.createInitiative initiative.Name 
                                                initiative.Description
                                                initiative.Link
                                                initiative.LogoUrl
                                                initiative.StartDate
                                                initiative.EndDate
                                                userName
                                                initiative.OrganizationalUnitId

        match result with
        | Some y -> x.CreatedAtRoute("GetInitiative", 
                                     dict([ ("id", y.Id ) ]), 
                                     {Initiative.Id = y.Id
                                      Name = initiative.Name
                                      Description = Some initiative.Description
                                      Link  = Some initiative.Link
                                      LogoUrl = Some initiative.LogoUrl
                                      StartDate = initiative.StartDate
                                      EndDate = initiative.EndDate
                                      OrganizationalUnitId = initiative.OrganizationalUnitId
                                      UpdatedAt = y.UpdatedAt
                                      UpdatedBy = userName
                                      Version = Convert.ToBase64String(y.Version) }) :> _
                                    
        | _ -> x.InternalServerError() :> _

