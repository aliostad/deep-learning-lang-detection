package connectorFamily.connector

/**
 * Initial approach to represent a OldConnector. Being replaced by Conn.
 */
@deprecated
class OldConnector[R<:Rep[R]]
(val from: Interface, val to: Interface, val sort: R) {
//extends Context[R](){

/****
PRECEDENCE of infix operators:
-----
letter other
|
^
&
! =?
< >
:?
+ -
* / %
? \
****/
	
	
	/** Tense product of OldConnectors */
	def *(other:OldConnector[R]): OldConnector[R] =
		new OldConnector(
				from ++ other.from,
				to ++ other.to,
				sort * other.sort 
				)
	
	/** Sequential composition of OldConnectors */
	def &(other:OldConnector[R]): OldConnector[R] =
		if (matches(other))
		  new OldConnector(
		      from,
		      other.to,
		      sort & other.sort
		      )
		else
			throw new RuntimeException("OldConnectors are not compatible:\n - "+
					this+"\n - "+other)
	
	/** Choice of OldConnectors */
	def +(other:OldConnector[R]): OldConnector[R] =
		if (from == other.from && to == other.to)
			new OldConnector(from,to,sort + sort)
		else
      throw new RuntimeException("OldConnectors have different signatures:\n - "+
          this+"\n - "+other)

	/** Checks if the composition is valid. */
	def matches(other:OldConnector[R]) =
		to == other.from
		
	/**
	 * Inverts the direction of a OldConnector
	 */
	def inv: OldConnector[R] =
		new OldConnector(to.inv, from.inv, sort.inv)
		
	override def toString: String =
//      from.toString ++ sort.toString ++ to.toString
      sort.toString ++ ": " ++ PP(from) ++ " -> " ++ PP(to)
		
}

/** The objects being composed.
 * Could be strings, reo OldConnectors, open petri nets, etc. 
 */
abstract class Rep[R<:Rep[R]] {
	/** Product */
  def *(other:R): R
  /** Sequential composition */
  def &(other:R): R
  /** Choice */
  def +(other:R): R
  /** Inverse */
  def inv: R
}

class NullRep extends Rep[NullRep] {
	def *(other:NullRep) = other
  def &(other:NullRep) = other
  def +(other:NullRep) = other
  def inv = this
}

/** OldConnector with references to the context and hole used to produce it. */
class OldConnectorCtx[R<:Rep[R]](from: Interface,to: Interface,sort: R,
		                          val ctx: Context[R], val hole:OldConnector[R])
  extends OldConnector[R](from,to,sort)

// needs: to create a new OldConnector from a given one, and
//        to recover the context from an instantiated OldConnector
/** Context: given a OldConnector returns a new OldConnector.
 *  
 *  Automatically creates references to this context and the hole
 *  when applied to a OldConnector.
 */
class Context[R<:Rep[R]] (f: OldConnector[R] => OldConnector[R]) {
	def apply(arg:OldConnector[R]) = {
		val nc = f(arg)
		new OldConnectorCtx(nc.from,nc.to,nc.sort,this,arg)
	} 
}


//class OldConnectorCtxs[R<:Rep[R]](from: Interface,to: Interface,sort: R,
//                               val ctx: Contexts[R], val holes:List[OldConnector[R]])
//  extends OldConnector[R](from,to,sort)
//
//class Contexts[R<:Rep[R]](f: List[OldConnector[R]] => OldConnector[R]) {
////extends Context[R]((con:OldConnector[R]) => f(List(con))){
//	def apply(args:List[OldConnector[R]]) = {
//		val nc = f(args)
//		new OldConnectorCtxs(nc.from,nc.to,nc.sort,this,args)
//	}
//}
