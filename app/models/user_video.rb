class UserVideo < ApplicationRecord
  belongs_to :video
  belongs_to :user

  def self.get_bookmarks(user)
    order_bookmarks(collect_bookmarks(user))
  end

  def self.collect_bookmarks(user)
    s1 = 'videos.id video_id, videos.title video_title, '
    s2 = 'tutorials.id tutorial_id, tutorials.title tutorial_title'
    user.videos.joins(:tutorial).select("#{s1}#{s2}")
        .order('tutorial_id').order('videos.position')
  end

  def self.order_bookmarks(bookmarks)
    bookmarks.group_by(&:tutorial_title)
  end
end
