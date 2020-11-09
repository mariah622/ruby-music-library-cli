require "pry"
class MusicLibraryController
  attr_accessor :path

  def initialize(path = './db/mp3s')
    MusicImporter.new(path).import
  end

  def call
    user_input = nil

    while user_input != "exit"
      puts "Welcome to your music library!"
      puts "To list all of your songs, enter 'list songs'."
      puts "To list all of the artists in your library, enter 'list artists'."
      puts "To list all of the genres in your library, enter 'list genres'."
      puts "To list all of the songs by a particular artist, enter 'list artist'."
      puts "To list all of the songs of a particular genre, enter 'list genre'."
      puts "To play a song, enter 'play song'."
      puts "To quit, type 'exit'."
      puts "What would you like to do?"

      user_input = gets.chomp()

      case user_input

      when "list songs"
        self.list_songs
      when "list artists"
        self.list_artists
      when "list genres"
        self.list_genres
      when "list artist"
        self.list_songs_by_artist
      when 'list genre'
        self.list_songs_by_genre
      when "play song"
        self.play_song
      end
    end
  end

  def list_songs
    Song.all.sort {|a,b | a.name <=> b.name}.each.with_index(1) do |value, index| 
      puts "#{index}. #{value.artist.name} - #{value.name} - #{value.genre.name}"
    end
  end

  def list_artists
    Artist.all.sort{|a,b | a.name <=> b.name}.each.with_index(1) do |value, index| 
      puts "#{index}. #{value.name}"
    end
  end

  def list_genres
    Genre.all.sort{|a,b | a.name <=> b.name}.each.with_index(1) do |value, index| 
      puts "#{index}. #{value.name}"
    end
  end

  def list_songs_by_artist
    puts "Please enter the name of an artist:"
    user_input = gets.chomp()

    if artist = Artist.find_by_name(user_input)
      artist.songs.sort{|a,b | a.name <=> b.name}.each.with_index(1) do |value, index|
        puts "#{index}. #{value.name} - #{value.genre.name}"
      end
    end
  end

  def list_songs_by_genre
    puts "Please enter the name of a genre:"
    user_input = gets.chomp()
    if genre = Genre.find_by_name(user_input)
      genre.songs.sort{|a,b | a.name <=> b.name}.each.with_index(1) do |value, index|
        puts "#{index}. #{value.artist.name} - #{value.name}"
      end
    end
  end

  def play_song
    puts "Which song number would you like to play?"

    user_input = gets.chomp().to_i
    if (1..Song.all.count).include?(user_input)
      song = Song.all.sort{ |a, b| a.name <=> b.name }[user_input - 1] 
    end
    puts "Playing #{song.name} by #{song.artist.name}" if song
  end

end 