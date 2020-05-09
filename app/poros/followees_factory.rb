class FolloweesFactory
  def initialize(user)
    @current_user = user
    @followees = []
  end

  def return_collection
    create_collection
    @followees
  end

  private

  def add_followee(followee)
    @followees << followee
  end

  def create_collection
    followees_info.each do |followee_data|
      add_followee(create_followee(followee_data))
    end
  end

  def create_followee(followee_data)
    Followee.new(followee_data)
  end

  def followees_info
    GithubV3API.new(@current_user.github_token).followees_info
  end
end
