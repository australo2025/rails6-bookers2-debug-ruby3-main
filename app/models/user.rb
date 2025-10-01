class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_one_attached :profile_image
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :entries,  dependent: :destroy
  has_many :rooms,    through: :entries
  has_many :messages, dependent: :destroy

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
  has_many :relationships, class_name: "Relationship",
           foreign_key: :follower_id, dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  has_many :reverse_relationships, class_name: "Relationship",
           foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  has_many :owned_groups, class_name: "Group", foreign_key: :owner_id, dependent: :nullify


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

  def self.search_for(word, match)
    w = word.to_s.strip
    return all if w.empty?

    if match == "perfect"
      where(name: w)
    else
      where("name LIKE ?", "%#{w}%")
    end
  end

  def mutual_follow?(other)
    following?(other) && other.following?(self)
  end

end
