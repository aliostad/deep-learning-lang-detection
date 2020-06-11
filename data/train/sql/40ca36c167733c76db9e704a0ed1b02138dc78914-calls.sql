-- Call the simple a() function
SELECT a();

-- Call get_account_balance for a new user, will create the user
SELECT get_account_balance('joel', 'secret', 'USD');
-- Call new_transaction for existing user, will not create a new user
SELECT new_transaction('joel', 'secret', 'USD', 10000);
SELECT new_transaction('joel', 'secret', 'USD', -3500);

-- Call new_transaction for non-existing user, will create the user
SELECT new_transaction('claes', 'qwerty', 'EUR', 5000);
SELECT new_transaction('claes', 'qwerty', 'EUR', -1000);
SELECT new_transaction('claes', 'qwerty', 'EUR', 2000);

-- Call get_account_balance for existing user, will not create the user
SELECT get_account_balance('claes', 'qwerty', 'EUR');
