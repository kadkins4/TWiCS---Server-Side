require 'flickraw'
require 'JSON'

class PhrasesController < ApplicationController

  def index
    @phrases = Phrase.all
    render json: @phrases, include: [:photos]
  end

  def show
    @phrase = Phrase.find(params[:id])
    render json: @phrase, include: [:photos]
  end

  def create
    @phrase = Phrase.new(phrase_params)
    @phrase.save!
    if @phrase.save!
      render json: @phrase, status: :created, location: @phrase
    else
      render json: @phrase, status: :unprocessable_entity
    end
  end

private
  def phrase_params
    params.require(:phrase).permit(:content)
  end

end
