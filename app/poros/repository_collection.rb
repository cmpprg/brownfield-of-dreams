class RepositoryCollection
  attr_reader :repos
  def initialize(repos_info)
    @repos_info = repos_info
    @repos = []
  end

  def create_repo(info)
    Repository.new(info)
  end

  def add_repo(repo)
    @repos << repo
  end

  def create_collection
    @repos_info.each do |repo_info|
      add_repo(create_repo(repo_info))
    end
  end

  def return_collection
    create_collection
    @repos
  end
end
