/* PLEASE NOTE, 
1) To use this script, grant select on pc_class_tree to NAV_AS_*; was run from the CBPS
2) Needed to insert a top row representing the root node.  This data only exists on CBSS.
3) Renamed "Root Node" to "Show ALL" to allow interactivity with bar chart.  
	Need a more elegant solution.
*/

select t.node_id, 
	t.node_name, 
	t.parent_id, 
	avg(d.q02_osat) as OSAT, 
avg(s.d_sentiment_score) as Sentiment_Score,
	count(distinct d.document_id) as Total_Documents
from psv_document d
join psv_sentence s 
	on d.document_id = s.document_id
join psv_sentence_class_xref x 
  	on s.sentence_id = x.sentence_id
join nav_ps_cisco_surveys.pc_class_tree t on x.node_id = t.node_id
where d.q02_osat is not null
and t.id_model = 1914779
and t.node_id > 0
group by t.node_id, 
	t.node_name, 
	t.parent_id;