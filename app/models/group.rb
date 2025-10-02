class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_one_attached :image
  validates :name, presence: true

  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
end
