SELECT 
  "view_StudentsWhoCompleted".student, 
  "view_StudentsWhoCompleted".course, 
  "view_StudentsWhoCompleted".is_complete, 
  cast(count(tbl_clicks.event_type)as float)/(cast(sum(tbl_videos.video_seconds)/60 as float)) as Clicks_per_Minute
FROM 
  public."view_StudentsWhoCompleted", 
  public.tbl_clicks,
  public.tbl_videos
WHERE 
  "view_StudentsWhoCompleted".student = tbl_clicks.student AND
  "view_StudentsWhoCompleted".course = tbl_clicks.course AND
  tbl_clicks.youtube_id = tbl_videos.youtubeid AND
  "view_StudentsWhoCompleted".student <> ''
GROUP BY
  "view_StudentsWhoCompleted".student, 
  "view_StudentsWhoCompleted".course, 
  "view_StudentsWhoCompleted".is_complete
ORDER BY
  course, student