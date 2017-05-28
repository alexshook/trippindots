class DotsController < ApplicationController

  def index
    @temp_songs = S3.new.tracks_list
  end

  def spotify_analyze
    params.permit(:track_name)
    track_name  = params[:track_name].presence || "by the way"
    response    = TrackAnalyzer.new(track_name, access_token).run
    audio_file  = S3.new(track_name: track_name).file

    render json: {
      artist: response[:artist],
      song: response[:track],
      meta_data: response[:analysis],
      file: audio_file
    }
  end

  def upload
    params.permit(:track_name, :songfile)

    S3.new(
      track_name: params[:track_name],
      songfile: params[:songfile]
    ).upload_track

    redirect_to root_path
  end

  private

  def access_token
    SpotifyAuthorization.new.run
  end
end
