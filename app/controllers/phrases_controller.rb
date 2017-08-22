require 'flickraw'
require 'JSON'

class PhrasesController < ApplicationController

  def index
    @phrases = Phrase.all

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @phrases }
    end
  end

  def show
    @phrase = Phrase.find(params[:id])

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @phrase }
    end
  end

  def create
    @phrase = Phrase.new(phrase_params)
    @phrase.save!
    @photo = nil
    respond_to do |format|
      if @phrase.save!
        format.html { redirect_to @phrase }
        format.json { render json: @phrase, status: :created, location: @phrase }
        def phrase_parse
          @phrase = Phrase.find(params[:id])
          puts @phrase
          @phrase_arr = @phrase.content.split(' ')
          puts @phrase_arr
          query_flickr
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
              @photo = Photo.create!(photo_url: photo_url, tags: x, phrase_id: @phrase.id)
            end
          end
        end
      else
        format.html { render :new }
        format.json { render json: @phrase, status: :unprocessable_entity }
      end
    end
  end

private
  def phrase_params
    params.require(:phrase).permit(:content)
  end

end
