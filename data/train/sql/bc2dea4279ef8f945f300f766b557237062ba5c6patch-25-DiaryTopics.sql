UPDATE stories SET tid='diary' WHERE section='Diary' and tid like 'diary_%';

DELETE FROM vars WHERE name = 'ads_in_everything_sec';
DELETE FROM vars WHERE name = 'sections_excluded_from_all' and (value = '' OR value IS NULL);

INSERT IGNORE INTO vars VALUES ('sections_excluded_from_all','Diary, advertisements','<P>This variable determines which sections will not be shown in the \"Everything\" pseudo-section or the RDF feed.  The possible values are a comma-separated list of section names.  The default list contains the Diary and adverts sections.</p>','text','Stories');
INSERT IGNORE INTO vars VALUES ('story_nav_bar_sections','Diary, advertisements','<P>Contains a comma separated list of sections.<br>This controls what stories are shown in the Next and Previous story positions if the story nav bar is shown (see the disable_story_navbar control)<br>When the story is displayed, if it is in one of the sections listed, only stories from the same section as the current story will be shown in the nav bar. IE. If a Diary story is displayed, then only another Diary story will be shown in the nav bar.<br>If the current story is not from one of the sections listed, then only stories that are not in the sections listed will be displayed. IE. If a story from the News section is displayed, then only stories from any section apart from diaries or adverts will be shown in the nav bar.</p>','text','Stories');
INSERT IGNORE INTO vars VALUES ('diary_topics','0','If this var is set, then users may select a different topic for their diaries.<p>\r\nThe default topic is \"Diary\".','text','Stories');

