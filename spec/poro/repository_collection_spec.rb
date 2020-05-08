require "rails_helper"

RSpec.describe RepositoryCollection, type: :model do
  before(:each) do
    @info = [{name: "Repository Name1", html_url: "http://www.example.com1"},
           {name: "Repository Name2", html_url: "http://www.example.com2"},
           {name: "Repository Name3", html_url: "http://www.example.com3"}]
    @repos = RepositoryCollection.new(nil)
  end

  it "exists" do
    expect(@repos).to be_a(RepositoryCollection)
  end

  it "can return the created collection of repository objects" do
    allow_any_instance_of(RepositoryCollection).to receive(:repos_info).and_return(@info)
    expect(@repos.repos).to eql([])
    expect(@repos.return_collection.length).to eql(3)
    expect(@repos.return_collection).to eql(@repos.repos)
    expect(@repos.return_collection[0].name).to eql("Repository Name1")
    expect(@repos.return_collection[0].url).to eql("http://www.example.com1")
  end
end
