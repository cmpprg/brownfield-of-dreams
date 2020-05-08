require "rails_helper"

RSpec.describe Follower, type: :model do
  before(:each) do
    info = {login: "Follower Name", html_url: "http://www.example.com"}
    @follower = Follower.new(info)
  end

  it "exists" do
    expect(@follower).to be_a(Follower)
  end

  it "has_attributes" do
    expect(@follower.name).to eql("Follower Name")
    expect(@follower.url).to eql("http://www.example.com")
  end
end
