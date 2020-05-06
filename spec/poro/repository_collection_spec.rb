require "rails_helper"

RSpec.describe RepositoryCollection, type: :model do
  before(:each) do
    @info = [{name: "Repository Name1", url: "http://www.example.com1"},
           {name: "Repository Name2", url: "http://www.example.com2"},
           {name: "Repository Name3", url: "http://www.example.com3"}]
    @repos = RepositoryCollection.new(@info)
  end

  it "exists" do
    expect(@repos).to be_a(RepositoryCollection)
  end

  it "can create an instance of a repository object" do
    repo = @repos.create_repo(@info[0])

    expect(repo).to be_a(Repository)
    expect(repo.name).to eql("Repository Name1")
    expect(repo.url).to eql("http://www.example.com1")
  end

  it "can add a repository to the collection" do
    repo = @repos.create_repo(@info[0])

    expect(@repos.repos).to eql([])

    @repos.add_repo(repo)

    expect(@repos.repos).to eql([repo])
  end

  it "can create a collection of repositories" do
    expect(@repos.repos).to eql([])

    @repos.create_collection

    expect(@repos.repos.length).to eql(3)
    expect(@repos.repos.first).to be_a(Repository)
    expect(@repos.repos.last).to be_a(Repository)
  end

  it "can return the created collection of repository objects" do
    expect(@repos.repos).to eql([])
    expect(@repos.return_collection.length).to eql(3)
    expect(@repos.return_collection).to eql(@repos.repos)
  end
end
