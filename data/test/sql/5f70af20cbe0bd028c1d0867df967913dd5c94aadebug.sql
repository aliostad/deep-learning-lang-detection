
-- Sample script to see how things run

-- Clean Up
SELECT CleanConfigDB();

-- Test1 Sub-Configuration
SELECT CreateCrateConfiguration( 'Test1');
SELECT InsertCrateConfiguration( 'Test1'::TEXT, 0,
				 'A=>1'::HSTORE,
				 'B=>2'::HSTORE,
				 'C=>3'::HSTORE);

SELECT InsertCrateConfiguration( 'Test1', 1,
				 'A=>1'::HSTORE,
				 'B=>2'::HSTORE,
				 'C=>3'::HSTORE);

SELECT InsertCrateConfiguration( 'Test1', 1,
				 'A=>1',
				 'B=>2',
				 'C=>3');

-- Test2 Sub-Configuration
SELECT CreateCrateConfiguration( 'Test2');
SELECT InsertCrateConfiguration( 'Test2', 0,
				 'A=>1,X=>0',
				 'B=>2,Y=>0',
				 'C=>3,Z=>0');

SELECT AppendCrateConfiguration( 'Test2', 
       				 0,   --subconf 
				 1,   --crate
				 -1,  --slot
				 -1,  --channel
       				 '1'::BIT(64),
				 'X=>1' );

SELECT AppendCrateConfiguration( 'Test2', 
       				 0,   --subconf 
				 2,   --crate
				 -1,  --slot
				 -1,  --channel
       				 '11'::BIT(64),
				 'X=>2' );

SELECT AppendCrateConfiguration( 'Test2', 
       				 0,   --subconf 
				 2,   --crate
				 1,  --slot
				 -1,  --channel
       				 '111'::BIT(64),
				 'Y=>1' );

SELECT AppendCrateConfiguration( 'Test2', 
       				 0,   --subconf 
				 2,   --crate
				 1,  --slot
				 1,  --channel
       				 '111'::BIT(64),
				 'Z=>1' );

-- Let's try some exception calls
--SELECT InsertCrateConfiguration('Test1',0,0,0,'test1=>1');

-- Create MainConfiguration
SELECT InsertMainConfiguration( 'Test1=>0,Test2=>0'::hstore,
       				'Test1=>1,Test2=>1'::hstore,
       				'MainTest1');
-- Attempt to re-use the same name => Should have an exception
--SELECT InsertMainConfiguration('Test1=>0,Test2=>0,Test3=>0'::hstore,'MainTest1');
-- Attempt to insert the identical configuration set with different name => Should have an exception
--SELECT InsertMainConfiguration('Test1=>0,Test2=>0,Test3=>0'::hstore,'MainTest2');
-- Attempt to insert different configuration with different name => Should not have an exception
--SELECT InsertMainConfiguration('Test1=>1,Test2=>0,Test3=>0'::hstore,'MainTest2');
-- Attempt to insert "similar" configuration (lacking one of sub-config otherwise identical) => Should not have an exception
--SELECT InsertMainConfiguration('Test1=>1,Test2=>0'::hstore,'MainTest3');



