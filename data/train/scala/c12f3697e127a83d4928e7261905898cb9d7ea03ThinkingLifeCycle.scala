package tu.coreservice.thinkinglifecycle

import tu.model.knowledge.communication.{ShortTermMemory, Request}


/**
 * Main component to manage Action-s (Selector, Way2Think,Critic).
 * ThinkingLifeCycle starts any Action as parallel process, except for the Way2Think grouped in Sequence.
 * All sequences are started as parallel processes.
 * Actions has levels and higher level actions manage low level actions.
 * @author max talanov
 *         date 2012-07-07
 *         time: 7:42 PM
 */


trait ThinkingLifeCycle {
  def apply(request: Request): ShortTermMemory
}
