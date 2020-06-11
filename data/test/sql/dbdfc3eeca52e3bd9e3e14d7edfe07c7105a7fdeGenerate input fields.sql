USE muziekdatabase;
GO

--<div class=''control-group''>
--	<label for=''speelduur'' class=''control-label''><span class=''tipleft'' title=''integer''>speelduur</span></label>
--	<div class=''controls''>
--		<div class="input-append">
--			<input class=''integer'' type=''text'' id=''input_speelduur'' name=''speelduur'' value='''' style="width:174px;" class=''hasnull''/>
--			<span class="add-on"><input class=''null tiptop'' title=''NULL'' type="checkbox" name="null_speelduur" checked=''true''></span>
--		</div>
--	</div>
--</div>

--<div class=''control-group''>
--	<label for=''jaartal'' class=''control-label''><span class=''tipleft'' title=''integer''>jaartal</span></label>
--	<div class=''controls''>
--		<input class=''integer'' type=''text'' id=''input_jaartal'' name=''jaartal'' value=''''/>
--	</div>
--</div>

DECLARE @HTML NVARCHAR(MAX) = '''';
SELECT 
''<div class=''''control-group''''>
<label for='''''' + c.Column_Name + '''''' class=''''control-label''''><span class=''''tipleft'''' title='''''' + c.Data_Type + ''''''>'' + c.Column_Name + ''</span></label>
<div class=''''controls''''>'' + CHAR(10) + 
CASE c.IS_NULLable WHEN ''YES'' 
THEN ''<div class="input-append">
<input class='''''' + c.Data_Type + '''''' type=''''text'''' name='''''' + c.Column_Name + '''''' value='''''''' style="width:174px;" class=''''hasnull''''/>
<span class="addon-on"><input class=''''null tiptop'''' title=''''NULL'''' type="checkbox" name="null_'' + c.Column_Name + ''" checked=''''true''''/></span>
</div>'' + CHAR(10)
ELSE ''<input class='''''' + c.Data_Type + '''''' type=''''text'''' name='''''' + c.Column_Name + '''''' value='''''''' />'' + CHAR(10) END +
''</div>'' + CHAR(10) + ''</div>'' + CHAR(10)
FROM Notillia.Columns c
WHERE c.[Schema] = ''dbo'' AND c.[Database] = ''muziekdatabase'' AND c.Table_Name = ''stuk''
PRINT @HTML;