require "rails_helper"

RSpec.describe GithubV3API, type: :model do
  before(:each) do
    @api = GithubV3API.new(ENV["GITHUB_TEST_API_KEY"])
  end
  it "exists" do
    expect(@api).to be_a(GithubV3API)
  end

  it "can connect to github api through faraday object" do
    expect(@api.connect).to be_a(Faraday::Connection)
    expect(@api.connect.url_prefix.to_s).to eql("https://api.github.com/")
  end

  it "can receive a response for a request for repos" do
    expect(@api.repo_response).to be_a(Faraday::Response)
    expect(@api.repo_response.env.request_headers["Authorization"]).to eql(ENV["GITHUB_TEST_API_KEY"])
  end

  it "can parse json response to hash" do
    expect(@api.repo_response.body).to be_a(String)
    expect(@api.parse_response(@api.repo_response)).to be_a(Array)
  end

  it "can collect necessary info for repos and produce a hash" do
    expect(@api.repo_info).to be_a(Array)
    expect(@api.repo_info.first.keys).to eql([:name, :url])
  end
end
