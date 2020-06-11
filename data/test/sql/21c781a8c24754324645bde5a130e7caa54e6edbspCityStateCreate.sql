/*  
 **	Stored Procedures
 *
 *	spCityStateCreate	- Creates a new CityState entry.
 *	spCityStateRead		- Returns a CityState entry using Zip as the parameter.
 *	spCityStateUpdate	- Updates an existing CityState entry.
 *	*spCityStateDelete*?
 *	spCityStateReadAll	- Return all CityState entries.
 *	spCityStateReadCity	- Return CityState entries using City as the parameter.
 *	spCityStateReadState	 - Return CityState entries using State as the parameter.
 *	spCityStateReadCityState - Return CityState entry using both City and State as the parameter.
 ** -Daniel Collingwood
 */

CREATE PROCEDURE [dbo].[spCityStateCreate] 
	(@Zip	varchar(10), 
	 @City	varchar(50), 
	 @State	varchar(50))
AS
	IF NOT EXISTS (SELECT Zip FROM CityState WHERE Zip = @Zip) 
	INSERT INTO [dbo].[CityState] (Zip, City, State) 
	VALUES (@Zip, @City, @State)