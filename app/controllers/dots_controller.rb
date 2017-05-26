class DotsController < ApplicationController

  def index
    @temp_songs = S3.new.tracks_list
  end

  def spotify_analyze
    params.permit(:song_name)
    song_name = params[:song_name].presence || "by the way"
    response = TrackAnalyzer.new(song_name, access_token).run

    respond_to do |format|
      format.html { }
      format.json { render json:
        {
          artist: response[:artist],
          song: response[:track],
          meta_data: response[:analysis]
        }
      }
    end
  end

  def upload
    params.permit(:songfile)

    S3.new(params[:songfile]).upload_track

    redirect_to root_path
  end

  private

  def access_token
    SpotifyAuthorization.new.run
  end
end
