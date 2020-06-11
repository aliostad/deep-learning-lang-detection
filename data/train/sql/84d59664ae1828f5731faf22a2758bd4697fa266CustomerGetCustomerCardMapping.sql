USE ZRH
IF EXISTS ( SELECT  1
            FROM    SYSOBJECTS
            WHERE   ID = OBJECT_ID('dbo.CustomerGetCustomerCardMapping', 'P') )
    DROP PROCEDURE dbo.CustomerGetCustomerCardMapping
GO
/*
 * Designer:     
 * Description:  
 * Created:      30/11/2013
 * History:
 * =============================================================================
 * Author      DateTime        Alter Description
 * =============================================================================
 
*/
CREATE PROCEDURE CustomerGetCustomerCardMapping ( @CustomerId INT )
AS
    BEGIN
        SELECT TOP 1
                *
        FROM    dbo.T_CustomerCardMapping
        WHERE   CustomerId = @CustomerId
        ORDER BY CreateDate DESC
    END
GO

--EXEC dbo.CustomerGetCustomerCardMapping @CustomerId = 6 -- int
