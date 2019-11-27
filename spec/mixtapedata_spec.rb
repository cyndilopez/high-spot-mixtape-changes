require 'mixtapedata.rb'
require 'song.rb'
require 'user.rb'
require 'playlist.rb'
require 'update_playlist.rb'
require 'add_playlist.rb'
require 'json'

describe "Mixtape class" do
  before(:each) do
    filename = 'spec/test-mixtape-data.json'
    @mixtapedata = MixTapeData.new(filename)
  end

  it "can read songs" do
    expect(@mixtapedata.songs.length).to be > 0
    expect(@mixtapedata.songs["5"]).not_to be_nil
    expect(@mixtapedata.songs["5"].title).to eq "Meant to Be"

  end

  it "can read playlist" do
    expect(@mixtapedata.playlists.length).to be > 0
    expect(@mixtapedata.playlists["2"]).not_to be_nil
    expect(@mixtapedata.playlists["2"].user_id).to eq "3"
  end

  it "can read users" do
    expect(@mixtapedata.users.length).to be > 0
    expect(@mixtapedata.users["2"]).not_to be_nil
    expect(@mixtapedata.users["2"].name).to eq "Dipika Crescentia"
  end

  it "throws an error when file doesn't exist" do
    expect{@mixtapedata.parse_file('invalid-file.rb')}.to raise_error(Errno::ENOENT)
  end

  it "throws an error if file is empty" do
    expect{MixTapeData.new('spec/test-empty-mixtape-data.json')}.to raise_error(JSON::ParserError) # improve with error message
  end

  it "throws an error if file is not valid json" do
    expect{MixTapeData.new('spec/test-invalid-mixtape-data.json')
  }.to raise_error(JSON::ParserError, /unexpected token/)
  end

  # make input file simpler can perform string match
  it "saves file" do
    output_file = "output-test.json"
    @mixtapedata.save_file(output_file)
    parsed_output_data = JSON.parse(File.read(output_file))
    #expect statement here
  end

  it "updates playlists" do
    @mixtapedata.apply_changes('spec/test-changes-valid.json')
    expect(@mixtapedata.playlists["2"].song_ids).to include("1")
  end

  it "doesn't update playlist if invalid params in changes file (song id in changes file doesn't exist)" do
    expect do
      @mixtapedata.apply_changes('spec/test-changes-invalid-update.json')
    end.to output("Skipping update playlist id 2 with song id 41\n").to_stdout
  end

  it "adds a playlist" do
    details = [
      {
        "songs"=> [
          "2"
        ],
        "user"=> "2"
      }
    ]
    expect{@mixtapedata.add(details)}.to change{@mixtapedata.playlists.length}.by(1)
  end
end
# describe "new block" do
#   it "doesn't add a playlist if existing user or song id not provided" do
#     filename = 'spec/test-mixtape-data.json'
#     @mixtapedata = MixTapeData.new(filename)
#     details2 = [
#       {
#         "songs"=> [
#           "100"
#         ],
#         "user"=> "3"
#       }
#     ]
#     p details2
#     expect do
#       @mixtapedata.add(details2)
#     end.to output("Skipping add playlist with song ids [100] and user id 2\n").to_stdout
#   end



end


