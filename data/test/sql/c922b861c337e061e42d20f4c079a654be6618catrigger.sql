use jwc;

DELIMITER //

DROP TRIGGER IF EXISTS jwc_update_user;//
CREATE TRIGGER jwc_update_user AFTER UPDATE ON xhome_jwc_user
FOR EACH ROW BEGIN
    IF old.id!=new.id OR old.status!=new.status THEN
        UPDATE xhome_jwc_user_group AS ug
            SET ug.uid=new.id,
                ug.modifier=new.modifier,
                ug.modified=new.modified,
                ug.status=new.status
        WHERE ug.uid=old.id AND ug.status=old.status;
        UPDATE xhome_jwc_user_tag AS ut
            SET ut.uid=new.id,
                ut.modifier=new.modifier,
                ut.modified=new.modified,
                ut.status=new.status
        WHERE ut.uid=old.id AND ut.status=old.status;
        UPDATE xhome_jwc_mailbox AS m
            SET m.modified=new.modified,
                m.status=new.status
        WHERE m.owner=old.id AND m.status=old.status;
    END IF;
END;//

DROP TRIGGER IF EXISTS jwc_update_group;//
CREATE TRIGGER jwc_update_group AFTER UPDATE ON xhome_jwc_group
FOR EACH ROW BEGIN
    IF old.id!=new.id OR old.status!=new.status THEN
        UPDATE xhome_jwc_user_group AS ug
            SET ug.gid=new.id,
                ug.modifier=new.modifier,
                ug.modified=new.modified,
                ug.status=new.status
        WHERE ug.gid=old.id AND ug.status=old.status;
        UPDATE xhome_jwc_user_tag AS ut
            SET ut.tid=new.id,
                ut.modifier=new.modifier,
                ut.modified=new.modified,
                ut.status=new.status
        WHERE ut.tid=old.id AND ut.status=old.status;
    END IF;
END;//

DROP TRIGGER IF EXISTS jwc_update_part;//
CREATE TRIGGER jwc_update_part AFTER UPDATE ON xhome_jwc_part
FOR EACH ROW BEGIN
    IF old.id!=new.id OR old.status!=new.status THEN
        UPDATE xhome_jwc_news_part AS np
            SET np.part=new.id,
                np.modifier=new.modifier,
                np.modified=new.modified,
                np.status=new.status
        WHERE np.part=old.id AND np.status=old.status;
        UPDATE xhome_jwc_part_parent AS pp
            SET pp.part=new.id,
                pp.modifier=new.modifier,
                pp.modified=new.modified,
                pp.status=new.status
        WHERE pp.part=old.id AND pp.status=old.status;
        UPDATE xhome_jwc_part_parent AS pp
            SET pp.parent=new.id,
                pp.modifier=new.modifier,
                pp.modified=new.modified,
                pp.status=new.status
        WHERE pp.parent=old.id AND pp.status=old.status;
    END IF;
END;//

DROP TRIGGER IF EXISTS jwc_insert_part;//
CREATE TRIGGER jwc_insert_part AFTER INSERT ON xhome_jwc_part
FOR EACH ROW BEGIN
    DECLARE pid INTEGER DEFAULT NULL;
    IF new.parent IS NOT NULL THEN
        INSERT INTO xhome_jwc_part_parent (part, parent, owner, modifier, created, modified, status)
            VALUES (new.id, new.parent, new.owner, new.modifier, new.created, new.modified, new.status);
        SET pid = (SELECT parent FROM xhome_jwc_part WHERE id = new.parent);
        WHILE pid IS NOT NULL DO
            INSERT INTO xhome_jwc_part_parent (part, parent, owner, modifier, created, modified, status)
                VALUES (new.id, pid, new.owner, new.modifier, new.created, new.modified, new.status);
            SET pid = (SELECT parent FROM xhome_jwc_part WHERE id = pid);
        END WHILE;
    END IF;
END;//

DROP TRIGGER IF EXISTS jwc_update_news;//
CREATE TRIGGER jwc_update_news AFTER UPDATE ON xhome_jwc_news
FOR EACH ROW BEGIN
    IF old.id!=new.id OR old.status!=new.status THEN
        UPDATE xhome_jwc_attachment AS a
            SET a.belong=new.id,
                a.modifier=new.modifier,
                a.modified=new.modified,
                a.status=new.status
        WHERE a.belong=old.id AND a.status=old.status AND a.species=1;
        UPDATE xhome_jwc_news_part AS np
            SET np.news=new.id,
                np.modifier=new.modifier,
                np.modified=new.modified,
                np.status=new.status
            WHERE np.news=old.id AND np.status=old.status;
    END IF;
END;//

DROP TRIGGER IF EXISTS jwc_delete_news;//
CREATE TRIGGER jwc_delete_news AFTER DELETE ON xhome_jwc_news
FOR EACH ROW BEGIN
    DELETE FROM xhome_jwc_attachment WHERE belong=old.id AND status=old.status AND species=1;
END;//

DROP TRIGGER IF EXISTS jwc_update_category;//
CREATE TRIGGER jwc_update_category AFTER UPDATE ON xhome_jwc_category
FOR EACH ROW BEGIN
    IF old.id!=new.id OR old.status!=new.status THEN
        UPDATE xhome_jwc_link AS l
            SET l.category=new.id,
                l.modifier=new.modifier,
                l.modified=new.modified,
                l.status=new.status
        WHERE l.category=old.id AND l.status=old.status;
    END IF;
END;//

DROP TRIGGER IF EXISTS jwc_update_mailbox;//
CREATE TRIGGER jwc_update_mailbox AFTER UPDATE ON xhome_jwc_mailbox
FOR EACH ROW BEGIN
    IF old.id!=new.id OR old.status!=new.status THEN
        UPDATE xhome_jwc_attachment AS a
            SET a.belong=new.id,
                a.modifier=new.modifier,
                a.modified=new.modified,
                a.status=new.status
        WHERE a.belong=old.id AND a.status=old.status AND a.species=2;
    END IF;
    IF (SELECT COUNT(id) FROM xhome_jwc_mailbox WHERE status!=5)=0 THEN
        UPDATE xhome_jwc_sms AS s
            SET s.modified=new.modified,
                s.status=5
        WHERE s.id=old.sms;
    END IF;
END;//

DROP TRIGGER IF EXISTS jwc_delete_mailbox;//
CREATE TRIGGER jwc_delete_mailbox AFTER DELETE ON xhome_jwc_mailbox
FOR EACH ROW BEGIN
    DELETE FROM xhome_jwc_attachment WHERE belong=old.id AND status=old.status AND species=2;
    IF (SELECT COUNT(id) FROM xhome_jwc_mailbox WHERE status!=5)=0 THEN
        DELETE FROM xhome_jwc_sms WHERE id=old.sms;
    END IF;
END;//

DELIMITER ;
