require "playlist.rb"

describe "Playlist class" do
  before(:each) do
    @playlist_hash = {"id"=>"1", "user_id"=>"2", "song_ids"=>["1"]}
    @playlist = Playlist.new(@playlist_hash)
  end

  it "initializes a playlist" do
    expect(@playlist).to be_kind_of Playlist
  end

  it "to_hash converts Playlist object to hash" do
    expect(@playlist.to_hash).to eq @playlist_hash
  end

  it "adds songs to song_ids" do
    expect{@playlist.add("2")}.to change {@playlist.song_ids.length}.by(1)
  end

  it "doesn't add songs to song_ids if song_ids already contains song" do
    expect{@playlist.add("1")}.to change {@playlist.song_ids.length}.by(0)
  end

end