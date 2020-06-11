SET @sns_item = 1103793950;
SET @sns_id = 2;

    SELECT  -- FROM_UNIXTIME(paydb.sns_profiles.date_create) as date_create,
            snsdb_new.content_types.`id` as type_id,
            snsdb_new.content.sns_item_id_1,
            snsdb_new.content.sns_item_id_0,
            -- snsdb_new.content.to_sns_item_id,
            -- snsdb_new.content_types.`name` as type_name,
            snsdb_new.content.shares
            -- ,snsdb_new.content.`from`
            ,snsdb_new.content.date
    FROM
        snsdb_new.`content`
        INNER JOIN snsdb_new.content_types on snsdb_new.content_types.id = snsdb_new.content.type_id
        INNER JOIN paydb.sns_profiles on paydb.sns_profiles.sns_id = snsdb_new.content.sns_id AND paydb.sns_profiles.sns_profile_id = snsdb_new.content.sns_item_id_0
    WHERE
        snsdb_new.content.sns_item_id_0 = @sns_item
        AND snsdb_new.content.sns_id = @sns_id
        AND (content.date <= FROM_UNIXTIME(paydb.sns_profiles.date_create) OR content.date IS NULL)
    GROUP BY
        snsdb_new.content.id
    ORDER BY
        date DESC
    LIMIT 200;



-- 22222222222222
    SELECT  -- FROM_UNIXTIME(paydb.sns_profiles.date_create) as date_create,
            -- snsdb_new.content_types.`id` as type_id,
            snsdb_new.content.sns_item_id_1,
            -- snsdb_new.content.sns_item_id_0,
            -- snsdb_new.content.to_sns_item_id,
            -- snsdb_new.content_types.`name` as type_name,
            COUNT(snsdb_new.likes.id) as cnt_likes_all
            -- ,snsdb_new.content.shares
            -- ,snsdb_new.content.`from`
            -- ,snsdb_new.content.date
    FROM
        snsdb_new.`content`
        INNER JOIN snsdb_new.content_types on snsdb_new.content_types.id = snsdb_new.content.type_id
        INNER JOIN paydb.sns_profiles on paydb.sns_profiles.sns_id = snsdb_new.content.sns_id AND paydb.sns_profiles.sns_profile_id = snsdb_new.content.sns_item_id_0
        INNER JOIN (SELECT * FROM snsdb_new.likes WHERE snsdb_new.likes.sns_object_id_0 = @sns_item LIMIT 200000) as likes on content.sns_item_id_1 = likes.sns_object_id_1
     -- INNER JOIN snsdb_new.likes on snsdb_new.content.sns_item_id_1 = snsdb_new.likes.sns_object_id_1 --  NOT OPTIMIZED
    WHERE
        snsdb_new.content.sns_item_id_0 = @sns_item
        AND snsdb_new.content.sns_id = @sns_id
        AND (content.date <= FROM_UNIXTIME(paydb.sns_profiles.date_create) OR content.date IS NULL)
    GROUP BY
        snsdb_new.content.id
    ORDER BY
        date DESC
    LIMIT 200;

-- 3333333333333
    SELECT  snsdb_new.content.sns_item_id_1,
            -- snsdb_new.content.sns_item_id_0,
            COUNT(snsdb_new.likes.id) as cnt_likes_self
            -- ,snsdb_new.content.date
    FROM
        snsdb_new.`content`
        INNER JOIN snsdb_new.content_types on snsdb_new.content_types.id = snsdb_new.content.type_id
        INNER JOIN paydb.sns_profiles on paydb.sns_profiles.sns_id = snsdb_new.content.sns_id AND paydb.sns_profiles.sns_profile_id = snsdb_new.content.sns_item_id_0
        -- INNER JOIN snsdb_new.likes on snsdb_new.content.sns_item_id_1 = snsdb_new.likes.sns_object_id_0 --  NOT OPTIMIZED
        INNER JOIN (SELECT * FROM snsdb_new.likes WHERE snsdb_new.likes.sns_profile_id = @sns_item LIMIT 200000) as likes on content.sns_item_id_1 = likes.sns_object_id_1

    WHERE
        snsdb_new.content.sns_item_id_0 = @sns_item
        AND snsdb_new.content.sns_id = @sns_id
        AND (content.date <= FROM_UNIXTIME(paydb.sns_profiles.date_create) OR content.date IS NULL)
        AND snsdb_new.likes.sns_object_id_0 = @sns_item

    GROUP BY
        snsdb_new.content.id
    ORDER BY
        date DESC
    LIMIT 200;

-- 44444444444
    SELECT  snsdb_new.content.sns_item_id_1,
            -- snsdb_new.content.sns_item_id_0,
            COUNT(snsdb_new.likes.id) as cnt_likes_friends
            -- ,snsdb_new.content.date
    FROM
        snsdb_new.`content`
        INNER JOIN snsdb_new.content_types on snsdb_new.content_types.id = snsdb_new.content.type_id
        INNER JOIN paydb.sns_profiles on paydb.sns_profiles.sns_id = snsdb_new.content.sns_id AND paydb.sns_profiles.sns_profile_id = snsdb_new.content.sns_item_id_0
        INNER JOIN (SELECT * FROM snsdb_new.likes WHERE snsdb_new.likes.sns_object_id_0 = @sns_item LIMIT 200000) as likes on content.sns_item_id_1 = likes.sns_object_id_1
     -- INNER JOIN snsdb_new.likes on snsdb_new.content.sns_item_id_1 = snsdb_new.likes.sns_object_id_1 --  NOT OPTIMIZED
    WHERE
        snsdb_new.content.sns_item_id_0 = @sns_item
        AND snsdb_new.content.sns_id = @sns_id
        AND (content.date <= FROM_UNIXTIME(paydb.sns_profiles.date_create) OR content.date IS NULL)
        AND     snsdb_new.likes.sns_profile_id IN
                    (SELECT
                         frnd.friend_sns_item_id
                     FROM
                         snsdb_new.friends as frnd
                     WHERE
                         frnd.sns_item_id = snsdb_new.content.sns_item_id_0 and frnd.sns_id = snsdb_new.content.sns_id)

    GROUP BY
        snsdb_new.content.id
    ORDER BY
        date DESC
    LIMIT 200;
