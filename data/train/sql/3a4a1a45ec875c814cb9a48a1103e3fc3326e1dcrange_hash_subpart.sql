CREATE TABLE part.orders_range_hash (
    order_id                                 NUMBER(12)   NOT NULL
  , order_date                               TIMESTAMP(6) NOT NULL
  , order_mode                               VARCHAR2(8)
  , customer_id                              NUMBER(12) NOT NULL
  , order_status                             NUMBER(2)
  , order_total                              NUMBER(8,2)
  , sales_rep_id                             NUMBER(6)
  , promotion_id                             NUMBER(6)
  , warehouse_id                             NUMBER(6)
)
PARTITION BY RANGE   (order_id) 
SUBPARTITION BY HASH (customer_id) 
SUBPARTITION TEMPLATE(
    SUBPARTITION sp1 TABLESPACE users,
    SUBPARTITION sp2 TABLESPACE users,
    SUBPARTITION sp3 TABLESPACE users,
    SUBPARTITION sp4 TABLESPACE users)
(
    PARTITION id_00m VALUES LESS THAN (1000000)
  , PARTITION id_01m VALUES LESS THAN (2000000)
  , PARTITION id_02m VALUES LESS THAN (3000000)
  , PARTITION id_03m VALUES LESS THAN (4000000)
  , PARTITION id_04m VALUES LESS THAN (5000000)
  , PARTITION id_05m VALUES LESS THAN (6000000)
  , PARTITION id_06m VALUES LESS THAN (7000000)
  , PARTITION id_07m VALUES LESS THAN (8000000)
  , PARTITION id_08m VALUES LESS THAN (9000000)
  , PARTITION id_09m VALUES LESS THAN (MAXVALUE)
)
TABLESPACE users
/

INSERT /*+ APPEND */ INTO part.orders_range_hash
SELECT * FROM part.orders
/

COMMIT;

