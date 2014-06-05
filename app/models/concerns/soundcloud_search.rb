class SoundcloudSearch
  def self.search_songs(songname, artistname)
    search = songname + "+" + artistname
    songs = SoundCloud.new(:client_id => "#{ENV['SOUNDCLOUD_CLIENT_ID']}").get('/tracks', :q => search)

    songs_array = []
    songs.each do |song|
      if (song[:title].include?(artistname.gsub('+', ' ').titleize) == true) && (song[:streamable] == true) && (song[:track_type] != "remix")
        songs_array << song
      end
    end
    soundcloud_song = songs_array[0]
    return { soundcloud_song: soundcloud_song }
  end

end

