USE [UVAQ]
GO

/****** Object:  View [bvt_prod].[Combined_New_Best_View_VW]    Script Date: 02/22/2016 13:36:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







ALTER View [bvt_prod].[Combined_New_Best_View_VW]

AS 
Select * from (

Select idFlight_Plan_Records_FK, InHome_Date, Media_Year, Media_Week, Media_Month, Program_Name, a.Media, KPI_Type, Product_Code,
Touch_Name, New_Program, b.Audience as New_Audience, CCF_Category,CCF_Sub_Category, CCF_Description, (b.Audience+' '+Convert(Varchar(10),CCF_Category)+' '+CCF_Description+ CASE WHEN CCF_Sub_Category is not null then (' '+CCF_Sub_Category) ELSE '' END) as New_Touch_Name,
(Forecast*Coalesce(New_percent,1)) as New_Forecast, (Commitment*Coalesce(New_percent,1)) as New_Commitment 
from bvt_Prod.UVLB_Best_View_VW a
LEFT JOIN bvt_processed.UVLB_Audience_Transition b
on a.Touch_Name = b.Old_Touch_Name
Where Media_Year >=2016
and (Forecast <> 0 OR Commitment <> 0)

UNION ALL

Select idFlight_Plan_Records_FK, InHome_Date, Media_Year, Media_Week, Media_Month, Program_Name, c.Media, KPI_Type, Product_Code,
Touch_Name, New_Program, d.Audience as New_Audience ,CCF_Category, CCF_Sub_Category, CCF_Description,(d.Audience+' '+Convert(Varchar(10),CCF_Category)+' '+CCF_Description+ CASE WHEN CCF_Sub_Category is not null then (' '+CCF_Sub_Category) ELSE '' END) as New_Touch_Name,
(Forecast*Coalesce(New_percent,1)) as New_Forecast, (Commitment*Coalesce(New_percent,1)) as New_Commitment 
from bvt_Prod.VALB_Best_View_VW c
LEFT JOIN bvt_processed.VALB_Audience_Transition d
on c.Touch_Name = d.Old_Touch_Name
Where Media_Year >=2016
and (Forecast <> 0 OR Commitment <> 0)) z





GO


