class DotsController < ApplicationController

  def get_echonest_data
      analysis_url = HTTParty.get("http://developer.echonest.com/api/v4/song/search?api_key=ZJEP5VI1IGFTYDF9L&format=json&results=1&title=layla&bucket=id:7digital-US&bucket=audio_summary&bucket=tracks")["response"]["songs"].first["audio_summary"]["analysis_url”]

       song_data = HTTParty.get(analysis_url)

  end

end
