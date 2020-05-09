class FollowersFactory
  def initialize(user)
    @current_user = user
    @followers = []
  end

  def return_collection
    create_collection
    @followers
  end

  private

  def add_follower(follower)
    @followers << follower
  end

  def create_collection
    followers_info.each do |follower_data|
      add_follower(create_follower(follower_data))
    end
  end

  def create_follower(follower_data)
    Follower.new(follower_data)
  end

  def followers_info
    GithubV3API.new(@current_user.github_token).follower_info
  end
end
