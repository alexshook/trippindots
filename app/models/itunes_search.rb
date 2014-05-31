class ItunesSearch

  def self.get_itunes_url(artist, title)
    @itunes_url = JSON.parse(HTTParty.get("http://itunes.apple.com/search?term=#{artist}+#{title}&entity=song"))["results"][0]["previewUrl"]
  end

end
