require 'flickraw'

class Phrase < ActiveRecord::Base
  has_many :photos
  # after_commit :phrase_parse

end
