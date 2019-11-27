class Playlist
  attr_reader :id, :user_id, :song_ids

  def initialize(playlist_hash)
    @id = playlist_hash["id"]
    @user_id = playlist_hash["user_id"]
    @song_ids = playlist_hash["song_ids"]
  end

  def to_hash
    return {"id" => @id, "user_id" => @user_id, "song_ids" => @song_ids}
  end

  def add(song_id)
    # don't append song_id if already in playlists' song_ids
    if @song_ids.include?(song_id)
      return
    end
    @song_ids.append(song_id)
  end

end