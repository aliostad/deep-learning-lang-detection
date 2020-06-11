/*
 * Index update triggers
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 */

DELIMITER ;;

REPLACE INTO search_class (name, data_table, primary_key, columns) VALUES
    ('article',        'article', 'article_id', 'title,author,body'),
    ('article.title',  'article', 'article_id', 'title'),
    ('article.author', 'article', 'article_id', 'author'),
    ('article.body',   'article', 'article_id', 'body');

DROP TRIGGER IF EXISTS tr_AU_index_article;;
CREATE TRIGGER tr_AU_index_article
    AFTER UPDATE ON article
    FOR EACH ROW BEGIN
        CALL indexString(NEW.article_id, CONCAT_WS(' ',NEW.title,NEW.author,NEW.body), classID('article'));
        CALL indexString(NEW.article_id, NEW.title, classID('article.title'));
        CALL indexString(NEW.article_id, NEW.author, classID('article.author'));
        CALL indexString(NEW.article_id, NEW.body, classID('article.body'));
    END;
;;

DROP TRIGGER IF EXISTS tr_AI_index_article;;
CREATE TRIGGER tr_AI_index_article
    AFTER INSERT ON article
    FOR EACH ROW BEGIN
        CALL indexString(NEW.article_id, CONCAT_WS(' ',NEW.title,NEW.author,NEW.body), classID('article'));
        CALL indexString(NEW.article_id, NEW.title, classID('article.title'));
        CALL indexString(NEW.article_id, NEW.author, classID('article.author'));
        CALL indexString(NEW.article_id, NEW.body, classID('article.body'));
    END;
;;

DROP TRIGGER IF EXISTS tr_BD_index_article;;
CREATE TRIGGER tr_BD_index_article
    BEFORE DELETE ON article
    FOR EACH ROW BEGIN
        DELETE FROM search_index WHERE id = OLD.article_id AND search_class_id = classID('article');
        DELETE FROM search_index WHERE id = OLD.article_id AND search_class_id = classID('article.title');
        DELETE FROM search_index WHERE id = OLD.article_id AND search_class_id = classID('article.author');
        DELETE FROM search_index WHERE id = OLD.article_id AND search_class_id = classID('article.body');
    END;
;;

DELIMITER ;