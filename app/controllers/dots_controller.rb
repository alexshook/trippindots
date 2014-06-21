class DotsController < ApplicationController

  def index
    @temp_songs = AWS::S3::Bucket.find(ENV['S3_BUCKET_NAME_TD']).objects
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
    AWS::S3::S3Object.store(sanitize_filename(params[:songfile].original_filename),
                                       params[:songfile].read,
                                       ENV['S3_BUCKET_NAME_TD'],
                                       :access => :public_read)

    redirect_to root_path
  end

  private

  def sanitize_filename(file_name)
    just_filename = File.basename(file_name)
    just_filename.sub(/[^\w\.\-]/, '_')
  end
end
