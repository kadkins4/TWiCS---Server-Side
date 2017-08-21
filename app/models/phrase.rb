require 'flickraw'

class Phrase < ActiveRecord::Base
  has_many :photos
  # after_commit :phrase_parse

  private
    def phrase_parse
      puts @phrase
      # @phrase_arr = self[:content].to_s.split(' ')
      query_flickr
    end

    def query_flickr
      for x in @phrase_arr
        FlickRaw.api_key=ENV['API_KEY']
        FlickRaw.shared_secret=ENV['SHARED_KEY']
        list = flickr.photos.search tags: x
        first_entry = list.first
        photo_url = "http://farm#{first_entry.farm-id}.staticflickr.com/#{first_entry.server-id}/#{first_entry.id}_#{first_entry.secret}.jpg"
        tags = x
        Photo.create!(photo_url: photo_url, tags: tags, phrase_id: @phrase.id)
      end
    end

end
