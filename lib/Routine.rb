class Routine

  def initialize
    @db = []
    @quit = false
  end

  def run_sequence
    messages('run-sequence')
    command_get
    command_process(@command)
    run_sequence if @quit == false
  end

  def command_get
    print "> "
    input = gets.downcase.strip
    @command = input.split(/\s(?=(?:[^'"]|'[^']*'|"[^"]*")*$)/).select { |s| not s.empty? }.map { |s| s.gsub(/(^ +)|( +$)|(^["']+)|(["']+$)/,'') }
    repeat_input if @command.length == 0 or @command.length > 4
  end  

  def command_process(command)
    if command[0] == "quit" || command[0] == "exit"
      quit
    elsif command[0] == "show" && command[1] == "all" && command[2] == "by"
      show_all_by_artist(command[3])
      run_sequence
    elsif command[0] == "show" && command[1] == "all"
      show_all
      run_sequence
    elsif command[0] == "show" && command[1] == "unplayed" && command[2] == "by"
      show_unplayed_by(command[3])  
    elsif command[0] == "show" && command[1] == "unplayed"
      show_unplayed
    elsif command[0] == "help"
      help
      run_sequence
    elsif command[0] == "play"
      play_song(command[1])
      run_sequence
    elsif command[0] == "add"
      add_song(command[1], command[2])
      run_sequence
    else
      repeat_input 
    end
  end

  def add_song(title, artist)
    if @db.find_all { |song| song[:title] == title.downcase }.count > 0
      messages('duplicate')
    else
      song = { artist: artist, title: title, played: false }
      @db << song
      messages('add-song', { artist: artist, title: title })  
    end  
  end

  def play_song(title)
    messages('play-song', title)
    sleep_dots
    song_id = @db.index { |s| s[:title] == title }
    song = @db[song_id]
    song[:played] = true
    messages('played-song', { artist: song[:artist], title: song[:title] })
  end

  def show_all
    messages('show-all')
    list_songs(@db)
  end

  def show_all_by_artist(artist)
    messages('show-all-by', artist)
    songs = @db.find_all { |song| song[:artist] == artist }
    list_songs(songs)
  end

  def show_unplayed
    messages('show-unplayed')
    songs = @db.find_all { |song| song[:played] == false }
    list_songs(songs)
  end

  def show_unplayed_by(artist)
    messages('show-unplayed-by-artist', artist)
    songs = @db.find_all { |song| song[:artist] == artist && song[:played] == false }
    list_songs(songs)
  end

  def quit
    messages('quit')
    @quit = true
  end

  private

  def repeat_input
    messages('repeat-input')
    run_sequence
  end

  def sleep_dots
    5.times { print '.'; sleep 0.5 }
  end

  def list_songs(songs)
    if songs.length == 0
      messages('no-songs')
    else  
      songs.each do |song|
        puts ":: #{song[:title].capitalize} by #{song[:artist].capitalize} | played: #{song[:played]}"
      end
    end  
  end 

  def messages(message, arg=nil)
    case message
      when 'duplicate' then puts "\nSorry, the song you're trying to add already exists."
      when 'no-songs' then puts "\nSorry, there are no songs currently in the database."
      when 'run-sequence' then puts "\nEnter 'help' for a list of commands."
      when 'repeat-input' then puts "Sorry, I don't understand your command, please try entering it again."
      when 'quit' then puts "Exiting, goodbye.."
      when 'add-song' then puts "Added #{arg[:title].capitalize} by #{arg[:artist].capitalize}."
      when 'play-song' then puts "\nPlaying: #{arg}..."
      when 'played-song' then puts "\nPlayed: #{arg[:title].capitalize} by #{arg[:artist].capitalize}."
      when 'show-all' then puts "\nHere's a list of all your songs:"
      when 'show-all-by' then puts "\nHere's a list of all your songs by #{arg}:"
      when 'show-unplayed' then puts "\nHere's a list of all your unplayed songs:"
      when 'show-unplayed-by-artist' then puts "\nHere's a list of all your unplayed songs by #{arg}:"
    end  
  end

  def help
    puts 'add "title" "artist": adds an album to the collection with the given title and artist. All albums are unplayed by default.'
    puts 'play "title": marks a given album as played. show all: displays all of the albums in the collection.'
    puts 'show all: shows all albums in the collection.'
    puts 'show all by "artist": shows all of the albums in the collection by the given artist.'
    puts 'show unplayed: display all of the albums that are unplayed.'
    puts 'show unplayed by "artist": shows the unplayed albums in the collection by the given artist.'
    puts 'quit: quits the program.'
  end

end


