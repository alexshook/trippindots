class SoundcloudSearch
  def self.search_songs(songname, artistname)
    results = SoundCloud.new(:client_id = ENV['SOUNDCLOUD_CLIENT_ID']).get()
  end
end


require 'soundcloud'


  def soundcloud_links(search)
    begin
    results = SoundCloud.new(:client_id => "476bff90d2af3f775a10bf5bc1f82928").get('/search', :q => search)
    tracks = []
    results[:collection].each do |result|
      if result["kind"] == "track" && result["duration"] < 450000
          tracks << result
        end
      end
    final_results = []
    tracks.each do |track|
      if track["title"].downcase.include?(search.downcase) && track["title"].downcase.start_with?(search.downcase)
        final_results << track
      end
    end

    song = final_results.sample
    uri = song["uri"]
    uri = uri.gsub(/http:\/\//, '')
    return uri
    rescue
      "Soundcloud Link Not Available"
    end
  end
end
