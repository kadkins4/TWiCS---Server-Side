class PhotosController < ApplicationController

  def index
    @phrase = Phrase.find(params[:phrase_id])

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @phrase }
    end
  end

  def show
    @phrase = Phrase.find(params[:phrase_id])
  end

end
