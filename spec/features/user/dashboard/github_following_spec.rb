require "rails_helper"

RSpec.describe 'as a user on the user dashboard', type: :feature do
  before(:each) do
    user = create(:user, github_token: ENV["GITHUB_TEST_API_KEY"])
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it 'I should see a section for "Following" within the section for "Github"' do
    visit '/dashboard'

    within('.github') do
      within('.following') do
        expect(page).to have_content("Following")
      end
    end
  end

  it "I should see a list of links of people i'm following on github" do
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


# And I should see list of users I follow with their handles linking to their Github profile
