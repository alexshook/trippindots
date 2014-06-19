class DotsController < ApplicationController

  def index
    @temp_songs = AWS::S3::Bucket.find(ENV['S3_BUCKET_NAME_TD']).objects
    binding.pry
  end

  def search
    title = params[:title]
    title.gsub!(' ', '%20')
    artist_name = params[:artist_name]
    artist_name.gsub!(' ', '%20')
    response = EchoNestSearch::get_echonest_data(title, artist_name)
    # Fix when we get echonest working
    # echonest_id = response.
    # fma_audio = FMASearch::get_fma_url(echonest_id)
    # itunes_audio_url = ItunesSearch::get_itunes_url(artist_name, title)
    respond_to do |format|
      format.html { }
      format.json { render json: { :artist => response[:artist],
                                   :song => response[:song],
                                   :meta_data => response[:meta_data]
                                 }
      }
    end
  end

  def upload
    AWS::S3::S3Object.store(sanitize_filename(params[:songfile].original_filename),
                            params[:songfile].read,
                            ENV['S3_BUCKET_NAME_TD'],
                            :access => :public_read)

    # SEND OUT TO ECHONEST WITH POST REQUEST HERE FOR ANALYSIS BEFORE REFRESHING THE PAGE

    redirect_to root_path
  end

  private

  def sanitize_filename(file_name)
    just_filename = File.basename(file_name)
    just_filename.sub(/[^\w\.\-]/, '_')
  end
end
