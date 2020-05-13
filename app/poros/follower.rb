class Follower
  attr_reader :name, :url, :github_uid

  def initialize(follower_info)
    @name = follower_info[:login]
    @url = follower_info[:html_url]
    @github_uid = follower_info[:id].to_s
  end
end
