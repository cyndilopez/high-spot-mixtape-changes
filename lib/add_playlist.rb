require_relative 'playlist'

class AddPlaylist

  attr_reader :song_id, :user_id

  def initialize(add_hash)
    @user_id = add_hash["user"]
    @song_ids = add_hash["songs"]
    p @song_ids
  end

  def valid?(songs, users)
    # make sure songs exist, and userid
    @song_ids.each do |song_id|
      p song_id
      if !songs[song_id] && !users[@user_id]
        p "here"
        return false

      end
    end
    return true
  end

  def apply_add(playlists)
    playlist_id = get_id(playlists)
    playlists[playlist_id]=Playlist.new(to_hash(playlist_id))
  end

  def get_id(playlists)
    return ((playlists.max_by { |id| id })[0].to_i + 1).to_s
  end

  def to_hash(id)
    return {"id"=>id, "user_id"=>@user_id, "song_ids"=>@song_ids}
  end

end