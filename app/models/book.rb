class Book < ApplicationRecord
  belongs_to :user
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(word, match)
    w = word.to_s.strip
    return all if w.empty?

    if match == "perfect"
      where(title: w)
    else
      where("title LIKE ?", "%#{w}%")
    end
  end

end