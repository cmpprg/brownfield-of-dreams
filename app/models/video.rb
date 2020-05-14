class Video < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :video_id, presence: true

  has_many :user_videos, dependent: :destroy
  has_many :users, through: :user_videos
  belongs_to :tutorial
end
