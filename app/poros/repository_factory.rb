class RepositoryFactory
  attr_reader :repos
  def initialize(user)
    @current_user = user
    @repos = []
  end

  def return_collection
    create_collection
    @repos
  end

  private

  def create_repo(info)
    Repository.new(info)
  end

  def add_repo(repo)
    @repos << repo
  end

  def create_collection
    repos_info.each do |repo_info|
      add_repo(create_repo(repo_info))
    end
  end

  def repos_info
    GithubV3API.new(@current_user.github_token).repo_info[0..4]
  end
end
