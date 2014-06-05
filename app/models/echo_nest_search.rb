class EchoNestSearch

  def self.get_echonest_data(song_title, artist_name)
    analysis = HTTParty.get("http://developer.echonest.com/api/v4/song/search?api_key=#{ENV['ECHONEST_KEY']}&format=json&results=1&title=#{song_title}&artist=#{artist_name}&bucket=audio_summary&bucket=id:fma&bucket=tracks")
    if analysis["response"]["songs"].empty?
      {artist: 'trippinDots error', song: 'trippinDots error', meta_data: 'trippinDots error'}
    else
      analysis_url = analysis["response"]["songs"].first["audio_summary"]["analysis_url"]
      song = analysis["response"]["songs"].first["title"]
      artist = analysis["response"]["songs"].first["artist_name"].gsub!(' ', '+')
      data = HTTParty.get(analysis_url)
      {artist: artist, song: song, meta_data: data}
    end
  end
end






