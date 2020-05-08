class Follower
  attr_reader :name, :url

  def initialize(follower_info)
    @name = follower_info[:login]
    @url = follower_info[:html_url]
  end
end
