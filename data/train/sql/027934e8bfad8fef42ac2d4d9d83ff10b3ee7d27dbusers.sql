# Rechte für `deleteUser`@`localhost`

GRANT DELETE, DROP ON *.* TO 'deleteUser'@'localhost' IDENTIFIED BY PASSWORD '*906AD45F3193912A44589404C837025C50BB1C06';

GRANT ALL PRIVILEGES ON `gaestebuch`.* TO 'deleteUser'@'localhost';


# Rechte für `editUser`@`localhost`

GRANT UPDATE ON *.* TO 'editUser'@'localhost' IDENTIFIED BY PASSWORD '*D545E00E4F906839935E949305FB6E2385EB4FA9';

GRANT ALL PRIVILEGES ON `gaestebuch`.* TO 'editUser'@'localhost';


# Rechte für `insertUser`@`localhost`

GRANT INSERT ON *.* TO 'insertUser'@'localhost' IDENTIFIED BY PASSWORD '*3CC8C7AE439A70D6D75E8DD9731F73D3B9DF3AA2';

GRANT ALL PRIVILEGES ON `gaestebuch`.* TO 'insertUser'@'localhost';


# Rechte für `readUser`@`localhost`

GRANT SELECT, SHOW DATABASES ON *.* TO 'readUser'@'localhost' IDENTIFIED BY PASSWORD '*9E3491A3F7967306A833E3CC93676BA23E6D5DC2';

GRANT ALL PRIVILEGES ON `gaestebuch`.* TO 'readUser'@'localhost';