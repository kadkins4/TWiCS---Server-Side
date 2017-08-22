class PhotosController < ApplicationController

  def index
    @phrase = Phrase.find(params[:phrase_id])

    render json: @phrase
  end

  def show
    @phrase = Phrase.find(params[:phrase_id])
  end

end
