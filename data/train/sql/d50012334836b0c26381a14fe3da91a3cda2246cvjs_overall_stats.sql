SELECT

count(*) as total_inquiries,
sum(replied) inquiry_replied,
sum(no_reply) inquiry_no_reply,
sum(no_reply_not_read) inquiry_no_reply_not_read,
sum(no_reply_read) inquiry_no_reply_read,
sum(messages) as total_messages,
round(sum(messages)/count(*),2) avg_mess_per_inquiry,
jobs

FROM
(
		SELECT 
		i.id as inquiry_id,
		count(*) messages,
		count(distinct to_user_id) users,
		(CASE WHEN count(distinct to_user_id) = 1 then 1 else 0 end) no_reply,
		(CASE WHEN count(distinct to_user_id) = 2 then 1 else 0 end) replied,
		(CASE WHEN count(distinct to_user_id) = 1 and max(readAt) is null then 1 else 0 end) no_reply_not_read,
		(CASE WHEN count(distinct to_user_id) = 1 and max(readAt) is not null then 1 else 0 end) no_reply_read

		FROM realign_vjs.inquiries i
		left join realign_vjs.user vu on i.userProfile_id=vu.profile_id
		INNER JOIN Reporting_chamber.chamber_users cu on cu.uuid=vu.uuid
		left join realign_vjs.private_messages pm on i.id=pm.inquiry_id
		where date(pm.createdAt) >= '2014-08-01'

GROUP BY i.id
) ipm

CROSS JOIN

(
		SELECT 

		count(*) as jobs

		FROM realign_vjs.jobs vj
		LEFT JOIN realign_vjs.user vu on vj.created_by=vu.id
		INNER JOIN Reporting_chamber.chamber_users u on vu.uuid=u.uuid

		WHERE DATE(vj.created_at) IS NOT NULL
) jobs