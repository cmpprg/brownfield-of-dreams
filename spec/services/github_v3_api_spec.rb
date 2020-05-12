require "rails_helper"

RSpec.describe GithubV3API, type: :model do
  before(:each) do
    @repos_fixture = File.read('spec/fixtures/github_repo.json')
    @api = GithubV3API.new()
  end
  it "exists" do
    expect(@api).to be_a(GithubV3API)
  end

  it "can collect necessary info for repos and produce a hash" do
    stub_request(:get, "https://api.github.com/user/repos?access_token").
       to_return(status: 200, body: @repos_fixture)

    expect(@api.repo_info).to be_a(Array)
    expect(@api.repo_info.first.keys).to include(:name, :html_url)
  end
end
