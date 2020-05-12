require "rails_helper"

RSpec.describe "As a default user", type: :feature do
  describe "When I am on the dashboard" do
    before(:each) do
      @user = create(:user, github_token: "user1_token")
      @repos_fixture1 = File.read('spec/fixtures/github_repo.json')
      @repos_fixture2 = File.read('spec/fixtures/github_repo_alt.json')
      allow_any_instance_of(FollowersFactory).to receive(:return_collection).and_return([])
      allow_any_instance_of(FolloweesFactory).to receive(:return_collection).and_return([])
      stub_request(:get, "https://api.github.com/user/repos?access_token=user1_token").
         to_return(status: 200, body: @repos_fixture1)
      stub_request(:get, "https://api.github.com/user/repos?access_token=user2_token").
         to_return(status: 200, body: @repos_fixture2)

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

    it "I see my repos and not another registered user" do
      user1 = create(:user, github_token: "user1_token")
      user2 = create(:user, github_token: "user2_token")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
      visit "/dashboard"
      first_repo_user_1 = find_by_id('#repo-0').native.attributes['href'].value

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user2)
      visit "/dashboard"
      first_repo_user_2 = find_by_id('#repo-0').native.attributes['href'].value

      expect(first_repo_user_1).not_to eql(first_repo_user_2)
    end

    it "I can't see a github section if I don't have a github token" do
      @user.github_token = nil
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/dashboard"

      expect(page).to have_no_css(".github")
    end
  end
end
