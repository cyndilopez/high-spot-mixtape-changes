class Song
  attr_reader :id, :artist, :title

  def initialize(song_hash)
    @id = song_hash["id"]
    @artist = song_hash["artist"]
    @title = song_hash["title"]
  end

  def to_hash
    return {"id" => @id, "artist" => @artist, "title" => @title}
  end

end