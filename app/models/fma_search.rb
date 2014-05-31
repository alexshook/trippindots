class FMASearch

  def self.get_fma_url(echonest_id)
    @audio_url = HTTParty.get("http://freemusicarchive.org/api/get/tracks.json?api_key=#{ENV['FMA_KEY']}&track_id=#{echonest_id}")


  end

end
