package models

import java.util.Date
import util.DateWrapper

case class EpisodesSummary(watched:Int,total:Int) {
  require(watched<=total)
}

case class ShowSummary(name:String,id:Long,episodes:EpisodesSummary,lastCreated:Date)

object ShowSummary {
  def apply(show:Show) : ShowSummary = {
    
    val total = show.allEpisodes.length
    val lastCreated = show.allEpisodes.foldRight(util.epoch){(ep1,date) => 
      if(ep1.created < date) date else ep1.created
    }
    val id = show.id
    ShowSummary(show.name,id,EpisodesSummary(0,total),lastCreated)
  }
}

case class LibrarySummary(shows: Traversable[ShowSummary])

object LibrarySummary {
  def apply(library: Library) : LibrarySummary = {
    val showSummaries = library.shows.map( ShowSummary(_) )
    LibrarySummary(showSummaries)
  }
}