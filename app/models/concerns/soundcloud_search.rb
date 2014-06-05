class SoundcloudSearch
  def self.search_songs(songname, artistname)
    search = songname + " " + artistname
    results = SoundCloud.new(:client_id => "#{ENV['SOUNDCLOUD_CLIENT_ID']}").get('/tracks', :q => search).to_json

    # tracks_array = []
    # results.each do |result|
    #   if result[:title].include?(search) == true && result[:streamable] == true
    #     tracks_array << result
    #   end
    # end
    # return tracks_array
  end

end
