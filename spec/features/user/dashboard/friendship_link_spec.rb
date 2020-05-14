require "rails_helper"

RSpec.describe "As a user on the dashboard", type: :feature do
  before(:each) do
    @user = create(:user, github_token: 'token', github_uid: '20000006', github_handle: 'user_handle')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    followers = File.read('spec/fixtures/github_follwers_friendship.json')
    following = File.read('spec/fixtures/github_following_friendship.json')
    stub_request(:get, "https://api.github.com/user/followers?access_token=token").
      to_return(body: followers)
    stub_request(:get, "https://api.github.com/user/following?access_token=token").
      to_return(body: following)

    allow_any_instance_of(RepositoryFactory).to receive(:return_collection).and_return([])
    @follower1 = create(:user, github_uid: '20000001', github_handle: "github_follower_user_1")
    @follower2 = create(:user, github_uid: '20000002', github_handle: "github_follower_user_2")
    @follower3 = create(:user, github_uid: '20000004', github_handle: "github_follower_user_4")
    @followee1 = create(:user, github_uid: '10000004', github_handle: "github_following_user_4")
    @followee2 = create(:user, github_uid: '10000005', github_handle: "github_following_user_5")
  end

  context 'If a follower or followee also has an account on this app' do
    it "I should see a link to 'add as friend' next to their handle" do

      visit dashboard_path

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

      expect(current_path).to eql(dashboard_path)

      within('.following') do
        within(page.all('.followee')[4]) do
          click_link 'Add as Friend'
        end
      end

      expect(@user.friends.all).to include(@follower1)
      expect(@user.friends.all).to include(@followee2)
      expect(@user.friends.all).not_to include(@follower2)
      expect(@user.friends.all).not_to include(@follower3)
      expect(@user.friends.all).not_to include(@followee1)
    end

    it "I can see a list of friends I currently have" do
      Friendship.create(user_id: @user.id, friend_id: @follower1.id)
      Friendship.create(user_id: @user.id, friend_id: @followee2.id)

      visit dashboard_path

      within('.friendships') do
        expect(page).to have_content("Friends")
        within("#friend-#{@follower1.id}") do
          expect(page).to have_content(@follower1.github_handle)
        end
        within("#friend-#{@followee2.id}") do
          expect(page).to have_content(@followee2.github_handle)
        end
        expect(page).to have_no_content(@follower2.github_handle)
        expect(page).to have_no_content(@follower3.github_handle)
        expect(page).to have_no_content(@followee1.github_handle)
      end
    end
  end
end
