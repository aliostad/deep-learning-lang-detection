delete from [archives_new].[dbo].doctemplate where templatename in (
'赴港工作同意书',
'博士后进站表格签章',
'招行调查表签章',
'留学人员回京报到登记表签章',
'限购房表格签章',
'报考博士表格签章',
'复印成绩单',
'其它：供手工录入特殊证明'
)

INSERT INTO [archives_new].[dbo].[doctemplate]([templatename],[templatefile],[taoda],[classid]) VALUES('赴港工作同意书','赴港工作同意书.pdf',0,1)
INSERT INTO [archives_new].[dbo].[doctemplate]([templatename],[templatefile],[taoda],[classid]) VALUES('博士后进站表格签章','博士后进站表格签章.pdf',0,1)
INSERT INTO [archives_new].[dbo].[doctemplate]([templatename],[templatefile],[taoda],[classid]) VALUES('招行调查表签章','招行调查表签章.pdf',0,1)
INSERT INTO [archives_new].[dbo].[doctemplate]([templatename],[templatefile],[taoda],[classid]) VALUES('留学人员回京报到登记表签章','留学人员回京报到登记表签章.pdf',0,1)
INSERT INTO [archives_new].[dbo].[doctemplate]([templatename],[templatefile],[taoda],[classid]) VALUES('限购房表格签章','限购房表格签章.pdf',0,1)
INSERT INTO [archives_new].[dbo].[doctemplate]([templatename],[templatefile],[taoda],[classid]) VALUES('报考博士表格签章','报考博士表格签章.pdf',0,1)
INSERT INTO [archives_new].[dbo].[doctemplate]([templatename],[templatefile],[taoda],[classid]) VALUES('复印成绩单','复印成绩单.pdf',0,1)
INSERT INTO [archives_new].[dbo].[doctemplate]([templatename],[templatefile],[taoda],[classid]) VALUES('其它：供手工录入特殊证明','其它：供手工录入特殊证明.pdf',0,1)




select * from [archives_new].[dbo].doctemplate