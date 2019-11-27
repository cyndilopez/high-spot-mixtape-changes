require 'mixtapedata.rb'

describe "Mixtape class" do
  before(:each) do
    filename = 'spec/test-mixtape-data.json'
    @mixtapedata = MixTapeData.new(filename)
  end

  it "can read songs" do
    expect(@mixtapedata.songs.length).to be > 0
    expect(@mixtapedata.songs["8"]).not_to be_nil
    expect(@mixtapedata.songs["8"].title).to eq "Never Be the Same"
  end

  it "can read playlist" do
    expect(@mixtapedata.playlists.length).to be > 0
    expect(@mixtapedata.playlists["1"]).not_to be_nil
    expect(@mixtapedata.playlists["1"].user_id).to eq "2"
  end

  it "can read users" do
    expect(@mixtapedata.users.length).to be > 0
    expect(@mixtapedata.users["2"]).not_to be_nil
    expect(@mixtapedata.users["2"].name).to eq "Albin Jaye"
  end

  it "throws an error when file doesn't exist" do
    expect{@mixtapedata.parse_file('invalid-file.rb')}.to raise_error(CustomError, /Cannot read file/)
  end

  it "throws an error if file is empty" do
    expect{MixTapeData.new('spec/test-empty-mixtape-data.json')}.to raise_error(CustomError, /Cannot parse file/)
  end

  it "throws an error if file is not valid json" do
    expect{MixTapeData.new('spec/test-invalid-mixtape-data.json')
  }.to raise_error(CustomError, /Cannot parse file/)
  end

  it "throws an error if \"playlists\" isn't in mixtapes json" do
    data_hash = {
      "songs"=>
        [
          {
            "id"=>"1",
            "user_id"=>"2",
            "song_ids"=>[
              "8",
              "32"
            ]
          }
        ]
      }
    expect{
      @mixtapedata.valid_structure?(data_hash, "playlists")}.to raise_error(CustomError, /values missing/)
  end

  it "throws an error if \"playlists\" isn't an array in mixtape json" do
    data_hash = {
      "playlists"=>
          {
            "id"=>"1",
            "user_id"=>"2",
            "song_ids"=>[
              "8",
              "32"
            ]
          }
      }
    expect{@mixtapedata.valid_structure?(data_hash, "playlists")}.to raise_error(CustomError, /values missing/)
  end

  it "throws an error if \"playlists\" array is empty" do
    data_hash = {
      "playlists"=>[]
      }
    expect{@mixtapedata.valid_structure?(data_hash, "playlists")}.to raise_error(CustomError, /values missing/)
  end

  it "saves file" do
    output_file = "spec/output-test.json"
    @mixtapedata.save_file(output_file)
    parsed_output_data = JSON.parse(File.read(output_file))
    expected_output_data = {
      "users"=>[
        {
          "id"=>"2",
          "name"=>"Albin Jaye"
        }
      ],
      "playlists"=>[
        {
          "id"=>"1",
          "user_id"=>"2",
          "song_ids"=>[
            "8"
          ]
        },
        {
          "id"=>"2",
          "user_id"=>"2",
          "song_ids"=>[
            "32"
          ]
        }
      ],
      "songs"=>[
        {
          "id"=>"8",
          "artist"=>"Camila Cabello",
          "title"=>"Never Be the Same"
        },
        {
          "id"=>"32",
          "artist"=>"sZedd",
          "title"=>"The Middle"
        }
      ]
    }
    expect(parsed_output_data).to eq (expected_output_data)
  end

  it "updates playlists" do
    # testing apply_action and update
    @mixtapedata.apply_changes('spec/test-changes-valid.json')
    expect(@mixtapedata.playlists["1"].song_ids).to include("32")
  end

  it "doesn't update playlist if invalid params in changes file (song id in changes file doesn't exist)" do
    # testing apply_action and update
    expect do
      @mixtapedata.apply_changes('spec/test-changes-invalid-update.json')
    end.to output("Skipping update playlist id 1 with song id 41\n").to_stdout
  end

  it "adds a playlist" do
    details = [
      {
        "songs"=> [
          "32"
        ],
        "user"=> "2"
      }
    ]
    expect{@mixtapedata.add(details)}.to change{@mixtapedata.playlists.length}.by(1)
  end

  it "doesn't add a playlist if existing user or song id not provided" do
    filename = 'spec/test-mixtape-data.json'
    @mixtapedata = MixTapeData.new(filename)
    details = [
      {
        "songs"=> [
          "100"
        ],
        "user"=> "3"
      }
    ]
    expect do
      @mixtapedata.add(details)
    end.to output("Skipping add playlist with song ids [\"100\"] and user id 3\n").to_stdout
  end

  it "removes a playlist" do
    expect{@mixtapedata.remove(["1"])}.to change{@mixtapedata.playlists.length}.by(-1)
  end

  it "doesn't remove a playlist if the playlist id doesn't exist" do
    expect do
      @mixtapedata.remove(["10"])
    end.to output("Skipping remove playlist with id 10\n").to_stdout
  end
end





