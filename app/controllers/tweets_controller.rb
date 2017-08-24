class TweetsController < ApplicationController

  def index
    @tweets = Tweet.all
    render json: @tweets, include: [:pictures]
  end

  def show
    @tweet = Tweet.find(params[:id])
    render json: @tweet, include: [:pictures]
  end

  def create
    @tweet = Tweet.new(tweet_params)
    # @tweet.save!
    if @tweet.save!
      render json: @tweet, status: :created, location: @tweet
    else
      render json: @tweet, status: :unprocessable_entity
    end
  end

private
  def tweet_params
    params.require(:tweet).permit(:content, :handle)
  end

end
