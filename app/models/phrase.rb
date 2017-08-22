class Phrase < ActiveRecord::Base
  has_many :photos

  # after_create do
  #   parsed_phrase = parse(self)
  #   photos = query_flickr(parsed_phrase)
  #   photos.each do ...
  # end
  #
  # private

  # def parse...

  # def query_flickr...
end
