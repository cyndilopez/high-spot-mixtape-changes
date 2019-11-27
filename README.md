# High Spot Mixtape Changes Challenge

## Requirements
This code has been run and tested on Ruby 2.5.5

## Installation
Clone this project:
```
$ git clone https://github.com/cyndilopez/high-spot-mixtape-changes.git
```
Install dependencies

```
$ bundle install
```

## Tests
Tests are written using RSpec. To run tests, in root of folder directory use:

```
$ rspec
```

If this doesn't work, try:

```
$ bundle exec rspec
```


## How to use

In root of folder directory, use:

```
$ ruby lib/main.rb <mixtapes_filepath.json> <changes_filepath.json> <output_filepath.json>
```

An example mixtapes file, changes file, and output file are provided for reference.

The application can be run using the examples in the root folder, just use:

```
$ ruby lib/main.rb example-mixtapes.json example-changes.json example-output.json
```

**Mixtapes filepath**
This is the path to a mixtapes JSON with "users", "playlists", and "songs" fields.
These fields should have the following parameters:

users: id, name
playlists: id, user_id, song_ids
song: id, artist, title

The JSON should match this format:
```
{
  "users": [
    {
      "id": "1",
      "name": "Albin Jaye"
    },
    {
      "id": "2",
      "name": "Dipika Crescentia"
    }
  ],
  "playlists": [
    {
      "id": "1",
      "user_id": "2",
      "song_ids": [
        "1",
        "2"
      ]
    }
  ],
  "songs": [
    {
      "id": "1",
      "artist": "Camila Cabello",
      "title": "Never Be the Same"
    },
    {
      "id": "2",
      "artist": "Zedd",
      "title": "The Middle"
    }
  ]
}

```
Note: song and user objects that are referenced by playlists must be included in the mixtapes JSON.

**Changes filepath**
The changes filepath is the filepath to the file containing the changes you wish to apply to the mixtapes JSON. The JSON can take three fields which represent playlist actions: "add", "update", and "delete".

The **add** action adds a playlist to the current list of playlists and should be in the following format:

```
{
  "add": [
    {
      "songs": ["2"],
      "user": "2"
    }
  ]
}
```

The value of "add" is an array of objects, which each contain "song" and "user", where "songs" is an array of existing song ids, and the value of "user" is an existing user id. Multiple playlists can be added in this way.

In the above example, a playlist is created with "song_ids" that include the song with id of "2" and user with id of "2".

The **update** action adds an existing song to an existing should be in the following format:

```
{
  "update": [
    {
      "playlist": "2",
      "song": "1"
    }
  ]
}
```

Update takes in an array of objects, which each contain "playlist" and "song" In this example, the song with song id, "1", will be added to playlists' current value of "song_ids". Because "update" takes an array, multiple playlists can be updated.

The **remove** action removes a playlist and should be in the following format:

```
{
  "remove": [
    "1"
  ]
}
```

Remove takes an array of playlist ids. In this example, playlist with id "1" is removed from the user provided mixtapes JSON.

A JSON incorporating all types of changes can be provided as followed:

```
{
  "update": [
    {
      "playlist": "2",
      "song": "1"
    }
  ],
  "add": [
    {
      "song": "2",
      "user": "2"
    }
  ],
  "remove": [
    "3"
  ]
}
```

**Output filepath**
The file with the changes applied to mixtapes will be saved in this filepath.

## Scale this application
How to handle very large input files and/or very large changes files?

@cyndilopez