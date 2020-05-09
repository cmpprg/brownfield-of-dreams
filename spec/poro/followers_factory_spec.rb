require "rails_helper"

RSpec.describe FollowersFactory, type: :model do
  before(:each) do
    @info = [{login: "Follower Name1", html_url: "http://www.example.com1"},
           {login: "Follower Name2", html_url: "http://www.example.com2"},
           {login: "Follower Name3", html_url: "http://www.example.com3"}]
    @followers = FollowersFactory.new(nil)
  end

  it "exists" do
    expect(@followers).to be_a(FollowersFactory)
  end

  it "can return the created collection of follower objects" do
    allow_any_instance_of(FollowersFactory).to receive(:followers_info).and_return(@info)
    collection = @followers.return_collection
    expect(collection.length).to eql(3)
    expect(collection[0].name).to eql("Follower Name1")
    expect(collection[0].url).to eql("http://www.example.com1")
  end
end
