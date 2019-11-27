require_relative 'song'
require_relative 'user'
require_relative 'playlist'
require_relative 'update_playlist'
require_relative 'add_playlist'
require_relative 'remove_playlist'
require 'json'

class CustomError < StandardError
end

class MixTapeData

  attr_reader :songs, :users, :playlists

  def initialize(input_filename)
    @songs = {}
    @users = {}
    @playlists = {}
    parse_file(input_filename)
  end

  def parse_file(filepath)
    begin
      file = File.read(filepath)
      data_hash = JSON.parse(file)
    rescue Errno::ENOENT
      raise CustomError.new("Cannot read file")
    rescue JSON::ParserError
      raise CustomError.new("Cannot parse file #{filepath} - empty or invalid JSON format")
    end

    valid_structure?(data_hash, "songs")
    valid_structure?(data_hash, "playlists")
    valid_structure?(data_hash, "users")

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

  def valid_structure?(data_hash, field)
    if !data_hash[field] || !(data_hash[field].is_a?(Array)) || !(data_hash[field].length > 0)
      raise CustomError.new("#{field} values missing, empty, or not of type array")
    end
  end

  def save_file(output_filepath)
    begin
    output_file = File.open(output_filepath, "w")
    rescue Errno::ENOENT
      raise CustomError.new("Cannot open file #{output_filepath} for writing")
    end

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
    begin
      file = File.read(changes_filepath)
      changes_hash = JSON.parse(file)
    rescue Errno::ENOENT
      raise CustomError.new("Cannot read file #{changes_filepath}")
    rescue JSON::ParserError
      raise CustomError.new("Cannot parse file #{changes_filepath} - empty or invalid JSON format")
    end

    apply_action(changes_hash)
  end

  def apply_action(changes_hash)
    changes_hash.each do |action, details|
      case action
      when "update"
        update(details)
      when "add"
        add(details)
      when "remove"
        remove(details)
      end
    end
  end

  def update(details)
    details.each do |detail_hash|
      up = UpdatePlaylist.new(detail_hash)
      if !up.valid?(self.songs, self.playlists)
        puts "Skipping update playlist id #{up.playlist_id} with song id #{up.song_id}"
        return
      else
        up.apply_update(self.playlists)
      end
    end
  end

  def add(details)
    details.each do |detail_hash|
      add = AddPlaylist.new(detail_hash)
      if !add.valid?(self.songs, self.users)
        puts "Skipping add playlist with song ids #{add.song_ids} and user id #{add.user_id}"
        return
      else
        add.apply_add(self.playlists)
      end
    end
  end

  def remove(details)
    details.each do |id|
      rem = RemovePlaylist.new(id)
      if !rem.valid?(self.playlists)
        puts "Skipping remove playlist with id #{id}"
        return
      else
        rem.apply_remove(self.playlists)
      end
    end
  end
end


