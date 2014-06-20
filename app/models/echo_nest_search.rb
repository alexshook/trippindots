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

  def self.analyze_song(url)
    post_response = HTTParty.post("http://developer.echonest.com/api/v4/track/upload?api_key=#{ENV['ECHONEST_KEY']}&url=#{url}",
                                  headers: { 'Content-Type' => 'multipart/form-data' })
    artist = post_response['track']['artist']
    song = post_response['track']['title']
    echonest_id = post_response['track']['id']
    get_response = HTTParty.get("http://developer.echonest.com/api/v4/track/profile?api_key=#{ENV['ECHONEST_KEY']}&format=json&id=#{echonest_id}&bucket=audio_summary")
    analysis_url = get_response['response']['track']['audio_summary']['analysis_url']
    data = HTTParty.get(analysis_url)
    {artist: artist, song: song, meta_data: data}
  end

end
