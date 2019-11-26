class Song
  attr_reader :id, :artist, :title

  def initialize(id:,artist:,title:)
    @id = id
    @artist = artist
    @title = title
  end

end