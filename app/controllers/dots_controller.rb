class DotsController < ApplicationController

  def index
  end

  def search
    title = params[:title]
    title.gsub!('  ', '+')
    response = EchoNestSearch::get_echonest_data(title)
    #Fix when we get echonest working
    # echonest_id = response.
    # fma_audio = FMASearch::get_fma_url(echonest_id)
    itunes_audio = ItunesSearch::get_itunes_url(response[0], title)
    respond_to do |format|
      format.html { }
      format.json { render json: { :response => response[1],
                                                      :itunes_audio => itunes_audio} }
    end

  end


end
