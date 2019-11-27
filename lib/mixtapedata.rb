require_relative 'song'
require_relative 'user'
require_relative 'playlist'
require_relative 'update_playlist'
require_relative 'add_playlist'
require 'json'

class MixTapeData

  attr_reader :songs, :users, :playlists

  def initialize(input_filename)
    @songs = {}
    @users = {}
    @playlists = {}
    @mixtape_hash = parse_file(input_filename)
  end

  def parse_file(filepath)
    file = File.read(filepath)
    data_hash = JSON.parse(file)

    data_hash["songs"].each do |song_hash|
      @songs[song_hash["id"]] = Song.new(song_hash)
    end

    data_hash["playlists"].each do |playlist_hash|
      @playlists[playlist_hash["id"]] = Playlist.new(playlist_hash)
    end

    data_hash["users"].each do |user_hash|
      @users[user_hash["id"]] = User.new(user_hash)
    end
  end

  def save_file(output_filepath)
    output_file = File.open(output_filepath, "w")
    output_file.write(to_json)
    output_file.close
  end

  def to_json
    return {
      "users"=>@users.map { |id, user| user.to_hash},
      "playlists"=>@playlists.map { |id, playlist|playlist.to_hash},
      "songs"=>@songs.map { |id, song| song.to_hash}
    }.to_json
  end

  def apply_changes(changes_filepath)
    file = File.read(changes_filepath)
    changes_hash = JSON.parse(file)
    apply_action(changes_hash)
  end

  def apply_action(changes_hash)
    changes_hash.each do |action, actions|
      case action
      when "update"
        update(actions)
      when "add"
        add(actions)

      # when "delete"
      #   delete(action_hash)
      end


    end
  end

  def update(actions)
    actions.each do |action_hash|
      up = UpdatePlaylist.new(action_hash)
      if !up.valid?(self.songs, self.playlists)
        puts "Skipping update playlist id #{up.playlist_id} with song id #{up.song_id}"
        return
      else
        up.apply_update(self.playlists)
      end
    end
  end

  def add(actions)
    actions.each do |action_hash|
      add = AddPlaylist.new(action_hash)
      if !add.valid?(self.songs, self.users)
        puts "Skipping add playlist with song ids #{add.song_ids} and user id #{add.user_id}"
        return
      else
        add.apply_add(self.playlists)
      end
    end
  end

end


