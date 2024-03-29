# Highspot Mixtape Changes Challenge

## Description
This application takes in a mixtapes JSON file, a changes JSON file, and an output JSON file. The changes JSON file describes changes to make to the mixtapes JSON file. The resulting file is output to an output filepath that the user provides. The format for these files is described in the 'How to Use' section below.

## Requirements
This code has been run and tested on Ruby 2.5.5 and a Mac<br>
bundler v 2.0.2 is needed to install dependencies

## Installation
Clone this project:
```
$ git clone https://github.com/cyndilopez/high-spot-mixtape-changes.git
```
Install dependencies

```
$ bundle install
```

If this throws a "can't find gem bundler with executable bundle (Gem::GemNotFoundException)" error, install bundler version 2.0.2

```
gem install bundler -v 2.0.2
```
then
```
bundle install
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

This program follows linux style where:
1. If it succeeds, it simply writes the output file
2. If an error occurs, it prints an error message to standard output

## How to use

In root of folder directory, use:

```
$ ruby main.rb <mixtapes_filepath.json> <changes_filepath.json> <output_filepath.json>
```
Fill the words in brackets with your own custom filenames.

An example mixtapes file, changes file, and output file are provided for reference.
The application can be run using the examples in the root folder, just use:

```
$ ruby main.rb example-mixtapes.json example-changes.json example-output.json
```
Open ```example-output.json```, save(```Command-S```) to format prettily, and check that changes have been applied

**Format of mixtapes file**<br>
This is a JSON with "users", "playlists", and "songs" fields.
These fields should have the following parameters:

-users: id, name
-playlists: id, user_id, song_ids
-song: id, artist, title

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

*Error handling* - If any of the fields: "songs", "playlists", "users" is missing, or if the fields' values are empty arrays or not of type array, then the program stops running and sends a custom error message to the user

**Format of changes file**<br>
The changes file is a JSON containing the changes you wish to apply to the mixtapes JSON. The JSON can take three fields which represent **playlist** actions: "add", "update", and "delete".

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

In the above example, a playlist is created with "song_ids" that include the song id "2" and user id "2".

*Error handling* - If a song id or user id provided do not exist in the mixtapes JSON, a message "Skipping add playlist with song ids $song_ids and user id $user_id will be printed to standard output

The **update** action adds an existing song to an existing playlist and should be in the following format:

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

Update takes in an array of objects, which each contain "playlist" and "song" fields. In this example, the song with song id, "1", will be added to playlists' current value of "song_ids". Because "update" takes an array, multiple playlists can be updated with songs.

*Error handling* - If a song with song id or playlist with playlist id do not exist in the mixtapes JSON, a message "Skipping update playlist id $playlist_id with song id $song_id" will be printed to standard output

The **remove** action removes a playlist and should be in the following format:

```
{
  "remove": [
    "1"
  ]
}
```

Remove takes an array of playlist ids and removes all playlists with these playlist ids. In this example, playlist with id "1" is removed from mixtapes JSON.

*Error handling* - If the playlist id provided does not exist in the mixtapes JSON, a message "Skipping remove playlist with id $id" will be printed to standard output

An example JSON object incorporating all possible changes is:

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

**Output file**<br>
The file with the changes applied to mixtapes will be saved in this file. It uses the same format as mixtapes.JSON.

## Scale this application
How to handle very large input files and/or very large changes files -
There are two issues that can arise with large files: memory and efficiency. The application could possibly run out of memory when reading the file. To solve for memory issues, a method, File.each in Ruby, can be leveraged. This method reads line by line, which means not all lines are loaded into memory at the same time. The JSON data could be stored in a database as it's being read. A changes file would be read (also line by line) and changes applied to the database after the database is created. Data would be taken from the database to produce the output file.

To make the process faster, multiple hosts could be used to read the input file and fill the database, and multiple hosts used to apply changes from the changes file to the database, like this:
```
        DATABASE
        /  |   \
       /   |    \
   HOST1 HOST2  HOSTn
```

@cyndilopez