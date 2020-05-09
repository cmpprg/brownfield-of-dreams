require "rails_helper"

RSpec.describe GithubV3API, type: :model do
  before(:each) do
    @api = GithubV3API.new(ENV["GITHUB_TEST_API_KEY"])
  end
  it "exists" do
    expect(@api).to be_a(GithubV3API)
  end

  it "can collect necessary info for repos and produce a hash" do
    expect(@api.repo_info).to be_a(Array)
    expect(@api.repo_info.first.keys).to include(:name, :html_url)
  end
end
