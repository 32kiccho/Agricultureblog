class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  # password付き（暗号化）のモデルを作成
  has_secure_password
    
  has_many :posts
  has_many :relationships
  has_many :likes
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  has_many :like_posts, through: :likes, source: :post
  
  # 自分自身でないか確認  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  # 既にフォローしていないか確認
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  # タイムライン用のポストを取得する為のメソッド
  def feed_posts
    Post.where(user_id: self.following_ids + [self.id])
  end
  
  # いいねをするメソッド
  def like(other_post)
    unless self == other_post
      self.likes.find_or_create_by(post_id: other_post.id)
    end
  end
  
  # いいねを外すメソッド
  def unlike(other_post)
    likes == self.likes.find_by(post_id: other_post.id)
    likes.destroy if likes
  end
  
  # 既にいいねしていないか確認
  def like?(other_post)
    other_post.likes.exists?(post_id: other_post.id)
  end
  
end
