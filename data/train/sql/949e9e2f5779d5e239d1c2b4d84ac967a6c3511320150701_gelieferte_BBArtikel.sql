with BB_Auftraege as
(
	select ncsh.[External Document No_] as extDocNo
			,ncsh.[Order Date] as Datum
			, ncsl.[Line No_] as line_no
			, ncsl.No_ as No_
			,ncsh.[Status] as Status
				from Urban_Nav600_SL.dbo.[Urban-Brand GmbH$eBayNavCSalesHeader] ncsh with (nolock)
	join Urban_Nav600_SL.dbo.[Urban-Brand GmbH$eBayNavCSalesLine] ncsl with (nolock)
			on ncsl.[Document No_] = ncsh.No_
	where Urban_Nav600_SL.dbo.RegExisMatch('.*BB', ncsl.No_, 0) = 1
		and ncsh.[Order Date] > '2015-06-01'
		
),

Auftraege_ohne_BB as

(
	select ncsh.[External Document No_] as extDocNo
		, ncsl.[Line No_] as line_no
		, ncsl.No_
	from Urban_Nav600_SL.dbo.[Urban-Brand GmbH$eBayNavCSalesHeader] ncsh with (nolock)
	join Urban_Nav600_SL.dbo.[Urban-Brand GmbH$eBayNavCSalesLine] ncsl with (nolock)
			on ncsl.[Document No_] = ncsh.No_
	join BB_Auftraege
		on BB_Auftraege.extDocNo = ncsh.[External Document No_]
	-- 		where Urban_Nav600_SL.dbo.RegExisMatch('.*BB', ncsl.No_, 0) = 1
	where ncsh.[Order Date] >= '2015-06-01'
)
, data as 
(
select	Auftraege_ohne_BB.extDocNo
		, Auftraege_ohne_BB.line_no
		, Auftraege_ohne_BB.No_
		, BB_Auftraege.No_ as BB_no
from Auftraege_ohne_BB
full outer join BB_Auftraege
	on BB_Auftraege.extDocNo = Auftraege_ohne_BB.extDocNo
		and BB_Auftraege.line_no = Auftraege_ohne_BB.line_no
where BB_Auftraege.No_ is null
)

select 
data.extDocNo
,count(data.extDocNo) as Anzahl from data
join BB_Auftraege
	on BB_Auftraege.extDocNo = data.extDocNo
and BB_Auftraege.No_ = data.No_ + '-BB'
group by data.extDocNo

