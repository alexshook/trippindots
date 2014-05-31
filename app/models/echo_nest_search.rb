class EchoNestSearch

  def self.get_echonest_data(song_title)
      analysis_url = HTTParty.get("http://developer.echonest.com/api/v4/song/search?api_key=#{ENV['ECHONEST_KEY']}&format=json&results=1&title=#{song_title}&bucket=id:7digital-US&bucket=audio_summary&bucket=tracks")["response"]["songs"].first["audio_summary"]["analysis_url"]

       @song_data = HTTParty.get(analysis_url)
  end


end






