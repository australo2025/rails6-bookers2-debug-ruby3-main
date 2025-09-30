class Entry < ApplicationRecord
belongs_to :user
  belongs_to :room
  
  # 同じユーザーが同じ部屋に二重参加しないための保護
  validates :user_id, uniqueness: { scope: :room_id }
end
