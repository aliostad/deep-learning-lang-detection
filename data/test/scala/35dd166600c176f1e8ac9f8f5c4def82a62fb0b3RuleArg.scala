package tifmo

import dcstree.SemRole
import dcstree.Relation

package inference {
	
	abstract case class RuleArg(arg: Any) {
		private[inference] val terms: Set[TermIndex]
		private[inference] def dumpMe(tmmap: Map[TermIndex, TermIndex]): RuleArg
	}
	
	trait RuleDo[T <: IEPred] extends ((IEngineCore, T, Seq[RuleArg]) => Unit) with Serializable
	
	object RAConversion {
		
		class RArgT(x: TermIndex) extends RuleArg(x) {
			private[inference] val terms = Set(x)
			private[inference] def dumpMe(tmmap: Map[TermIndex, TermIndex]) = new RArgT(tmmap(x))
		}
		implicit def convertT(x: TermIndex) = new RArgT(x)
		
		class RArgR(x: SemRole) extends RuleArg(x) {
			private[inference] val terms = Set.empty[TermIndex]
			private[inference] def dumpMe(tmmap: Map[TermIndex, TermIndex]) = new RArgR(x)
		}
		implicit def convertR(x: SemRole) = new RArgR(x)
		
		class RArgTRs(x: Set[(TermIndex, SemRole)]) extends RuleArg(x) {
			private[inference] val terms = x.map(_._1)
			private[inference] def dumpMe(tmmap: Map[TermIndex, TermIndex]) = new RArgTRs(x.map(y => (tmmap(y._1), y._2)))
		}
		implicit def convertTRs(x: Set[(TermIndex, SemRole)]) = new RArgTRs(x)
		
		class RArgTs(x: Iterable[TermIndex]) extends RuleArg(x) {
			private[inference] val terms = x.toSet
			private[inference] def dumpMe(tmmap: Map[TermIndex, TermIndex]) = new RArgTs(x.map(tmmap(_)))
		}
		implicit def convertTs(x: Iterable[TermIndex]) = new RArgTs(x)
		
		class RArgRs(x: Iterable[SemRole]) extends RuleArg(x) {
			private[inference] val terms = Set.empty[TermIndex]
			private[inference] def dumpMe(tmmap: Map[TermIndex, TermIndex]) = new RArgRs(x)
		}
		implicit def convertRs(x: Iterable[SemRole]) = new RArgRs(x)
		
		class RArgRL(x: Relation) extends RuleArg(x) {
			private[inference] val terms = Set.empty[TermIndex]
			private[inference] def dumpMe(tmmap: Map[TermIndex, TermIndex]) = new RArgRL(x)
		}
		implicit def convertRL(x: Relation) = new RArgRL(x)
		
		class RArgStr(x: String) extends RuleArg(x) {
			private[inference] val terms = Set.empty[TermIndex]
			private[inference] def dumpMe(tmmap: Map[TermIndex, TermIndex]) = new RArgStr(x)
		}
		implicit def convertStr(x: String) = new RArgStr(x)
		
	}
	
}
