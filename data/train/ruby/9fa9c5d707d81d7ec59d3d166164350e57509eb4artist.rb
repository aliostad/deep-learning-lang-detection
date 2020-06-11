module ClassMethods

  def getCorrection(args)
    args[:method] = 'artist.getCorrection'
    args[:api_key] = @api_key[:api_key]
    query(args)
  end

  def getEvents(args)
    args[:method] = 'artist.getEvents'
    args[:api_key] = @api_key[:api_key]
    query(args)
  end

  def getInfo(args)
    args[:method] = 'artist.getInfo'
    args[:api_key] = @api_key[:api_key]
    query(args)
  end

  def getPastEvents(args)
    args[:method] = 'artist.getPastEvents'
    args[:api_key] = @api_key[:api_key]
    query(args)
  end

  def getPodcast(args)
    args[:method] = 'artist.getPodcast'
    args[:api_key] = @api_key[:api_key]
    query(args)
  end

  def getShouts(args)
    args[:method] = 'artist.getShouts'
    args[:api_key] = @api_key[:api_key]
    query(args)
  end

  def getSimilar(args)
    args[:method] = 'artist.getSimilar'
    args[:api_key] = @api_key[:api_key]
    query(args)
  end

  def getTags(args)
    args[:method] = 'artist.getTags'
    args[:api_key] = @api_key[:api_key]
    query(args)
  end

  def getTopAlbums(args)
    args[:method] = 'artist.getTopAlbums'
    args[:api_key] = @api_key[:api_key]
    query(args)
  end

  def getTopFans(args)
    args[:method] = 'artist.getTopAlbums'
    args[:api_key] = @api_key[:api_key]
    query(args)
  end

  def getTopTags(args)
    args[:method] = 'artist.getTopTags'
    args[:api_key] = @api_key[:api_key]
    query(args)
  end

  def getTopTracks(args)
    args[:method] = 'artist.getTopTracks'
    args[:api_key] = @api_key[:api_key]
    query(args)
  end

  def search(args)
    args[:method] = 'artist.search'
    args[:api_key] = @api_key[:api_key]
    query(args)
  end

  # To implement: require authentication
  # Artist.addTags
  # Artist.removeTag
  # Artist.share
  # Artist.shout

end

class Artist < LastFm
  include ClassMethods

  def initialize(args)
    @api_key = args[:api_key]
  end

end