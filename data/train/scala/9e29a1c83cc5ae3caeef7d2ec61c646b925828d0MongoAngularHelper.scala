package it.agilelab.bigdata.wasp.web.utils

import play.api.libs.json.Json
import play.api.libs.json.Reads
import play.api.libs.json.Writes
import reactivemongo.bson._

import reactivemongo.api.commands.{UpdateWriteResult, WriteResult}

trait MongoAngularHelper extends AngularHelper {

    def WriteResultToAngularRes[T](writeResult: WriteResult, errorIfNotUpdated: Boolean = false, obj: Option[T] = None)(implicit sreader : BSONDocumentReader[T]) = WriteResult.lastError(writeResult) match {
          case None => {
	         
	           Left(obj.getOrElse( writeResult.originalDocument.map(b => {
	             println(b)
	             sreader.read(b)
	           }).get ))
          }
          case Some(_) => Right(AngularError(writeResult.message))
        }

    
    def WriteResultToAngularResOnDelete(writeResult: WriteResult) = WriteResult.lastError(writeResult) match {
          case None => Left(AngularOk)
          case Some(_) => Right(AngularError(writeResult.message))
        }
}