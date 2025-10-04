class Tag < ApplicationRecord
  has_many :books, dependent: :nullify
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end