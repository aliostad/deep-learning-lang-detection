USE VipPay
IF EXISTS ( SELECT  1
            FROM    SYSOBJECTS
            WHERE   ID = OBJECT_ID('CustomerFindByParentAgent', 'P') ) 
    DROP PROCEDURE dbo.CustomerFindByParentAgent
GO
/*
 * Designer:     Mort	
 * Description:  
 * Created:      06/21/2014
 * History:
 * =============================================================================
 * Author      DateTime        Alter Description
 * =============================================================================
 */
 
 
CREATE PROCEDURE dbo.CustomerFindByParentAgent
    (
      @ParentCustomerId UNIQUEIDENTIFIER ,
      @RealName NVARCHAR(50) ,
      @CustomerType VARCHAR(5) ,
      @StartDate DATETIME ,
      @EndDate DATETIME ,
      @Status INT 
    )
AS 
    BEGIN
        CREATE TABLE #finalCustomer
            (
              CustomerId UNIQUEIDENTIFIER
            )
        CREATE TABLE #ChildCustomer
            (
              CustomerId UNIQUEIDENTIFIER
            )
        CREATE TABLE #TempCustomer
            (
              CustomerId UNIQUEIDENTIFIER
            )
		
        INSERT  INTO #ChildCustomer
                SELECT  CustomerId
                FROM    dbo.T_Customer c ( NOLOCK )
                WHERE   c.ParentAgent = @ParentCustomerId
		        
        DECLARE @childCount INT
        SELECT  @childCount = COUNT(1)
        FROM    #ChildCustomer 
        WHILE ( @childCount > 0 ) 
            BEGIN
                INSERT  INTO #finalCustomer
                        SELECT  CustomerId
                        FROM    #ChildCustomer
			
                INSERT  INTO #TempCustomer
                        SELECT  CustomerId
                        FROM    #ChildCustomer
				
				--reset #ChildCustomer
                DELETE  #ChildCustomer
                INSERT  INTO #ChildCustomer
                        SELECT  c.CustomerId
                        FROM    dbo.T_Customer c ( NOLOCK )
                                INNER JOIN #TempCustomer t ON c.ParentAgent = t.CustomerId
                --rest #TempCustomer
                DELETE  #TempCustomer
                --reset @childCount
                SELECT  @childCount = COUNT(1)
                FROM    #ChildCustomer  
            END
		
        SELECT  c.* ,
                p.CustomerName AS ParentCustomer ,
                p.RealName AS ParentCustomerName ,
                p.CustomerType AS ParentCustomerType
        FROM    dbo.T_Customer c ( NOLOCK )
				INNER JOIN #finalCustomer f ON c.CustomerId = f.CustomerId
                INNER JOIN dbo.T_Customer p ( NOLOCK ) ON c.ParentAgent = p.CustomerId
        WHERE   ( ISNULL(@RealName, '') = ''
                  OR c.RealName LIKE +'%' + @RealName + '%'
                )
                AND ( ISNULL(@CustomerType, '') = ''
                      OR c.CustomerType = @CustomerType
                    )
                AND ( ISNULL(@StartDate, '') = ''
                      OR c.CreateDate >= @StartDate
                    )
                AND ( ISNULL(@EndDate, '') = ''
                      OR c.CreateDate <= @EndDate
                    )
                AND ( ISNULL(@Status, 999) = 999
                      OR c.Status = @Status
                    )
                    
        DROP TABLE #finalCustomer
        DROP TABLE #ChildCustomer
        DROP TABLE #TempCustomer
    END 
GO

/*
SELECT * FROM dbo.T_Customer
EXEC dbo.CustomerFindByParentAgent @ParentCustomerId = '6859B5A3-620C-4FE6-BCB0-B7AC93269909', -- uniqueidentifier
    @RealName = N'', -- nvarchar(50)
    @CustomerType = '', -- varchar(5)
    @StartDate = null, -- datetime
    @EndDate = null, -- datetime
    @Status = 999 -- int
*/