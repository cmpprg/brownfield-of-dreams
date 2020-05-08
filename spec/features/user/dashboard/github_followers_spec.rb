require 'rails_helper'

RSpec.describe 'as a user when i visit my dashboard', type: :feature do
  before(:each) do
    user = create(:user, github_token: ENV["GITHUB_TEST_API_KEY"])
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it 'Github section has Followers section with a list of all followers' do
    visit "/dashboard"
    within(".github") do
      expect(page).to have_content("Followers")
      expect(page).to have_css('.follower')
    end
  end

  it 'and their handles link to their github profiles', :js do
    visit "/dashboard"
    expected_url = find_by_id("#follower-0")['href']
    within('.followers') do
      expect(page).to have_link("#follower-0")
      expect(page).to have_link("#follower-1")
      click_link "#follower-0"
    end
    expect(current_url).to eql(expected_url)
  end
end
