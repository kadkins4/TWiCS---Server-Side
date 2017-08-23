require 'twitter'
require 'flickraw'

class Tweet < ActiveRecord::Base
  has_many :photos

  before_save do
    # phrase = self.content
    twitter_query
    # parsed_phrase = phrase_parse(self)
    # query_flickr(parsed_phrase)
  end

  after_create do
    query_flickr(@phrase_arr)
  end


private
  def twitter_query
    puts 'hello'
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
    phrase = 'x'
    # need to validate twitter response to make sure we get back a response
    client.search("from:#{self.tweet} -rt -link", result_type: "recent").take(1).each do |tweet|
      phrase = tweet.text
    end
    puts 'parsed'
    # need to validate the phrase, removing any uwanted words or symbols
    @phrase_arr = phrase.split(' ')
  end

  def query_flickr (phrase_arr)
    # can't query flickr more than 10 times in a row
    phrase_arr = phrase_arr[0,9]
    # need to validate that there is a response
    for x in phrase_arr
      puts x
      FlickRaw.api_key=ENV['API_KEY']
      FlickRaw.shared_secret=ENV['SHARED_KEY']
      list = flickr.photos.search tags: x, safe_search: 1
      farm = list.first.farm
      server = list.first.server
      id = list.first.id
      secret = list.first.secret
      photo_url = "http://farm#{farm}.staticflickr.com/#{server}/#{id}_#{secret}.jpg"
      Photo.create!(photo_url: photo_url, tags: x, phrase_id: self.id)
    end
  end
end
