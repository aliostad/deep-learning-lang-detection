package controllers.graph.concept.need

import models.graph.concept.Concept
import models.intelligence.need.{Need, NeedDAO}

/**
 * A controller that manage needs
 * It's used directly by the ConceptController
 * @author Julien Pradet
 */
object NeedController {

  /**
   * Manages the update of needs for a concept
   * @param oldConcept concept before the update
   * @param newConcept concept wanted after the update
   * @return list of needs after the update
   */
  def updateNeedsForConcept(oldConcept: Concept, newConcept: Concept): List[Need] = {
      /* Delete unused needs */
      oldConcept.getOwnNeeds.map(oldNeed => {
        if (!newConcept.getOwnNeeds.exists(newNeed => oldNeed.id == newNeed.id)) {
          NeedDAO.delete(oldNeed.id)
        }
      })

      // Update or create new needs
      newConcept.getOwnNeeds.map(need => {
        need.id match {
          case 0 =>
            // The need is new
            NeedDAO.save(need)
          case id =>
            // The need is updated
            NeedDAO.update(id, need)
        }
      })
  }
}
