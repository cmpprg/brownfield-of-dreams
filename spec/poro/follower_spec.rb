require "rails_helper"

RSpec.describe Follower, type: :model do
  before(:each) do
    info = { login: 'Follower Name',
             html_url: 'http://www.example.com',
             id: '12345678' }
    @follower = Follower.new(info)
  end

  it "exists" do
    expect(@follower).to be_a(Follower)
  end

  it "has_attributes" do
    expect(@follower.name).to eql('Follower Name')
    expect(@follower.url).to eql('http://www.example.com')
    expect(@follower.github_uid).to eql('12345678')
  end
end
