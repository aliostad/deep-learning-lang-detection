package _0JS

import HelperObjects._
import SemanticHelpers._
import scala.collection.mutable.{Map => MMap}

class CollectOut {
  val mapping = MMap[(BigInt), (AV, Env, Store)]()

  def collect(doMap: Boolean,
              id: BigInt,
              a: AV,
              e: Env,
              s: Store) : (AV, Store) = {
    if(doMap) {
      if (mapping contains (id)) {
        val (oldVal, oldEnv, oldStore) = mapping(id)
        mapping(id) = (Join(oldVal, a, e), Join(oldEnv, e), Join(oldStore, s, e))
      } else {
        mapping(id) = (a, e, s)
      }
      (mapping(id)._1, mapping(id)._3)
    } else (a,s)
  }

  def collect(id: BigInt,
              defaultStore: Store) : (AV, Store) = {
    (mapping get id) match {
      case Some((a, _, s)) => (a, s)
      // in case of recursive calls, there would be no CollectOutgoing yet,
      // so return these default values that don't affect joins
      case None => (BOTTOM(freshVariableName), defaultStore)
    }
  }
}

class CollectIn {
  val mapping = MMap[BigInt, (Env, Store)]()

  def collect(id: BigInt,
              e: Env,
              s: Store) : (Boolean, Env, Store) = {
    if (mapping contains (id)) {
      val (oldEnv, oldStore) = mapping(id)
      val newEnv = Join(oldEnv,e)
      val newStore = Join(oldStore, s, newEnv)
      if ((oldEnv equals newEnv) && (oldStore equals newStore)) {
        (false, newEnv, newStore)
      } else {
        mapping(id) = (newEnv, newStore)
        (true, newEnv, newStore)
      }
    } else {
      mapping(id) = (e, s)
      (true, e, s)
    }
  }
}

