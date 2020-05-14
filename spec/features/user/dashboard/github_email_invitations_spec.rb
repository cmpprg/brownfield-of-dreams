require 'rails_helper'

RSpec.describe 'as a user', type: :feature do
  describe 'when i visit my dashboard' do
    before(:each) do
      user = create(:user, github_token: 'user_token')
      user1_json1 = File.read('spec/fixtures/github_user1.json')
      user1_json2 = File.read('spec/fixtures/github_user1a.json')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      allow_any_instance_of(FollowersFactory).to receive(:return_collection).and_return([])
      allow_any_instance_of(FolloweesFactory).to receive(:return_collection).and_return([])
      allow_any_instance_of(RepositoryFactory).to receive(:return_collection).and_return([])

      stub_request(:get, "https://api.github.com/users/cmpprg?access_token=user_token").
      to_return(status: 200, body: user1_json1)
      stub_request(:get, "https://api.github.com/users/cmpprg1?access_token=user_token").
      to_return(status: 200, body: user1_json2)
    end

    describe 'and i click "send an invite"' do
      it 'i should be on "/invite"' do
        visit dashboard_path
        click_link('Send an Invite')
        expect(current_path).to eql('/invite')
      end
    end

    describe 'and when i fill in "Github Handle" with a user name' do
      describe 'and i click "Send an Invite"' do
        it 'i should be on "/dashboard" and see a happy/sad path message' do
          visit '/invite'

          fill_in 'Github Handle', with: 'cmpprg'
          click_on 'Send Invite'

          expect(current_path).to eql('/dashboard')
          expect(page).to have_content('Successfully sent invite!')

          visit '/invite'

          fill_in 'Github Handle', with: 'cmpprg1'
          click_on 'Send Invite'

          expect(current_path).to eql('/dashboard')
          expect(page).to have_content("The Github user you selected doesn't have an email address associated with their account.")
        end
      end
    end
  end
end
