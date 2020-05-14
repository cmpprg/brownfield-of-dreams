class User < ApplicationRecord
  has_many :user_videos, dependent: :destroy
  has_many :videos, through: :user_videos

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  validates :email, uniqueness: true, presence: true
  validates :password, presence: true, on: :create
  validates :first_name, presence: true

  enum role: { default: 0, admin: 1 }
  enum activation_status: { inactive: 0, active: 1 }
  has_secure_password

  def activate_account
    update(activation_status: 'active')
  end
end
