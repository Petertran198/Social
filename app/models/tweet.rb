class Tweet < ApplicationRecord
    belongs_to :user
    validates :message, presence: true, length: { maximum: 140, too_long:"This tweet is too long. It should only be 140 max!"} 

end
