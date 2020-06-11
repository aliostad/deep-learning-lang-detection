package com.loyal3.database.manage

import com.loyal3.test.support.scopes.SelfAwareSpecification

/**
 * Database manager tests
 */
class DatabaseManagerSpec extends SelfAwareSpecification {

  "createDb" should {
    "should create the database object with the given properties" in {
      // Given
      val dbProperties = Array[String]("jdbc:mysql://localhost:3306/test", "root", "password", "test")
      // When
      val result = DatabaseManager.createDb(dbProperties)

      // Then
      result.systemUrl mustEqual "jdbc:mysql://localhost:3306/mysql"
      result.dbUrl mustEqual dbProperties(0)
      result.username mustEqual dbProperties(1)
      result.password mustEqual dbProperties(2)
      result.database mustEqual dbProperties(3)
    }
  }

}
