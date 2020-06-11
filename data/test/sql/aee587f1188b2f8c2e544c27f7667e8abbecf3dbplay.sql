
SELECT New_Training_Session('2011-04-28 10:00', '100 / 100 m gång');
SELECT New_Training_Session('2011-04-28 10:00', '100,200,300, 400,  500,400 / 100 m gång');
SELECT New_Training_Session('2011-04-28 10:00', '100,200,300,400,500,400/100m gång');
SELECT New_Training_Session('2011-04-28 10:00', '100,200,300,400,500,400 / 100 meter gång');




-- Play!

tdb=# SELECT New_Training_Session('2011-04-28 10:00');
 new_training_session
----------------------
                    1
(1 row)

tdb=# SELECT * FROM TrainingSessions;
 trainingsessionid |       datestamp
-------------------+------------------------
                 1 | 2011-04-28 10:00:00+02
(1 row)

tdb=# SELECT New_Training_Event(1, '24.6 seconds', 200);
 new_training_event
--------------------
                  1
(1 row)

tdb=# SELECT New_Training_Event(1, '3 minutes', 0);
 new_training_event
--------------------
                  2
(1 row)

tdb=# SELECT New_Training_Event(1, '25.5 seconds', 200);
 new_training_event
--------------------
                  3
(1 row)

tdb=# SELECT New_Training_Event(1, '3 minutes', 0);
 new_training_event
--------------------
                  4
(1 row)

tdb=# SELECT New_Training_Event(1, '25.3 seconds', 200);
 new_training_event
--------------------
                  5
(1 row)

tdb=# SELECT New_Training_Event(1, '10 minutes', 0);
 new_training_event
--------------------
                  6
(1 row)

tdb=# SELECT New_Training_Event(1, '24.7 seconds', 200);
 new_training_event
--------------------
                  7
(1 row)

tdb=# SELECT New_Training_Event(1, '3 minutes', 0);
 new_training_event
--------------------
                  8
(1 row)

tdb=# SELECT New_Training_Event(1, '25.2 seconds', 200);
 new_training_event
--------------------
                  9
(1 row)

tdb=# SELECT New_Training_Event(1, '3 minutes', 0);
 new_training_event
--------------------
                 10
(1 row)

tdb=# SELECT New_Training_Event(1, '24.4 seconds', 200);
 new_training_event
--------------------
                 11
(1 row)

tdb=# SELECT * FROM TrainingEvents;
 trainingeventid | trainingsessionid |  duration  | distance
-----------------+-------------------+------------+----------
               1 |                 1 | 00:00:24.6 |      200
               2 |                 1 | 00:03:00   |        0
               3 |                 1 | 00:00:25.5 |      200
               4 |                 1 | 00:03:00   |        0
               5 |                 1 | 00:00:25.3 |      200
               6 |                 1 | 00:10:00   |        0
               7 |                 1 | 00:00:24.7 |      200
               8 |                 1 | 00:03:00   |        0
               9 |                 1 | 00:00:25.2 |      200
              10 |                 1 | 00:03:00   |        0
              11 |                 1 | 00:00:24.4 |      200
(11 rows)

