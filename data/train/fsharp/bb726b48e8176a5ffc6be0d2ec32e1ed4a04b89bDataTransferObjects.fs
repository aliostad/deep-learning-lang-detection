namespace Opportunity.DataTransferObjects

open System
open System.ComponentModel.DataAnnotations

[<CLIMutable>]
type Application = {
    OpportunityId: int
    
    UserId: int
    
    IsSubmitted: bool

    ApplicationDate: option<DateTime>
    
    [<StringLength(1024)>]
    ApplicationText: string
    
    MeetingTime: option<DateTime>

    MeetingDuration: option<int>

    IsSuccessful: option<bool>

    [<StringLength(400)>]
    OwnerComments: string option

    UpdatedAt: DateTime

    [<StringLength(32)>]
    UpdatedBy: string
}

[<CLIMutable>]
type NewApplication = {
    OpportunityId: int
    
    UserId: int
    
    IsSubmitted: bool

    [<Required; StringLength(1024)>]
    ApplicationText: string
}


[<CLIMutable>]
type ApplicationMeetingRequest = {
    OpportunityId: int
    
    UserId: int
    
    MeetingTime: option<DateTime>

    MeetingDuration: option<int>

    [<StringLength(400)>]
    OwnerComments: string
}

[<CLIMutable>]
type ApplicationOutcome = {
    OpportunityId: int
    
    UserId: int
    
    IsSuccessful: option<bool>

    [<StringLength(400)>]
    OwnerComments: string
}

[<CLIMutable>]
type Category = {
    Id: int


    [<Required; StringLength(64)>]
    Name: string

    [<Required; StringLength(32)>]
    Icon: string
}

[<CLIMutable>]
type NewInitiative = {
    Name: string
    Description: string
    Link: string
    LogoUrl: string
    StartDate: DateTime
    EndDate: DateTime
    OrganizationalUnitId: int 
}

[<CLIMutable>]
type Initiative = {
    Id: int

    [<Required; StringLength(50)>]
    Name: string

    [<StringLength(200)>]
    Description: string option
    
    [<StringLength(100)>]
    Link: string option
    
    [<StringLength(80)>]
    LogoUrl: string option

    StartDate: DateTime
    
    EndDate: DateTime

    OrganizationalUnitId: int
    
    UpdatedAt: DateTime
    
    [<StringLength(32)>]
    UpdatedBy: string

    Version: string
}


[<CLIMutable>]
type OrganizationalUnit = {
    Id: int
    Name: string
    Colour: string
    Icon: option<string>
    SubOrgUnits: OrganizationalUnit[]
}
 
[<CLIMutable>]
type ToggleFollower = {
    SubjectType: string
    SubjectId: int
}

[<CLIMutable>]
type SubjectFollower = {
    SubjectType: string
    SubjectId: int
    SubjectName: string
    FollowerId: int
    FollowerName: string
    CreatedAt: DateTime
}


[<CLIMutable>]
type UserDetails = {
    Id: int
    Account: string
    FirstName: string
    FamilyName: string
    Email: string
    ProfileUrl: string
    PhotoUrl: string
    HasOpenApplications: bool
    HasOpenOpportunities: bool
    CanManageOpportunities: bool
    Following: SubjectFollower[]
}

[<CLIMutable>]
type RefData = {
    Categories: Category[]
    OrgUnits: OrganizationalUnit[]
}