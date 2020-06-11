 
 go
 if object_id('uspfn_OmTrSalesModelList') is not null
	drop procedure uspfn_OmTrSalesModelList

go
create procedure uspfn_OmTrSalesModelList
	@CompanyCode varchar(25),
	@BranchCode varchar(25),
	@SoNumber varchar(35)
as

begin
	select a.* 
	     , b.SalesModelDesc
	  from omTrSalesSOModel a
	 inner join omMstModelYear b
	    on a.CompanyCode = b.CompanyCode
	   and b.SalesModelCode = a.SalesModelCode
	   and b.SalesModelYear = a.SalesModelYear
	   and b.Status in ('1', '2')
	 where a.CompanyCode = @CompanyCode
	   and a.BranchCode = @BranchCode
	   and a.SONo = @SoNumber
end
	


go
exec uspfn_OmTrSalesModelList '6115204', '611520402', 'SOC/11/000001'


