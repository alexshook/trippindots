class DotsController < ApplicationController

  def index
  end

  def search
    title = params[:title]
    title.gsub!('  ', '+')
    response = EchoNestSearch::get_echonest_data(title)
    respond_to do |format|
      format.html { }
      format.json { render json: response.to_json}
    end
  end


end
