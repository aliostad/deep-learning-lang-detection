package com.shloader

/**
 *
 */
class Episode(_showName:String, _season:Int, _episode:Int, _showId:Int = 0) {
  def searchString() =
    (_showName +
    " s" +
    (if (_season >= 10) _season else "0" + _season) +
    "e" +
    (if (_episode >= 10) _episode else "0" + _episode)).toLowerCase

  def showName = _showName
  def seasonNumber = _season
  def episodeNumber = _episode
  def showId = _showId

  override def equals(that:Any) = that match {
    case other: Episode => showId == other.showId && seasonNumber == other.seasonNumber && episodeNumber == other.episodeNumber
    case _ => false
  }

  override def hashCode = _season * 100 + _episode * 10 + _showId

  override def toString = searchString
}
