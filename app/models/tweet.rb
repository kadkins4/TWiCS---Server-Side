class Tweet < ActiveRecord::Base
  has_many :pictures

  before_save do
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    @handle = self.handle

    def check_user(user)
      @client.user(user).tweets_count
    end

    begin
      check_user(@handle)
    rescue
      break
    else
      rtn_tweet = 'x'
      # need to validate twitter response to make sure we get back a response
      @client.search("from:#{self.handle} -rt -link", result_type: 'recent').take(1).each do |tweet|
        rtn_tweet = tweet.text
      end
      self.content = rtn_tweet
      # need to validate the tweet, removing any uwanted words or symbols
      tgr = EngTagger.new
      # Sample text
      # Add part-of-speech tags to text
      tagged = tgr.add_tags(rtn_tweet.gsub(/(?:f|ht)tps?:\/[^\s]+/, ''))
      nps = tgr.get_nouns(tagged)
      new_arr = []
      for x in nps do
        new_arr << x[0]
      end
      @tweet_arr = new_arr
    end

  end


  after_create do
    query_flickr(@tweet_arr)
  end

  def query_flickr (tweet_arr)
    for x in tweet_arr
      begin
        FlickRaw.api_key=ENV['API_KEY']
        FlickRaw.shared_secret=ENV['SHARED_KEY']
        list = flickr.photos.search tags: x, safe_search: 1
        farm = list.first.farm
        server = list.first.server
        id = list.first.id
        secret = list.first.secret
        picture_url = "http://farm#{farm}.staticflickr.com/#{server}/#{id}_#{secret}.jpg"
        Picture.create!(picture_url: picture_url, tags: x, tweet_id: self.id)
      rescue
      end
    end
  end
end
