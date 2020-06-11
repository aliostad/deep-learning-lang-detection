namespace XLCatlin.DataLab.XCBRA.DomainModel

/// Errors associated with a bad query execution
type ApiQueryError =
    /// 400: The data in the query is invalid, return a list of errors
    | ValidationError of ValidationError list
    /// 400: The query cannot be executed - e.g. querying a non-existent object, no more pages to return, etc
    | QueryError of string
    /// 403: Credentials are bad
    | AuthenticationError of string
    /// 500: A server side error
    | ServerError of string

/// The result of a query execution that is expected to return a single record
type ApiSingleResult<'ReadModel> = 
    Result<'ReadModel,ApiQueryError> 

/// The result of a query execution that is expected to return a list of records
type ApiListResult<'ReadModel> = 
    Result<'ReadModel list,ApiQueryError> 

type ApiPaging = {
    /// zero-based
    offset : int  
    /// number of records to fetch
    fetchNext : int  
    }

/// A query for a single item
/// Authentication/Authorization is performed out-of-band.
type ApiIdQuery<'Id> = 
    {
    id : 'Id
    }

/// A query for a list of items
/// Authentication/Authorization is performed out-of-band.
type ApiListQuery<'Filter> = 
    {
    filter : 'Filter
    paging : ApiPaging 
    }

/// The query service has one method/endpoint for each possible query
type IApiQueryService = 
   abstract member AllLocations : ApiListQuery<LocationFilter> -> Async<ApiListResult<LocationSummary>>

   abstract member LocationById : ApiIdQuery<LocationId> -> Async<ApiSingleResult<Location>>

   abstract member BuildingsAtLocation : ApiListQuery<BuildingFilter> -> Async<ApiListResult<BuildingSummary>>

   abstract member WarehouseById : ApiIdQuery<BuildingId> -> Async<ApiSingleResult<Warehouse>>
