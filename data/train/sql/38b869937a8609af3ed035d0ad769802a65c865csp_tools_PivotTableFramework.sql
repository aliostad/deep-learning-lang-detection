CREATE proc [dbo].[PivotTableFramework]
/*

Exec PivotTableFramework 
'(SELECT ListPKID,DataName,Value FROM dbo.DC_Detail where ProjectPKID=1 and validFlag=1) Tmp',
'',
'listPKID',
'DataName',
'Value',
0,
0,
0

*/
@TableName varchar(4000), --表名
@AppendColumn varchar(200),
@縱軸 sysname,  --交叉表最左面的列
@橫軸 sysname,  --交叉表最上面的列
@表體內容 sysname, --交叉表的數資料欄位
@是否加橫向合計 bit,--為1時在交叉表橫向最右邊加橫向合計
@是否加縱向合計 bit, --為1時在交叉表縱向最下邊加縱向合計
@表體內容是數值類型 bit 
as

declare @s nvarchar(4000),@sql nvarchar(4000)
--判斷橫向欄位是否大於縱向欄位數目,如果是,則交換縱橫欄位
set @s='Declare @a sysname 
        If(Select case 
                       when count(distinct ['+@縱軸+'])<count(distinct ['+@橫軸+']) 
                       then 1 
                       else 0 
                  end
           From '+@TableName+')=1 
        Select @a=@縱軸,@縱軸=@橫軸,@橫軸=@a'


--下面這句是交換處理部分，若屏蔽則無交換功能
--exec sp_executesql @s ,N'@縱軸 sysname out,@橫軸 sysname out' ,@縱軸 out,@橫軸 out

--生成交叉表處理語句
if @表體內容是數值類型=1
        set @s='set @s='''' 
                select @s=@s+'',[''+cast(['+@橫軸+'] as varchar)+'']=sum(case ['+@橫軸 +'] 
                                                                              when  '''''' +cast(['+@橫軸+'] as varchar)+'''''' 
                                                                              then ['+@表體內容+'] 
                                                                              else 0 
                                                                         end)'' 
                from '+@TableName+' 
                group by ['+@橫軸+']'
else
        set @s='set @s='''' 
                select @s=@s+'',[''+cast(['+@橫軸+'] as varchar)+'']=Max(case ['+@橫軸 +'] 
                                                                              when  '''''' +cast(['+@橫軸+'] as varchar)+'''''' 
                                                                              then ['+@表體內容+'] 
                                                                              else ''''''''
                                                                         end)'' 
                from '+@TableName+' 
                group by ['+@橫軸+']'
        
        
exec sp_executesql @s ,N'@s varchar(8000) out ' ,@sql out

--是否生成合計欄位的處理
declare @sum1 varchar(200),@sum2 varchar(200),@sum3 varchar(200)
select @sum1=case @是否加橫向合計  
                  when 1 then ',[合計]=sum(['+@表體內容+'])' 
                  else '' 
             end ,
       @sum2=case @是否加縱向合計  
                  when 1 then '['+@縱軸+']=Case Grouping([' +@縱軸+']) 
                                                when 1 then ''合計'' 
                                                Else cast([' +@縱軸+'] as varchar) 
                                           End'  
                  else '['+@縱軸+']' +char(13)+char(9)+char(9)
             end ,
       @sum3=case @是否加縱向合計  
                  when 1 then ' with rollup'  
                  else '' 
             end

Declare @AppendColumnSQL nvarchar(400)
if @AppendColumn<>''
    Set @AppendColumnSQL=@AppendColumn+','
else
    Set @AppendColumnSQL=''
    
--生成交叉表
Declare @SqlText varchar(8000)
Set @SqlText='Select '+@AppendColumnSQL+@sum2+@sql+@sum1 +' ' +
             'From '+@TableName + ' ' +
             'Group By '+@AppendColumnSQL+'['+@縱軸+']'+@sum3

Print(@SqlText)
exec(@SqlText)

GO

