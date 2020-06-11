package org.teamstory.chart

import org.joda.time.YearMonthDay
import org.httpobjects.Query

object ChartOptions {
  val LEGACY_FORMAT = ChartOptions(
                showGoalTargetDots=true,
                drawWeekNumbers=true, 
                drawOnlyEvenWeeks=false, 
                showCompletedWork=true, 
                showMonthLabels=false, 
                showMonthVerticals=false, 
                showGoalLabels=false, 
                showGoalHLines=true, 
                showGoalVLines=false, 
                weekStart = None,
                startDate = None,
                endDate = None
                  )
   def fromQuery(query:Query) = {
    
        
        def  queryParam[T](name:String, fn:(String)=>T = {(s:String)=>s}) = if(query==null) {
          None
        }else{
          if(query.paramNames().contains(name)){
            Some(fn(query.valueFor(name)))
          }else{
            None
          }
        }
        
        def isQueryParamPresent(name:String) = if(query==null) {
          false
        }else{
          if(query.paramNames().contains(name)){
            query.valueFor(name) match {
              case null => true
              case "true"=> true
              case "false"=> false
            }
          }else{
            false
          }
        }
      
      ChartOptions(
        showGoalTargetDots = isQueryParamPresent("showGoalTargetDots"),
        drawWeekNumbers = isQueryParamPresent("showWeekNumbers"),
        drawOnlyEvenWeeks = !isQueryParamPresent("showOddWeeks"),
        showCompletedWork = isQueryParamPresent("showCompletedWork"),
        showMonthLabels = isQueryParamPresent("showMonthLabels"),
        showMonthVerticals = isQueryParamPresent("showMonthVerticals"),
        showGoalLabels = isQueryParamPresent("showGoalLabels"),
        showGoalHLines = isQueryParamPresent("showGoalHLines"),
        showGoalVLines = isQueryParamPresent("showGoalVLines"),
        weekStart = queryParam("weekStartDay", {s=>new YearMonthDay(s)}),
        startDate = queryParam("startDate", {s=>new YearMonthDay(s)}),
        endDate = queryParam("endDate", {s=>new YearMonthDay(s)})
        )
  }
}
case class ChartOptions (
    showGoalTargetDots:Boolean, 
    drawWeekNumbers:Boolean, 
    drawOnlyEvenWeeks:Boolean, 
    showCompletedWork:Boolean, 
    showMonthLabels:Boolean, 
    showMonthVerticals:Boolean, 
    showGoalLabels:Boolean, 
    showGoalHLines:Boolean, 
    showGoalVLines:Boolean, 
    weekStart:Option[YearMonthDay],
    startDate:Option[YearMonthDay],
    endDate:Option[YearMonthDay]
)
