package com.lunatech.play.json

import play.api.libs.json.{ __, JsObject, JsPath, JsValue, Json, Reads }
import play.api.libs.json.Json.JsValueWrapper
import play.api.libs.json.Reads.of

object Transformers {
  import play.api.libs.json.__

  def add(path: JsPath, value: JsValue): Reads[JsObject] =
    __.json update path.json.put(value)

  def add(key: String, value: JsValue): Reads[JsObject] =
    add(__ \ key, value)

  def addAll(fields: (String, JsValueWrapper)*): Reads[JsObject] =
    of[JsObject].map { case o => o ++ Json.obj(fields: _*) }

  def remove(path: JsPath): Reads[JsObject] =
    path.json.prune

  def remove(field: String): Reads[JsObject] =
    remove(__ \ field)

  def removeAll(fields: String*): Reads[JsObject] =
    of[JsObject].map { case o => fields.foldLeft(o)(_ - _) }

  def copy(path: JsPath, newPath: JsPath): Reads[JsObject] =
    __.json.update(newPath.json.copyFrom(path.json.pick))

  def copy(key: String, newKey: String): Reads[JsObject] =
    copy(__ \ key, __ \ newKey)

  def rename(oldKey: String, newKey: String): Reads[JsObject] =
    rename(__ \ oldKey, __ \ newKey)

  def rename(oldPath: JsPath, newPath: JsPath): Reads[JsObject] =
    copy(oldPath, newPath) andThen remove(oldPath)

  def all(transforms: Reads[_ <: JsValue]*): Reads[_ <: JsValue] =
    transforms.foldLeft[Reads[_ <: JsValue]](Reads.JsObjectReads)(_ andThen _)

  def manual(fn: JsValue => JsValue): Reads[_ <: JsValue] =
    of[JsValue].map { case old: JsValue => fn(old) }

  def using[A <: JsValue](fn: JsValue => Reads[A]): Reads[A] =
    of[JsValue].flatMap[A] { case old: JsValue => fn(old) }

}