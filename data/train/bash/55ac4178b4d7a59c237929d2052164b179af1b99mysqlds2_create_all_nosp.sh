# mysqlds2_create_all.sh
# start in ./ds2/mysqlds2
cd build
mysql -u web --password=web < mysqlds2_create_db.sql
mysql -u web --password=web < mysqlds2_create_ind.sql
#mysql -u web --password=web < mysqlds2_create_sp.sql
cd ../load/cust
mysql -u web --password=web < mysqlds2_load_cust.sql
cd ../orders
mysql -u web --password=web < mysqlds2_load_orders.sql 
mysql -u web --password=web < mysqlds2_load_orderlines.sql 
mysql -u web --password=web < mysqlds2_load_cust_hist.sql 
cd ../prod
mysql -u web --password=web < mysqlds2_load_prod.sql 
mysql -u web --password=web < mysqlds2_load_inv.sql 
