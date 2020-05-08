require "rails_helper"

RSpec.describe "As a default user", type: :feature do
  describe "When I am on the dashboard" do
    before(:each) do
      @user = create(:user, github_token: ENV["GITHUB_TEST_API_KEY"])
    end

    it "I can see a section called 'github' and 5 linked repos listed." do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/dashboard"
      within(".github") do
        expect(page).to have_content("Github")
        expect(page).to have_css(".repo", count: 5)
      end
    end

    it "I can click on one of the repo titles and be taken to that repo", :js do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/dashboard"
      expected_href = find_by_id("#repo-4")['href']

      within(".github") do
        expect(page).to have_link("#repo-0")
        expect(page).to have_link("#repo-1")
        expect(page).to have_link("#repo-2")
        expect(page).to have_link("#repo-3")
        expect(page).to have_link("#repo-4")
        click_link "#repo-4"
      end
      expect(current_url).to eql(expected_href)
    end

    xit "I see my repos and not another registered user" do
      user1 = create(:user, github_token: ENV["GITHUB_TEST_API_KEY"])
      user2 = create(:user, github_token: ENV["ALT_GITHUB_TEST_API_KEY"])

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)

      # Ask project manager about testing this edge case
    end

    it "I can't see a github section if I don't have a github token" do
      @user.github_token = nil
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)


      visit "/dashboard"

      expect(page).to have_no_css(".github")
    end
  end
end
