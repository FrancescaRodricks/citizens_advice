class User < ApplicationRecord

  has_and_belongs_to_many :groups

  # == Validations ==========================================================
  validates_presence_of :username, :email, :password_digest
  validates :email, :username, uniqueness: true

  #encrypt password
  has_secure_password



end
