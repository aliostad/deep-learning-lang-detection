SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--
-- StatusView
--
CREATE function [dbo].[StatusView] (@ReadWrite varchar(5), @PermIDs varchar(MAX), @WhichLob int)
returns table
as
return (
                Select distinct someview.CSID as id,someview.descrip , SomeView.Status_type_id, SomeView.[Rank] /*,CSR.Access as Access*/ from
                                (
                                                select
                                                                cs.id as CSID,
                                                                ug.id as UGID,
                                                                cs.Status_type_id,
                                                                cs.descrip,
                                                                ug.permissionName,
                                                                cs.[Rank]
                                                from
                                                                contact_status cs,
                                                                [Permissions] ug JOIN
                                                                intList(@PermIDs) i ON ug.ID = i.number
                                                Where
                                                                cs.Available = 1
                                                                AND
                                                                cs.Renewal_Status_ID = 0
                                                                AND
                                                                (
                                                                OnlyForLob is null OR
                                                                OnlyForLob = @WhichLob
                                                                )
                                ) someView left outer join
                                Contact_Status_Roles csr
                                                on
                                                                csr.group_id = SomeView.UGID
                                                                AND
                                                                csr.Status_id = SomeView.CSID
                WHERE
                                                                                (
                                                                                                (@ReadWrite = 'READ'  AND (Access=1 OR Access=3))
                                                                                                OR
                                                                                                (@ReadWrite = 'WRITE' AND (Access=2 OR Access=3))
                                                                                                OR
                                                                                                (@ReadWrite = 'BOTH'  AND access=3) 
                                                                                )
																				
)
GO
