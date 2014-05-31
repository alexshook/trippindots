class EchoNestSearch

  def self.get_echonest_data(song_title)
      analysis = HTTParty.get("http://developer.echonest.com/api/v4/song/search?api_key=#{ENV['ECHONEST_KEY']}&format=json&results=1&title=#{song_title}&bucket=audio_summary&bucket=id:fma&bucket=tracks")
      analysis_url = analysis["response"]["songs"].first["audio_summary"]["analysis_url"]
      artist_name = analysis["response"]["songs"].first["artist_name"].gsub!(' ', '+')
       song_data = HTTParty.get(analysis_url)
       return response_data = [artist_name, song_data]
  end


end






