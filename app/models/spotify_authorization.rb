class SpotifyAuthorization
  URL = "https://accounts.spotify.com/api/token"
  BODY = { "grant_type" => "client_credentials" }

  def run
    response = HTTParty.post(URL, body: BODY, headers: header)
    response.dig("access_token")
  end

  def header
    { "Authorization" => "Basic #{encoded_keys}" }
   end

  def encoded_keys
    Base64.strict_encode64(
      "#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}"
    )
  end
end
