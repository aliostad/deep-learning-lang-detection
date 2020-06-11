SELECT '1', * FROM CDB_TorquePixel_dump('{0, 10,20,30}', 0);
SELECT '2', * FROM CDB_TorquePixel_dump('{0, 10,20,30}', 1);
SELECT '3', * FROM CDB_TorquePixel_dump('{0, 10,20,30}', 2);

SELECT '4', * FROM CDB_TorquePixel_dump('{1, 2, 10,20,30}', 0);
SELECT '5', * FROM CDB_TorquePixel_dump('{1, 2, 10,20,30}', 1);
SELECT '6', * FROM CDB_TorquePixel_dump('{1, 2, 10,20,30}', 2);

SELECT '7', * FROM CDB_TorquePixel_dump('{2, 3,4, 13,14, 23,24, 33,34}', 0) ORDER BY t;
SELECT '8', * FROM CDB_TorquePixel_dump('{2, 3,4, 13,14, 23,24, 33,34}', 1) ORDER BY t;
SELECT '9', * FROM CDB_TorquePixel_dump('{2, 3,4, 13,14, 23,24, 33,34}', 2) ORDER BY t;

