package clean.util

/**
 * Created by david on 02.02.15.
 */
object Participants {


  def mapToUniqueName(s: String) = s.trim.split(" ").reverse(0) match {
    case s if s == "05" => "Mainz"
    case s if s == "04" => "Schalke"
    case s if s == "96" => "Hannover"
    case s if s == "SV" => "Hamburg"
    case s if s == "BSC" => "Berlin"
    case s => s
  }
  
  def splitParticipantsPart(posOfParticipants: Int) = (s: String) => {
    import clean.util.General._
    val oldParticipants = s.split(";")(posOfParticipants)
    val participantsSplitted = toCsvString(oldParticipants.split(" - ").map(mapToUniqueName))
    s.replace(oldParticipants, participantsSplitted)
  }
}
