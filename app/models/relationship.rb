class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates :follower_id, uniqueness: { scope: :followed_id }
  validate  :not_self

  private
def not_self
  errors.add(:followed_id, "に自分は指定できません") if follower_id == followed_id
end
end
