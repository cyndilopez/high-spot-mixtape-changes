class RemovePlaylist

  attr_reader :playlist_id

  def initialize(id)
    @playlist_id = id
  end

  def valid?(playlists)
    if playlists[@playlist_id]
      return true
    end
    return false
  end

  def apply_remove(playlists)
    playlists.delete(playlist_id)
  end

end