require "rails_helper"

RSpec.describe Followee, type: :model do
  before(:each) do
    info = {login: 'Followee Name',
            html_url: 'http://www.example.com',
            id: '12345678'}
    @followee = Followee.new(info)
  end

  it 'exists' do
    expect(@followee).to be_a(Followee)
  end

  it 'has_attributes' do
    expect(@followee.name).to eql('Followee Name')
    expect(@followee.url).to eql('http://www.example.com')
    expect(@followee.github_uid).to eql('12345678')
  end
end
