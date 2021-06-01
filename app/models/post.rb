class Post < ApplicationRecord
  belongs_to :user
  
  has_many :likes
  has_many :users, through: :likes
  has_many :likes_user, through: :likes, source: :user
  
  validates :title, presence: true, length: { maximum: 20 }
  validates :content, presence: true, length: { maximum: 500 }
end
