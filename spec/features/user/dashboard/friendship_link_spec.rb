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
    create(:user, github_uid: '20000001')
    create(:user, github_uid: '20000002')
    create(:user, github_uid: '20000004')
    create(:user, github_uid: '10000004')
    create(:user, github_uid: '10000005')

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
  end
end
