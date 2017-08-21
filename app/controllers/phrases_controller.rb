require 'flickraw'
require 'JSON'

class PhrasesController < ApplicationController

  def index
    @phrases = Phrase.all
  end

  def new
    @phrase = Phrase.new
  end

  def create
    @phrase = Phrase.create(phrase_params)
    @phrase_arr = @phrase.content.split(' ')
    # accepts new phrase
    # @phrase = phrase.new!(phrase_params)
    # @photo = Phrase.findphoto(@phrase)
    redirect_to phrase_path(@phrase)
  end

  def phrase_parse
    @phrase = Phrase.find(params[:id])
    @phrase_arr = @phrase.content.split(' ')
    query_flickr
  end

  def query_flickr
    puts @phrase_arr
    for x in @phrase_arr
      FlickRaw.api_key=ENV['API_KEY']
      FlickRaw.shared_secret=ENV['SHARED_KEY']
      list = flickr.photos.search tags: x
      puts list
      puts list.length
      farm = list.first.farm
      server = list.first.server
      id = list.first.id
      secret = list.first.secret
      photo_url = "http://farm#{farm}.staticflickr.com/#{server}/#{id}_#{secret}.jpg"
      tags = x
      puts x
      Photo.create!(photo_url: photo_url, tags: x, phrase_id: @phrase.id)
    end
  end

  def show
    @phrase = Phrase.find(params[:id])
    # @phrase_arr = @phrase.content.split(' ')
    # @photo_titles = @phrase.photo
    phrase_parse
  end

private
  def phrase_params
    params.require(:phrase).permit(:content)
  end

end
