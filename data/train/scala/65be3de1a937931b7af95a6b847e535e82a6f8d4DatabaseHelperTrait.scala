package com.limeblast.scaliteorm

import android.database.sqlite.{SQLiteDatabase, SQLiteOpenHelper}
import android.util.Log
import com.limeblast.mydeatree.AppSettings._


trait DatabaseHelperTrait extends SQLiteOpenHelper {
  def tables: List[TableDefinition]

  def onCreate(db: SQLiteDatabase) {
    tables foreach (tableDefinition => db.execSQL(tableDefinition.toString))
  }

  def onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
    Log.w(APP_TAG, "Upgrading from version " + oldVersion + " to " + newVersion + ", which will destroy all old data.")
    // Drop older tables if exists
    tables foreach (table => db.execSQL("DROP TABLE IF EXISTS " + table.tableName))

    onCreate(db)
  }
}
