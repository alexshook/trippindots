class DotsController < ApplicationController

  def index
    s3 = Aws::S3::Client.new(
              :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
              :secret_access_key => ENV['AWS_SECRET_KEY_ID'])

    @temp_songs = s3.list_objects(bucket: ENV['S3_BUCKET_NAME_TD'])
  end

  def spotify_analyze
    response = TrackAnalyzer.new(q, access_token).run

    respond_to do |format|
      format.html { }
      format.json { render json: response }
    end
  end

  def upload
    s3 = Aws::S3::Client.new(
              :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
              :secret_access_key => ENV['AWS_SECRET_KEY_ID'])
    s3.list_objects(bucket: ENV['S3_BUCKET_NAME_TD'])[params[:songfile].original_filename].write(params[:songfile].read, acl: :public_read)
    redirect_to root_path
  end

  private

  def sanitize_filename(file_name)
    just_filename = File.basename(file_name)
    just_filename.sub(/[^\w\.\-]/, '_')
  end

  def access_token
    SpotifyAuthorization.new.run
  end
end
