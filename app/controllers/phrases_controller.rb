require 'flickraw'
require 'JSON'

class PhrasesController < ApplicationController

  def index
    @phrases = Phrase.all

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @phrases.as_json(include:[:photos]) }
    end
  end

  def show
    @phrase = Phrase.find(params[:id])
    phrase_parse

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @phrase }
    end
  end

  def create
    @phrase = Phrase.new(phrase_params)
    @phrase.save!
    respond_to do |format|
      if @phrase.save!
        format.html { redirect_to @phrase }
        format.json { render json: @phrase, status: :created, location: @phrase }
      else
        format.html { render :new }
        format.json { render json: @phrase, status: :unprocessable_entity }
      end
    end
  end

  def phrase_parse
    @phrase = Phrase.find(params[:id])
    @phrase_arr = @phrase.content.split(' ')
    query_flickr
  end

  def query_flickr
    for x in @phrase_arr
      FlickRaw.api_key=ENV['API_KEY']
      FlickRaw.shared_secret=ENV['SHARED_KEY']
      list = flickr.photos.search tags: x
      farm = list.first.farm
      server = list.first.server
      id = list.first.id
      secret = list.first.secret
      photo_url = "http://farm#{farm}.staticflickr.com/#{server}/#{id}_#{secret}.jpg"
      Photo.create!(photo_url: photo_url, tags: x, phrase_id: @phrase.id)
    end
  end


private
  def phrase_params
    params.require(:phrase).permit(:content)
  end

end
