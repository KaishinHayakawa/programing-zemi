class Tweet < ApplicationRecord
  has_many :retweets, dependent: :destroy
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
