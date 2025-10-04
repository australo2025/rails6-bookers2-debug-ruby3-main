class Book < ApplicationRecord
  belongs_to :user
  belongs_to :tag, optional: true 
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  attr_readonly :rate
  validates :rate, inclusion: { in: 1..5 }, allow_nil: true

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

  scope :latest, -> { order(created_at: :desc) }
  scope :highest_rated, -> {
    order(Arel.sql('rate IS NULL'), rate: :desc, created_at: :desc)
  }

end