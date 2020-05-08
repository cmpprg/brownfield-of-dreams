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

  
end



# Then I should see a section for "Github"
# And under that section I should see another section titled "Following"
# And I should see list of users I follow with their handles linking to their Github profile
