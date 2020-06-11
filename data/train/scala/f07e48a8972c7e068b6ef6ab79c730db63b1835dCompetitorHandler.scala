package com.somunia.battle

class CompetitorHandler(val actionHandler: ActionHandler, val actionCreator: ActionCreator) {
    def handle(competitor: Competitor, progress: Int): Unit = {
        println("C: " + competitor.name)
        if (competitor.needsAction(progress)) {
            println("Attach new action")
            val oldAction = competitor.action
            competitor.action = actionCreator.createFor(competitor, progress + oldAction.distanceTo(progress))
        } else {
            actionHandler.handle(competitor.action)
        }
    }
}