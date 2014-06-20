class EchoNestSearch

  def self.analyze_song(url)
    post_response = HTTParty.post("http://developer.echonest.com/api/v4/track/upload?api_key=#{ENV['ECHONEST_KEY']}&url=#{url}",
                                  headers: { 'Content-Type' => 'multipart/form-data' })
    artist = post_response['response']['track']['artist']
    song = post_response['response']['track']['title']
    echonest_id = post_response['response']['track']['id']
    sleep(1)
    get_response = HTTParty.get("http://developer.echonest.com/api/v4/track/profile?api_key=#{ENV['ECHONEST_KEY']}&format=json&id=#{echonest_id}&bucket=audio_summary")
    analysis_url = get_response['response']['track']['audio_summary']['analysis_url']
    data = HTTParty.get(analysis_url)
    { artist: artist, song: song, meta_data: data }
  end

end
