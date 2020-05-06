require "rails_helper"

RSpec.describe "As a default user", type: :feature do
  describe "When I am on the dashboard" do
    it "I can see a section called 'github' and 5 linked repos listed." do
      user = create(:user, github_token: "28adf5157c3594b994aca2efa1f17912ec9b7459")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit "/dashboard"

      within(".github") do
        expect(page).to have_content("Github")
        expect(page).to have_css(".repo", count: 5)
      end

      # User Story:
      # ** As a logged in user **
      # ** When I visit /dashboard **
      # ** Then I should see a section for "Github" **
      # And under that section I should see a list of 5 repositories with the name of each Repo linking to the repo on Github
    end
  end
end
