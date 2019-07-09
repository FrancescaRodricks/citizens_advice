class Group < ApplicationRecord
  # == Relationships ========================================================
  has_and_belongs_to_many :users

  # == Validations ==========================================================
  validates_presence_of :name
  validates :name, uniqueness: true

end
