class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_one_attached :profile_image
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
  has_many :relationships, class_name: "Relationship",
           foreign_key: :follower_id, dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  has_many :reverse_relationships, class_name: "Relationship",
           foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  def follow(other_user)
    return if self == other_user
    relationships.find_or_create_by(followed_id: other_user.id)
  end

  def unfollow(other_user)
    relationships.find_by(followed_id: other_user.id)&.destroy
  end

  def following?(user)
    followings.exists?(user.id)
  end

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
