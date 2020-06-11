
/*@export on
go

@export set Filename = "C:\Documents and Settings\fmab\Desktop\CIS\JP_NeueDatenImSternschema.html" format = "html" AppendFile = "clear"
go
*/

-- Anzahl neue Daten im Sternschema "VA-JP Fallbuchhaltung"
DECLARE @altstartdate datetime

SET @altstartdate = Getdate() -3
SELECT (DATEPART(day,ZF2072)) [Tag], ( DATEPART(month,ZF2072)) [Monat], ( DATEPART(year,ZF2072)) [Jahr], count (*) [JP_Fallbuchhaltung_Neu]
FROM 
    cis.dbo.DW2072
where ZF2072 > @altstartdate
group  by (DATEPART(day,ZF2072)), ( DATEPART(month,ZF2072)), ( DATEPART(year,ZF2072)) 
order by (DATEPART(year,ZF2072)) , (DATEPART(day,ZF2072)), ( DATEPART(month,ZF2072))  desc
 --go



-- Anzahl neue Daten im Sternschema "VA-JP Verarbeitungsstand"
DECLARE @altstartdate datetime

SET @altstartdate = Getdate() -3
SELECT (DATEPART(day,ZF2076)) [Tag], ( DATEPART(month,ZF2076)) [Monat], ( DATEPART(year,ZF2076)) [Jahr], count (*) [JP_Verarbeitungsstand_Neu]
FROM 
    cis.dbo.DW2076
where ZF2076 > @altstartdate
group  by (DATEPART(day,ZF2076)), ( DATEPART(month,ZF2076)), ( DATEPART(year,ZF2076)) 
order by (DATEPART(year,ZF2076)) , (DATEPART(day,ZF2076)), ( DATEPART(month,ZF2076))  desc

/*   go

@export off
go
@exit nocheck