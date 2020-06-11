package dao

import com.mongodb.casbah.MongoCollection
import com.mongodb.casbah.MongoConnection
import com.mongodb.casbah.Imports._

/**
 * Helper Object to manage the MongoDb Database Connection
 */
object MongoFactory {
  
    private val SERVER = "localhost"
    private val PORT   = 27017
    private val DATABASE = "OrangeBus"
    private val COLLECTION = "DataRecord"
    val connection = MongoClient(SERVER)
    val collection = connection(DATABASE)(COLLECTION)

    def closeConnection() {
      connection.close()
    }
}
