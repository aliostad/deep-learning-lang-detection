/* Generated by Purgatory 2014-2017 */

package ch.epfl.data.dblab.deep.experimentation.tpch
import ch.epfl.data.dblab.deep._
import ch.epfl.data.dblab.deep.queryengine._
import ch.epfl.data.dblab.deep.storagemanager._
import ch.epfl.data.dblab.deep.schema._
import scala.reflect._
import ch.epfl.data.sc.pardis
import pardis.ir._
import pardis.types.PardisTypeImplicits._
import pardis.effects._
import pardis.deep._
import pardis.deep.scalalib._
import pardis.deep.scalalib.collection._
import pardis.deep.scalalib.io._

import ch.epfl.data.sc.pardis.quasi.anf.{ BaseExt, BaseExtIR }
import ch.epfl.data.sc.pardis.quasi.TypeParameters.MaybeParamTag

trait TPCHLoaderOps extends Base with FastScannerOps with ArrayOps with REGIONRecordOps with PARTSUPPRecordOps with PARTRecordOps with NATIONRecordOps with SUPPLIERRecordOps with LINEITEMRecordOps with ORDERSRecordOps with CUSTOMERRecordOps with OptimalStringOps with LoaderOps with TableOps {
  // Type representation
  val TPCHLoaderType = TPCHLoaderIRs.TPCHLoaderType
  implicit val typeTPCHLoader: TypeRep[TPCHLoader] = TPCHLoaderType
  implicit class TPCHLoaderRep(self: Rep[TPCHLoader]) {

  }
  object TPCHLoader {
    def getTable(tableName: Rep[String]): Rep[Table] = tPCHLoaderGetTableObject(tableName)
    def loadRegion(): Rep[Array[REGIONRecord]] = tPCHLoaderLoadRegionObject()
    def loadPartsupp(): Rep[Array[PARTSUPPRecord]] = tPCHLoaderLoadPartsuppObject()
    def loadPart(): Rep[Array[PARTRecord]] = tPCHLoaderLoadPartObject()
    def loadNation(): Rep[Array[NATIONRecord]] = tPCHLoaderLoadNationObject()
    def loadSupplier(): Rep[Array[SUPPLIERRecord]] = tPCHLoaderLoadSupplierObject()
    def loadLineitem(): Rep[Array[LINEITEMRecord]] = tPCHLoaderLoadLineitemObject()
    def loadOrders(): Rep[Array[ORDERSRecord]] = tPCHLoaderLoadOrdersObject()
    def loadCustomer(): Rep[Array[CUSTOMERRecord]] = tPCHLoaderLoadCustomerObject()
  }
  // constructors

  // IR defs
  val TPCHLoaderGetTableObject = TPCHLoaderIRs.TPCHLoaderGetTableObject
  type TPCHLoaderGetTableObject = TPCHLoaderIRs.TPCHLoaderGetTableObject
  val TPCHLoaderLoadRegionObject = TPCHLoaderIRs.TPCHLoaderLoadRegionObject
  type TPCHLoaderLoadRegionObject = TPCHLoaderIRs.TPCHLoaderLoadRegionObject
  val TPCHLoaderLoadPartsuppObject = TPCHLoaderIRs.TPCHLoaderLoadPartsuppObject
  type TPCHLoaderLoadPartsuppObject = TPCHLoaderIRs.TPCHLoaderLoadPartsuppObject
  val TPCHLoaderLoadPartObject = TPCHLoaderIRs.TPCHLoaderLoadPartObject
  type TPCHLoaderLoadPartObject = TPCHLoaderIRs.TPCHLoaderLoadPartObject
  val TPCHLoaderLoadNationObject = TPCHLoaderIRs.TPCHLoaderLoadNationObject
  type TPCHLoaderLoadNationObject = TPCHLoaderIRs.TPCHLoaderLoadNationObject
  val TPCHLoaderLoadSupplierObject = TPCHLoaderIRs.TPCHLoaderLoadSupplierObject
  type TPCHLoaderLoadSupplierObject = TPCHLoaderIRs.TPCHLoaderLoadSupplierObject
  val TPCHLoaderLoadLineitemObject = TPCHLoaderIRs.TPCHLoaderLoadLineitemObject
  type TPCHLoaderLoadLineitemObject = TPCHLoaderIRs.TPCHLoaderLoadLineitemObject
  val TPCHLoaderLoadOrdersObject = TPCHLoaderIRs.TPCHLoaderLoadOrdersObject
  type TPCHLoaderLoadOrdersObject = TPCHLoaderIRs.TPCHLoaderLoadOrdersObject
  val TPCHLoaderLoadCustomerObject = TPCHLoaderIRs.TPCHLoaderLoadCustomerObject
  type TPCHLoaderLoadCustomerObject = TPCHLoaderIRs.TPCHLoaderLoadCustomerObject
  // method definitions
  def tPCHLoaderGetTableObject(tableName: Rep[String]): Rep[Table] = TPCHLoaderGetTableObject(tableName)
  def tPCHLoaderLoadRegionObject(): Rep[Array[REGIONRecord]] = TPCHLoaderLoadRegionObject()
  def tPCHLoaderLoadPartsuppObject(): Rep[Array[PARTSUPPRecord]] = TPCHLoaderLoadPartsuppObject()
  def tPCHLoaderLoadPartObject(): Rep[Array[PARTRecord]] = TPCHLoaderLoadPartObject()
  def tPCHLoaderLoadNationObject(): Rep[Array[NATIONRecord]] = TPCHLoaderLoadNationObject()
  def tPCHLoaderLoadSupplierObject(): Rep[Array[SUPPLIERRecord]] = TPCHLoaderLoadSupplierObject()
  def tPCHLoaderLoadLineitemObject(): Rep[Array[LINEITEMRecord]] = TPCHLoaderLoadLineitemObject()
  def tPCHLoaderLoadOrdersObject(): Rep[Array[ORDERSRecord]] = TPCHLoaderLoadOrdersObject()
  def tPCHLoaderLoadCustomerObject(): Rep[Array[CUSTOMERRecord]] = TPCHLoaderLoadCustomerObject()
  type TPCHLoader = ch.epfl.data.dblab.experimentation.tpch.TPCHLoader
}
object TPCHLoaderIRs extends Base {
  import FastScannerIRs._
  import ArrayIRs._
  import REGIONRecordIRs._
  import PARTSUPPRecordIRs._
  import PARTRecordIRs._
  import NATIONRecordIRs._
  import SUPPLIERRecordIRs._
  import LINEITEMRecordIRs._
  import ORDERSRecordIRs._
  import CUSTOMERRecordIRs._
  import OptimalStringIRs._
  import LoaderIRs._
  import TableIRs._
  // Type representation
  case object TPCHLoaderType extends TypeRep[TPCHLoader] {
    def rebuild(newArguments: TypeRep[_]*): TypeRep[_] = TPCHLoaderType
    val name = "TPCHLoader"
    val typeArguments = Nil
  }
  implicit val typeTPCHLoader: TypeRep[TPCHLoader] = TPCHLoaderType
  // case classes
  case class TPCHLoaderGetTableObject(tableName: Rep[String]) extends FunctionDef[Table](None, "TPCHLoader.getTable", List(List(tableName))) {
    override def curriedConstructor = (copy _)
  }

  case class TPCHLoaderLoadRegionObject() extends FunctionDef[Array[REGIONRecord]](None, "TPCHLoader.loadRegion", List(List())) {
    override def curriedConstructor = (x: Any) => copy()
  }

  case class TPCHLoaderLoadPartsuppObject() extends FunctionDef[Array[PARTSUPPRecord]](None, "TPCHLoader.loadPartsupp", List(List())) {
    override def curriedConstructor = (x: Any) => copy()
  }

  case class TPCHLoaderLoadPartObject() extends FunctionDef[Array[PARTRecord]](None, "TPCHLoader.loadPart", List(List())) {
    override def curriedConstructor = (x: Any) => copy()
  }

  case class TPCHLoaderLoadNationObject() extends FunctionDef[Array[NATIONRecord]](None, "TPCHLoader.loadNation", List(List())) {
    override def curriedConstructor = (x: Any) => copy()
  }

  case class TPCHLoaderLoadSupplierObject() extends FunctionDef[Array[SUPPLIERRecord]](None, "TPCHLoader.loadSupplier", List(List())) {
    override def curriedConstructor = (x: Any) => copy()
  }

  case class TPCHLoaderLoadLineitemObject() extends FunctionDef[Array[LINEITEMRecord]](None, "TPCHLoader.loadLineitem", List(List())) {
    override def curriedConstructor = (x: Any) => copy()
  }

  case class TPCHLoaderLoadOrdersObject() extends FunctionDef[Array[ORDERSRecord]](None, "TPCHLoader.loadOrders", List(List())) {
    override def curriedConstructor = (x: Any) => copy()
  }

  case class TPCHLoaderLoadCustomerObject() extends FunctionDef[Array[CUSTOMERRecord]](None, "TPCHLoader.loadCustomer", List(List())) {
    override def curriedConstructor = (x: Any) => copy()
  }

  type TPCHLoader = ch.epfl.data.dblab.experimentation.tpch.TPCHLoader
}
trait TPCHLoaderImplicits extends TPCHLoaderOps {
  // Add implicit conversions here!
}
trait TPCHLoaderComponent extends TPCHLoaderOps with TPCHLoaderImplicits {}

trait TPCHLoaderImplementations extends TPCHLoaderOps {
  override def tPCHLoaderLoadRegionObject(): Rep[Array[REGIONRecord]] = {
    Loader.loadTable[ch.epfl.data.dblab.experimentation.tpch.REGIONRecord](TPCHLoader.getTable(unit("REGION")))
  }
  override def tPCHLoaderLoadPartsuppObject(): Rep[Array[PARTSUPPRecord]] = {
    Loader.loadTable[ch.epfl.data.dblab.experimentation.tpch.PARTSUPPRecord](TPCHLoader.getTable(unit("PARTSUPP")))
  }
  override def tPCHLoaderLoadPartObject(): Rep[Array[PARTRecord]] = {
    Loader.loadTable[ch.epfl.data.dblab.experimentation.tpch.PARTRecord](TPCHLoader.getTable(unit("PART")))
  }
  override def tPCHLoaderLoadNationObject(): Rep[Array[NATIONRecord]] = {
    Loader.loadTable[ch.epfl.data.dblab.experimentation.tpch.NATIONRecord](TPCHLoader.getTable(unit("NATION")))
  }
  override def tPCHLoaderLoadSupplierObject(): Rep[Array[SUPPLIERRecord]] = {
    Loader.loadTable[ch.epfl.data.dblab.experimentation.tpch.SUPPLIERRecord](TPCHLoader.getTable(unit("SUPPLIER")))
  }
  override def tPCHLoaderLoadLineitemObject(): Rep[Array[LINEITEMRecord]] = {
    Loader.loadTable[ch.epfl.data.dblab.experimentation.tpch.LINEITEMRecord](TPCHLoader.getTable(unit("LINEITEM")))
  }
  override def tPCHLoaderLoadOrdersObject(): Rep[Array[ORDERSRecord]] = {
    Loader.loadTable[ch.epfl.data.dblab.experimentation.tpch.ORDERSRecord](TPCHLoader.getTable(unit("ORDERS")))
  }
  override def tPCHLoaderLoadCustomerObject(): Rep[Array[CUSTOMERRecord]] = {
    Loader.loadTable[ch.epfl.data.dblab.experimentation.tpch.CUSTOMERRecord](TPCHLoader.getTable(unit("CUSTOMER")))
  }
}

trait TPCHLoaderPartialEvaluation extends TPCHLoaderComponent with BasePartialEvaluation {
  // Immutable field inlining 

  // Mutable field inlining 
  // Pure function partial evaluation
}

