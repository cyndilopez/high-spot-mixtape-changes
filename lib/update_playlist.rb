class UpdatePlaylist

  attr_reader :song_id, :playlist_id

  def initialize(update_hash)
    @song_id = update_hash["song"]
    @playlist_id = update_hash["playlist"]
  end

  def valid?(songs, playlists)
    if songs[@song_id] && playlists[@playlist_id]
      return true
    end
    return false
  end

  def apply_update(playlists)
    playlists[@playlist_id].add(@song_id)
  end

end