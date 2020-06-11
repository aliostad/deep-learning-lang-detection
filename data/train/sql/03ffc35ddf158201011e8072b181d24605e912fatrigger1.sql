-- SQL Server Syntax 
Trigger on an INSERT, UPDATE, or DELETE statement to a table or view (DML Trigger)

CREATE TRIGGER [ schema_name . ]trigger_name 
ON { table | view } 
[ WITH <dml_trigger_option> [ ,...n ] ]
{ FOR | AFTER | INSTEAD OF } 
{ [ INSERT ] [ , ] [ UPDATE ] [ , ] [ DELETE ] } 
[ WITH APPEND ]
[ NOT FOR REPLICATION ] 
AS { sql_statement  [ ; ] [ ,...n ] | EXTERNAL NAME <method specifier [ ; ] > }

<dml_trigger_option> ::=
    [ ENCRYPTION ]
    [ EXECUTE AS Clause ]

<method_specifier> ::= 
    assembly_name.class_name.method_name
