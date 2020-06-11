# Infers musical genre for a given artist, based on the artist's name,
# peers played with, and venues played at.
class Artist::DerivedGenreCalculator
  attr_accessor :artist, :points_by_genre, :points_by_genre_name_and_point_type

  delegate :name,
           :genre_taggings,
           :played_with,
           :venues,
           :genre_util,
           to: :artist

  delegate :calculate_name_embedded_points,
           to: :genre_util

  def initialize(artist)
    @artist = artist
    @genre_points = Hash.new(0.0)
  end

  # Derived genre, rather than tagged
  def calculate_genre
    calculate_name_embedded_points +
    calculate_points_from_peers
  end

  def calculate_points_from_peers
    played_with.to_a.sum([]) do |peer|
      calculate_points_from_peer(peer)
    end
  end

  def calculate_points_from_peer(peer)
    calculate_peer_self_tagged_points(peer) +
    calculate_peer_user_tagged_points(peer) +
    calculate_peer_name_embedded_points(peer)
  end

  def calculate_peer_self_tagged_points(peer)
    peer.self_tagged_genre_points.map { |gp|
      {point_type: 'peer_self_tag', genre_name: gp.genre_name, value: 1.0, source: peer}
    }
  end

  # Peer's user-tagged genre
  def calculate_peer_user_tagged_points(peer)
    peer.user_tagged_genre_points.map { |p|
      {point_type: 'peer_user_tag', genre_name: p.genre_name, value: 0.5, source: peer}
    }
  end

  # Peer's name-embedded genre
  def calculate_peer_name_embedded_points(peer)
    self.class.new(peer).calculate_name_embedded_points.map { |p|
      {point_type: 'peer_name', genre_name: p[:genre_name], value: 0.25, source: peer}
    }
  end
end
