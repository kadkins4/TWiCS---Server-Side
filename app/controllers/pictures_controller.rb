class PicturesController < ApplicationController

  def index
    @tweet = Tweet.find(params[:tweet_id])

    render json: @tweet
  end

  def show
    @tweet = Tweet.find(params[:tweet_id])
  end

end
