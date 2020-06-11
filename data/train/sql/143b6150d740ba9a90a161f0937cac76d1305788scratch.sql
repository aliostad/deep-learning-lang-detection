select top 4 * from crawlerDb.dbo.crawlLog
order by timestamp desc

select * from crawlStats
order by crawlID desc
 
select crawlid, count(1) as missingImages from missingImageDump
group by crawlID
order by crawlid desc


select crawlid, count(1) as missingImages from missingImageDump
group by crawlID
order by crawlid desc

select crawlid, count(1) as missingImages from missingImageManifest
group by crawlID
order by crawlid desc

--delete from missingImageManifest


SELECT Url, ProductId, Dept, Type, ImageName, Nav_From, Color FROM crawlerDB.dbo.missingImageManifest WHERE crawlID = 12"SELECT Url, ProductId, Dept, Type, ImageName, Nav_From, Color FROM crawlerDB.dbo.missingImageManifest WHERE crawlID = 12"

select * from missingImageManifest order by crawlID desc
--select * from missingImageDump where crawlid = (select max(crawlid) from crawlids)

SELECT Url, ProductId, Dept, Type, ImageName, Nav_From, Color FROM crawlerDB.dbo.missingImageManifest 








SELECT Url, ProductId, Dept, Type, ImageName, Nav_From, Color FROM crawlerDB.dbo.missingImageManifest WHERE crawlID = 12