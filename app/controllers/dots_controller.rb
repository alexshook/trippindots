class DotsController < ApplicationController

  def index
    s3 = AWS::S3.new(
              :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
              :secret_access_key => ENV['AWS_SECRET_KEY_ID'])
    @temp_songs = s3.buckets[ENV['S3_BUCKET_NAME_TD']].objects
  end

  def echonest_analyze
    response = EchoNestSearch.analyze_song(params['song_url'])
    respond_to do |format|
      format.html { }
      format.json { render json: { artist: response[:artist],
                                   song: response[:song],
                                   meta_data: response[:meta_data]
                                 }
      }
    end
  end

  def upload
    s3 = AWS::S3.new(
              :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
              :secret_access_key => ENV['AWS_SECRET_KEY_ID'])
    s3.buckets[ENV['S3_BUCKET_NAME_TD']].objects[params[:songfile].original_filename].write(params[:songfile].read, acl: :public_read)
    redirect_to root_path
  end

  private

  def sanitize_filename(file_name)
    just_filename = File.basename(file_name)
    just_filename.sub(/[^\w\.\-]/, '_')
  end
end
