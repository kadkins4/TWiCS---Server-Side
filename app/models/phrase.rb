require 'twitter'
require 'flickraw'
require 'engtagger'

class Phrase < ActiveRecord::Base
  has_many :photos

  before_save do
    puts 'hello'
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
    phrase = 'x'
    # need to validate twitter response to make sure we get back a response
    client.search("from:#{self.handle} -rt -link", result_type: 'recent').take(1).each do |tweet|
      phrase = tweet.text
    end
    self.content = phrase
    # need to validate the phrase, removing any uwanted words or symbols
    tgr = EngTagger.new
    # Sample text
    # Add part-of-speech tags to text
    tagged = tgr.add_tags(phrase.gsub(/(?:f|ht)tps?:\/[^\s]+/, ''))
    nps = tgr.get_nouns(tagged)
    new_arr = []
    for x in nps do
      new_arr << x[0]
    end
    puts "new_arr: #{new_arr}"
    @phrase_arr = new_arr
  end


  after_create do
    query_flickr(@phrase_arr)
  end

  def query_flickr (phrase_arr)
    puts 'flickr'
    for x in phrase_arr
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
