# mysqlds2_create_all.sh
# start in ./ds2/mysqlds2
cd build
echo "### Executing mysqlds2_create_db.sql"
mysql -u web --password=web < mysqlds2_create_db.sql
echo "### Executing mysqlds2_create_ind.sql"
mysql -u web --password=web < mysqlds2_create_ind.sql
echo "### Executing mysqlds2_create_sp.sql"
mysql -u web --password=web < mysqlds2_create_sp.sql
cd ../load/cust
echo "### Executing mysqlds2_load_cust.sql"
mysql -u web --password=web < mysqlds2_load_cust.sql
cd ../orders
echo "### Executing mysqlds2_load_orders.sql"
mysql -u web --password=web < mysqlds2_load_orders.sql
echo "### Executing mysqlds2_load_orderlines.sql"
mysql -u web --password=web < mysqlds2_load_orderlines.sql
echo "### Executing mysqlds2_load_cust_hist.sql"
mysql -u web --password=web < mysqlds2_load_cust_hist.sql
cd ../prod
echo "### Executing mysqlds2_load_prod.sql"
mysql -u web --password=web < mysqlds2_load_prod.sql
echo "### Executing mysqlds2_load_inv.sql"
mysql -u web --password=web < mysqlds2_load_inv.sql
echo "### COMPLETED"