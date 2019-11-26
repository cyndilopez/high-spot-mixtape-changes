class Playlist
  attr_reader :id, :user_id, :song_ids

  def initialize(id:, user_id:, song_ids:)
    @id = id
    @user_id = user_id
    @song_ids = song_ids
  end

end