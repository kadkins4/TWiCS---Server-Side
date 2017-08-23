class Photo < ActiveRecord::Base
  belongs_to :phrase
  # belongs_to :tweet
end
