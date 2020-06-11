package com.ms.qaTools.saturn.codeGen
import scala.collection.JavaConversions.asScalaBuffer
import scala.collection.JavaConversions.asScalaIterator
import org.eclipse.emf.ecore.EObject
import com.ms.qaTools.saturn.{AbstractRunGroup => MAbstractRunGroup}
import com.ms.qaTools.saturn.{Attribute => MAttribute}
import com.ms.qaTools.saturn.repetition.ForEachRepetition
import com.ms.qaTools.saturn.repetition.ForEachXPathRepetition
import com.ms.qaTools.saturn.repetition.ForRepetition
import com.ms.qaTools.saturn.resources.referenceResource.ReferenceResource
import com.ms.qaTools.saturn.types.AbstractRepetitionHandler
import com.ms.qaTools.saturn.types.NamedResourceDefinition
import com.ms.qaTools.saturn.values.ReferenceComplexValue
import scala.language.implicitConversions

case class DependencyExtractor(preRepetitionDependencies:Seq[EObject],
                               postRepetitionDependencies:Seq[EObject],
                               repetitionHandler:Option[AbstractRepetitionHandler]) {
  import DependencyExtractor.dumpEObject
  override def toString:String = "pre: [" + preRepetitionDependencies.map{dumpEObject(_)}.mkString(",") + "]\npost:[" + postRepetitionDependencies.map{dumpEObject(_)}.mkString(",") + "]"
}

object DependencyExtractor {
  implicit def eObject2EObjectSeq(e:EObject):Seq[EObject] = if(e == null) Nil else Seq(e)

  trait Dump[-A] {
    def dump(x: A): String
  }
  def dump[A: Dump](x: A) = implicitly[Dump[A]].dump(x)

  def dumpEObject(e:EObject):String = e match {
    case a:MAttribute                => "A(" + a.getName() + ")"
    case r:NamedResourceDefinition   => "R(" + r.getName() + ")"
    case r:AbstractRepetitionHandler => "REPETITION(" + r.eClass().getName() + ")"
    case _                           => e.toString()
  }

  implicit object DumpString extends Dump[String] {
    def dump(x: String) = x
  }

  implicit object DumpEObject extends Dump[EObject] {
    def dump(x: EObject) = dumpEObject(x)
  }

  implicit def DumpSet[A: Dump] = new Dump[Set[A]] {
    def dump(xs: Set[A]) = s"[${xs.map(implicitly[Dump[A]].dump).mkString(",")}]"
  }

  implicit def DumpMap[K: Dump, A: Dump] = new Dump[Map[K, A]] {
    def dump(kvs: Map[K, A]) = kvs map {
      case (k, v) => implicitly[Dump[K]].dump(k) + " => " + implicitly[Dump[A]].dump(v)
    } mkString "\n"
  }

  def apply(runGroup:MAbstractRunGroup):DependencyExtractor = {
    val attributeMap:Map[String,EObject] = {runGroup.getAttributes.map{a => (a.getName, a)} ++ repetitionHandlerDependencyPairs(Option(runGroup.getRepetitionHandler))}.toMap
    val resourceMap = runGroup.getResources().filter(_.isEnabled()).map{a => (a.getName(),a)}.toMap
    val roots:Seq[EObject] = runGroup.getAttributes() ++ runGroup.getResources().filter(_.isEnabled())

    val depMap: Seq[(EObject, Set[EObject])] = roots.map { eObject =>
      eObject -> (Iterator(eObject) ++ eObject.eAllContents).flatMap {
        case ref:ReferenceResource     => resourceMap.get(ref.getResource)
        case ref:ReferenceComplexValue => attributeMap.get(ref.getUserAttribute).orElse(resourceMap.get(ref.getUserAttribute))
        case _                         => None
      }.toSet
    }

    def extractDependencies(depMap: Seq[(EObject, Set[EObject])],
                            repetitionHandler: Option[AbstractRepetitionHandler]): Seq[EObject] = {
      import com.ms.qaTools.saturn.kronus.topSort
      val (cycle, sorted) = topSort(depMap)
      if (cycle.isEmpty) sorted
      else repetitionHandler match {
        case Some(r) => sorted ++: r +: extractDependencies(depMap.map { case (x, deps) => (x, deps - r) }, None)
        case None    => throw new Error("Attribute or Resource references to itself: " + dump(depMap.toMap))
      }
    }

    val deps = extractDependencies(depMap, Option(runGroup.getRepetitionHandler))
    val repIdx = deps.indexWhere(_.isInstanceOf[AbstractRepetitionHandler])
    val (pre, post) = if(repIdx >= 0) {
      val(a, b) = deps.splitAt(repIdx)
      (a, b.tail)
    }
    else (deps, Nil)
    new DependencyExtractor(pre, post, Option(runGroup.getRepetitionHandler))
  }

  def repetitionHandlerDependencyPairs(repetitionHandler:Option[AbstractRepetitionHandler]) = repetitionHandler match {
      case Some(r:ForRepetition)          => r.getIterators().map{     i => (i.getAttribute(), r)}
      case Some(r:ForEachRepetition)      => r.getColumnMappings().map{m => (m.getAttribute(), r)}
      case Some(r:ForEachXPathRepetition) => r.getXPathMappings().map{ m => (m.getAttribute(), r)}
      case None                           => Nil
      case r                              => throw new Exception(s"Unknown repetition handler: $r")
  }
}
/*
Copyright 2017 Morgan Stanley

Licensed under the GNU Lesser General Public License Version 3 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

https://www.gnu.org/licenses/lgpl-3.0.en.html

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

IN ADDITION, THE FOLLOWING DISCLAIMER APPLIES IN CONNECTION WITH THIS PROGRAM:

THIS SOFTWARE IS LICENSED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE AND ANY
WARRANTY OF NON-INFRINGEMENT, ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE. THIS SOFTWARE MAY BE REDISTRIBUTED TO OTHERS ONLY BY EFFECTIVELY
USING THIS OR ANOTHER EQUIVALENT DISCLAIMER IN ADDITION TO ANY OTHER REQUIRED
LICENSE TERMS.
*/
