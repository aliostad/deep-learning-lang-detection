SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [Profile.Data].[vwPerson]
as
		SELECT p.personid,
					 p.userid,
					 p.internalusername,
					 p.firstname,
					 p.lastname,
					 p.displayname, 
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN p.addressline1 END addressline1,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN p.addressline2 END addressline2,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN p.addressline3 END addressline3,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN p.addressline4 END addressline4,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN p.addressstring END addressstring, 
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN  p.building END building,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN  p.room END room,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN  p.floor END floor, 
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN  p.latitude END latitude, 
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN  p.longitude END longitude,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN p.phone END phone,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN p.fax END fax,  
					 CASE WHEN ISNULL(dp.ShowEmail,'Y') = 'Y' THEN p.emailaddr END emailaddr,
					 i2.institutionname,
					 i2.institutionabbreviation, 
					 de.departmentname,
					 dv.divisionname,  
					 A.facultyrank, 
					 A.facultyranksort, 
					 p.isactive,
					 ISNULL(dp.ShowAddress,'Y')ShowAddress,
					 ISNULL(dp.ShowPhone,'Y')ShowPhone,
					 ISNULL(dp.Showfax,'Y')Showfax,
					 ISNULL(dp.ShowEmail,'Y')ShowEmail,
					 ISNULL(dp.ShowPhoto,'N')ShowPhoto,
					 ISNULL(dp.ShowAwards,'N')ShowAwards,
					 ISNULL(dp.ShowNarrative,'N')ShowNarrative,
					 ISNULL(dp.ShowPublications,'Y')ShowPublications, 
					 ISNULL(p.visible,1)visible,
					 0 numpublications
			FROM [Profile.Data].Person p
 LEFT JOIN [Profile.Cache].Person ps				 ON ps.personid = p.personid
 LEFT JOIN [Profile.Data].[Person.Affiliation] pa				 ON pa.personid = p.personid
																				AND pa.isprimary=1 
 LEFT JOIN [Profile.Data].[Organization.Institution] i2				 ON pa.institutionid = i2.institutionid 
 LEFT JOIN [Profile.Data].[Organization.Department] de				 ON de.departmentid = pa.departmentid
 LEFT JOIN [Profile.Data].[Organization.Division] dv				 ON dv.divisionid = pa.divisionid
 LEFT JOIN [Profile.Import].[Beta.DisplayPreference] dp on dp.PersonID=p.PersonID 
 OUTER APPLY(SELECT TOP 1 facultyrank ,facultyranksort from [Profile.Data].[Person.Affiliation] pa JOIN [Profile.Data].[Person.FacultyRank] fr on fr.facultyrankid = pa.facultyrankid  where personid = p.personid order by facultyranksort asc)a
 WHERE p.isactive = 1
GO
