require "rails_helper"

RSpec.describe Repository, type: :model do
  before(:each) do
    info = {name: "Repository Name", html_url: "http://www.example.com"}
    @repo = Repository.new(info)
  end

  it "exists" do
    expect(@repo).to be_a(Repository)
  end

  it "has_attributes" do
    expect(@repo.name).to eql("Repository Name")
    expect(@repo.url).to eql("http://www.example.com")
  end
end
