class DotsController < ApplicationController

  def index
  end

  def search
    title = params[:title]
    title.gsub!(' ', '+')
    response = EchoNestSearch::get_echonest_data(title)
    # Fix when we get echonest working
    # echonest_id = response.
    # fma_audio = FMASearch::get_fma_url(echonest_id)
    itunes_audio_url = ItunesSearch::get_itunes_url(response[:artist], title)
    respond_to do |format|
      format.html { }
      format.json { render json: { :artist => response[:artist],
                                   :song => response[:song],
                                   :meta_data => response[:meta_data],
                                   :itunes_audio_url => itunes_audio_url} }
    end

  end


end
