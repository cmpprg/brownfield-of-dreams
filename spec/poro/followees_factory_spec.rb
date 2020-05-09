require "rails_helper"

RSpec.describe FolloweesFactory, type: :model do
  before(:each) do
    @info = [{login: "Followee Name1", html_url: "http://www.example.com1"},
           {login: "Followee Name2", html_url: "http://www.example.com2"},
           {login: "Followee Name3", html_url: "http://www.example.com3"}]
    @followees = FolloweesFactory.new(nil)
  end

  it "exists" do
    expect(@followees).to be_a(FolloweesFactory)
  end

  it "can return the created collection of follower objects" do
    allow_any_instance_of(FolloweesFactory).to receive(:followees_info).and_return(@info)
    collection = @followees.return_collection
    expect(collection.length).to eql(3)
    expect(collection[0].name).to eql("Followee Name1")
    expect(collection[0].url).to eql("http://www.example.com1")
  end
end
