class TrackAnalyzer
  SEARCH_BASE_URL         = "https://api.spotify.com/v1/search?q="
  TRACK_BASE_URL          = "https://api.spotify.com/v1/tracks/"
  AUDIO_ANALYSIS_BASE_URL = "https://api.spotify.com/v1/audio-analysis/"

  attr_reader :track_name, :access_token

  def initialize(track_name, access_token)
    @track_name = track_name
    @access_token = access_token
  end

  def run
    track_id    = spotify_track_id
    track       = spotify_track(track_id)
    analysis    = audio_analysis(track_id)
    artist_name = track["artists"].first["name"]
    track_name  = track["name"]

    { artist: artist_name, track: track_name, analysis: analysis.to_h }
  end

  def spotify_track_id
    request_url = SEARCH_BASE_URL + encode_query + "&type=track"
    response    = HTTParty.get(request_url)
    tracks      = response["tracks"]["items"]

    begin
      find_by_track_name(tracks)
    rescue NoMethodError
      tracks.first["id"]
    end
  end

  private

  def spotify_track(track_id)
    request_url = TRACK_BASE_URL + track_id
    HTTParty.get(request_url)
  end

  def audio_analysis(id)
    request_url = AUDIO_ANALYSIS_BASE_URL + id
    HTTParty.get(request_url, headers: auth_header)
  end

  def find_by_track_name(tracks)
    tracks.select { |item| track_name == item["name"].downcase }.first["id"]
  end

  def auth_header
    { "Authorization" => "Bearer #{access_token}" }
  end

  def encode_query
    track_name.gsub("_","+")
  end
end
