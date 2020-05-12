require 'rails_helper'

RSpec.describe 'as a user when i visit my dashboard', type: :feature do
  before(:each) do
    @user = create(:user)
    @repos_fixture = File.read('spec/fixtures/github_repo.json')
    @followers_fixture = File.read('spec/fixtures/github_followers.json')
    @following_fixture = File.read('spec/fixtures/github_following.json')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it 'i see a "Connect to Github" link styled as a button' do
    visit '/dashboard'
    expect(page).to have_link('Connect to Github')
  end

  context 'when i click "Connect to Github"' do
    it 'i am taken through the OAuth process and redirected to my dashboard' do
      visit '/dashboard'
      stub_request(:get, "https://api.github.com/user/repos?access_token=wooden_nickel_token").
         to_return(status: 200, body: @repos_fixture)
      stub_request(:get, "https://api.github.com/user/followers?access_token=wooden_nickel_token").
         to_return(status: 200, body: @followers_fixture)
      stub_request(:get, "https://api.github.com/user/following?access_token=wooden_nickel_token").
         to_return(status: 200, body: @following_fixture)

      OmniAuth.config.mock_auth[:github]= {'credentials' => {'token' => 'wooden_nickel_token'}}
      
      expect(@user.github_token).to eql(nil)

      click_link('Connect to Github')

      expect(@user.github_token).to eql('wooden_nickel_token')

      expect(current_path).to eql('/dashboard')

      within('.repos') do
        expect(page).to have_link('brownfield-of-dreams')
      end
      within('.followers') do
        expect(page).to have_link('alex-latham')
      end
      within('.following') do
        expect(page).to have_link('tylertomlinson')
      end
    end
  end
end
