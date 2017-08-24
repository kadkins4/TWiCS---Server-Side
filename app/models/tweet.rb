class Tweet < ActiveRecord::Base
  has_many :pictures

  before_save do
    puts 'hello'
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
    tweet = 'x'
    # need to validate twitter response to make sure we get back a response
    client.search("from:#{self.handle} -rt -link", result_type: 'recent').take(1).each do |tweet|
      tweet = tweet.text
    end
    self.content = tweet
    # need to validate the tweet, removing any uwanted words or symbols
    tgr = EngTagger.new
    # Sample text
    # Add part-of-speech tags to text
    tagged = tgr.add_tags(tweet.gsub(/(?:f|ht)tps?:\/[^\s]+/, ''))
    nps = tgr.get_nouns(tagged)
    new_arr = []
    for x in nps do
      new_arr << x[0]
    end
    puts "new_arr: #{new_arr}"
    @tweet_arr = new_arr
  end


  after_create do
    query_flickr(@tweet_arr)
  end

  def query_flickr (tweet_arr)
    puts 'flickr'
    for x in tweet_arr
      FlickRaw.api_key=ENV['API_KEY']
      FlickRaw.shared_secret=ENV['SHARED_KEY']
      list = flickr.pictures.search tags: x, safe_search: 1
      farm = list.first.farm
      server = list.first.server
      id = list.first.id
      secret = list.first.secret
      picture_url = "http://farm#{farm}.staticflickr.com/#{server}/#{id}_#{secret}.jpg"
      Picture.create!(picture_url: picture_url, tags: x, tweet_id: self.id)
    end
  end
end
