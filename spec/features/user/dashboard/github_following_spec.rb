require "rails_helper"

RSpec.describe 'as a user on the user dashboard', type: :feature do
  before(:each) do
    user = create(:user, github_token: 'user_token')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    following_fixture = File.read('spec/fixtures/github_following.json')
    stub_request(:get, "https://api.github.com/user/following?access_token=user_token").
    to_return(status: 200, body: following_fixture)
    allow_any_instance_of(FollowersFactory).to receive(:return_collection).and_return([])
    allow_any_instance_of(RepositoryFactory).to receive(:return_collection).and_return([])
  end

  it 'I should see a section for "Following" within the section for "Github"' do
    visit '/dashboard'

    within('.github') do
      within('.following') do
        expect(page).to have_content("Following")
      end
    end
  end

  it "I should see a list of links of people i'm following on github", :js do
    visit "/dashboard"

    expected_url = find_by_id("#followee-0")['href']

    within('.following') do
      expect(page).to have_link("#followee-0")
      expect(page).to have_link("#followee-1")
      click_link "#followee-0"
    end

    expect(current_url).to eql(expected_url)
  end
end
