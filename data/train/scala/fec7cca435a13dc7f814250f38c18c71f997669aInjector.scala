package se.purestyle.stockspider.database

import se.purestyle.stockspider.model.Stock

class Injector extends Connector {
	
	/**
	 * @requires 	a list of stocks
	 * @ensures 	that the stocks are injected into the database
	 */
	def inject( stocks : Array[Stock] ) {
		
		println( "Injector: Start injecting stock data." )
		
		val < = "'"
		
		var allNames = Array[String]()
		
		val (allExistingNamesResult, conn) = getFromDatabase( "SELECT name FROM Stocks" )
		while( allExistingNamesResult.next )
			allNames ++= Array( allExistingNamesResult.getString( "name" ) )
			
		conn.close()
		
		//Move all old values one step to the right, making old5 to disappear
		updateDataBase( "UPDATE Stocks SET oldValue5 = oldValue4;" 	)
		updateDataBase( "UPDATE Stocks SET oldValue4 = oldValue3;" 	)
		updateDataBase( "UPDATE Stocks SET oldValue3 = oldValue2;" 	)
		updateDataBase( "UPDATE Stocks SET oldValue2 = oldValue1;" 	)
		updateDataBase( "UPDATE Stocks SET oldValue1 = value;" 		)
			
		for( i <- 0 until stocks.size ) {
			
			//If stock is already in the table
			if( allNames.contains( stocks(i).name ) ) {
				
				updateDataBase( "UPDATE Stocks SET value = '" + stocks(i).value + "' WHERE name='" + stocks(i).name + "';" )
			
			} else {
				
				//If stock isn't in the table
				updateDataBase( 	"INSERT INTO Stocks VALUES (" +
								< + stocks(i).name 	+ < +
								"," +
								< + stocks(i).market 	+ < +
								"," +
								< + stocks(i).value 	+ < +
								",0,0,0,0,0)"
							 )
			}
		}
		
		println( "Injector: Finised injecting stock data." )
	}
}