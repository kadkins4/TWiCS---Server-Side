class Phrase < ActiveRecord::Base
  has_many :photos

  after_create do
    tgr = EngTagger.new
    # Sample text
    # Add part-of-speech tags to text
    tagged = tgr.add_tags(phrase.gsub(/(?:f|ht)tps?:\/[^\s]+/, ''))
    nps = tgr.get_nouns(tagged)
    new_arr = []
    for x in nps do
      new_arr << x[0]
    end
    @phrase_arr = new_arr
    # parsed_phrase = phrase_parse(self)
    query_flickr(@phrase_arr)
  end

private
  # def phrase_parse (argument)
  #   argument.content.split(' ')
  # end

  def query_flickr (phrase_arr)
    for x in phrase_arr
      begin
        FlickRaw.api_key=ENV['API_KEY']
        FlickRaw.shared_secret=ENV['SHARED_KEY']
        list = flickr.photos.search tags: x, safe_search: 1
        farm = list.first.farm
        server = list.first.server
        id = list.first.id
        secret = list.first.secret
        photo_url = "http://farm#{farm}.staticflickr.com/#{server}/#{id}_#{secret}.jpg"
        Photo.create!(photo_url: photo_url, tags: x, phrase_id: self.id)
      rescue
      end
    end
  end
end
