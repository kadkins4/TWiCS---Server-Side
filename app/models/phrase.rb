class Phrase < ActiveRecord::Base
  has_many :photos

<<<<<<< HEAD
  # after_create do
  #   parsed_phrase = parse(self)
  #   photos = query_flickr(parsed_phrase)
  #   photos.each do ...
  # end
  #
  # private
=======
  after_create do
    parsed_phrase = phrase_parse(self)
    query_flickr(parsed_phrase)
  end

private
>>>>>>> 05ba188d700603cd8fce908655d8f6084a054e85

  def phrase_parse (argument)
    argument.content.split(' ')
  end

  def query_flickr (phrase_arr)
    for x in phrase_arr
      FlickRaw.api_key=ENV['API_KEY']
      FlickRaw.shared_secret=ENV['SHARED_KEY']
      list = flickr.photos.search tags: x
      farm = list.first.farm
      server = list.first.server
      id = list.first.id
      secret = list.first.secret
      photo_url = "http://farm#{farm}.staticflickr.com/#{server}/#{id}_#{secret}.jpg"
      Photo.create!(photo_url: photo_url, tags: x, phrase_id: self.id)
    end
  end
end
