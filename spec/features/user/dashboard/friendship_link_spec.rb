require "rails_helper"

RSpec.describe "As a user on the dashboard", type: :feature do
  before(:each) do
    @user = create(:user, github_token: 'token', github_uid: '20000006')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    followers = File.read('spec/fixtures/github_follwers_friendship.json')
    following = File.read('spec/fixtures/github_following_friendship.json')
    stub_request(:get, "https://api.github.com/user/followers?access_token=token").
      to_return(body: followers)
    stub_request(:get, "https://api.github.com/user/following?access_token=token").
      to_return(body: following)

    allow_any_instance_of(RepositoryFactory).to receive(:return_collection).and_return([])
    @follower1 = create(:user, github_uid: '20000001')
    @follower2 = create(:user, github_uid: '20000002')
    @follower3 = create(:user, github_uid: '20000004')
    @followee1 = create(:user, github_uid: '10000004')
    @followee2 = create(:user, github_uid: '10000005')

  end

  context 'If a follower or followee also has an account on this app' do
    it "I should see a link to 'add as friend' next to their handle" do

      visit dashboard_path

      # save_and_open_page

      within('.followers') do
        within(page.all('.follower')[0]) do
          expect(page).to have_link('Add as Friend')
        end
        within(page.all('.follower')[1]) do
          expect(page).to have_link('Add as Friend')
        end
        within(page.all('.follower')[2]) do
          expect(page).to have_no_link('Add as Friend')
        end
        within(page.all('.follower')[3]) do
          expect(page).to have_link('Add as Friend')
        end
        within(page.all('.follower')[4]) do
          expect(page).to have_no_link('Add as Friend')
        end
      end

      within('.following') do
        within(page.all('.followee')[0]) do
          expect(page).to have_no_link('Add as Friend')
        end
        within(page.all('.followee')[1]) do
          expect(page).to have_no_link('Add as Friend')
        end
        within(page.all('.followee')[2]) do
          expect(page).to have_no_link('Add as Friend')
        end
        within(page.all('.followee')[3]) do
          expect(page).to have_link('Add as Friend')
        end
        within(page.all('.followee')[4]) do
          expect(page).to have_link('Add as Friend')
        end
      end
    end

    it "I can click add as friend link and they will be my friend." do
      visit dashboard_path

      expect(@user.friends.empty?).to eql(true)

      within('.followers') do
        within(page.all('.follower')[0]) do
          click_link 'Add as Friend'
        end
      end

      within('.following') do
        within(page.all('.followee')[4]) do
          click_link 'Add as Friend'
        end
      end

      expect(@user.friends).to include(@follower1)
      expect(@user.friends).to include(@followee2)
      expect(@user.friends).not_to include(@follower2)
      expect(@user.friends).not_to include(@follower3)
      expect(@user.friends).not_to include(@followee1)
    end
  end
end
