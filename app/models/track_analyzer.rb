class TrackAnalyzer
  SEARCH_BASE_URL         = "https://api.spotify.com/v1/search?q="
  TRACK_BASE_URL          = "https://api.spotify.com/v1/tracks/"
  AUDIO_ANALYSIS_BASE_URL = "https://api.spotify.com/v1/audio-analysis/"

  def run(q)
    track_id    = spotify_track_id(q)
    track       = spotify_track(track_id)
    analysis    = audio_analysis(track_id)
    artist_name =  track["artists"].first["name"]
    track_name  = track["name"]

    { artist: artist_name, track: track_name, analysis: analysis }
  end

  def spotify_track_id(q)
    request_url = SEARCH_BASE_URL + encode_query(q) + "&type=track"
    response    = HTTParty.get(request_url)

    response["tracks"]["items"].select do |item|
      q == item["name"].downcase
    end.first["id"]
  end

  private

  def spotify_track(track_id)
    request_url = TRACK_BASE_URL + track_id
    HTTParty.get(request_url)
  end

  def audio_analysis(id)
    request_url = AUDIO_ANALYSIS_BASE_URL + id
    HTTParty.get(request_url)
  end

  def encode_query(q)
    q.gsub(" ","+")
  end
end
