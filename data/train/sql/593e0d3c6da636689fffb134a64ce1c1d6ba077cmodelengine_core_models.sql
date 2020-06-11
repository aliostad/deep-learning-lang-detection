/*- 模型数据表 -*/
DROP TABLE IF EXISTS modelengine_core_models;
CREATE TABLE modelengine_core_models ( 
    model_id          INTEGER          PRIMARY KEY
                                       NOT NULL
                                       UNIQUE,
    model_code        NVARCHAR( 20 )   NOT NULL
                                       UNIQUE,
    model_name        NVARCHAR( 255 ),
    model_description NVARCHAR( 255 ),
    model_table       NVARCHAR( 50 ),
    attribute_table   NVARCHAR( 50 ),
    category_id       INTEGER          NOT NULL
                                       DEFAULT ( 0 ),
    update_time       INTEGER          NOT NULL,
    create_time       INTEGER          NOT NULL 
);
