require "rails_helper"

RSpec.describe "As an admin", type: :feature do
  let(:admin)    { create(:admin) }
  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
  end

  describe "When I visit the new tutorials page" do
    it "I can see a link for 'Import YouTube Playlist'" do
      visit '/admin/tutorials/new'

      expect(page).to have_content('Import YouTube Playlist')
    end
  end
end

#   As an admin
# When I visit '/admin/tutorials/new'
# Then I should see a link for 'Import YouTube Playlist'
# When I click 'Import YouTube Playlist'
# Then I should see a form
#
# And when I fill in 'Playlist ID' with a valid ID
# Then I should be on '/admin/dashboard'
# And I should see a flash message that says 'Successfully created tutorial. View it here.'
# And 'View it here' should be a link to '/tutorials/:id'
# And when I click on 'View it here'
# Then I should be on '/tutorials/:id'
# And I should see all videos from the YouTube playlist
# And the order should be the same as it was on YouTube
