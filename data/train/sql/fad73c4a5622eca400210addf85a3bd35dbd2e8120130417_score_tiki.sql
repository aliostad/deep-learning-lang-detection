INSERT INTO tiki_score (event, score, expiration) VALUES ('forum_topic_post',10,0);
INSERT INTO tiki_score (event, score, expiration) VALUES ('forum_topic_reply',5,0);
INSERT INTO tiki_score (event, score, expiration) VALUES ('forum_post_read',1,0);
INSERT INTO tiki_score (event,score,expiration) VALUES ('forum_post_is_read',2,0);

INSERT INTO tiki_score (event, score, expiration) VALUES ('trackeritem_create',10,0);
INSERT INTO tiki_score (event, score, expiration) VALUES ('trackeritem_edit',5,0);
INSERT INTO tiki_score (event, score, expiration) VALUES ('trackeritem_read',1,0);
INSERT INTO tiki_score (event,score,expiration) VALUES ('trackeritem_is_read',2,0);
INSERT INTO tiki_score (event, score, expiration) VALUES ('tracker_field_entered',10,0);

INSERT INTO tiki_score (event, score, expiration) VALUES ('item_favorited',1,0);
INSERT INTO tiki_score (event, score, expiration) VALUES ('item_is_favorited',10,0);
INSERT INTO tiki_score (event,score,expiration) VALUES ('item_is_rated',10,0);
INSERT INTO tiki_score (event, score, expiration) VALUES ('item_is_unrated',-10,0);
INSERT INTO tiki_score (event, score, expiration) VALUES ('avatar_added',10,0);
