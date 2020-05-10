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

    it "When I click on import YouTube import link I am taken to form" do
      visit '/admin/tutorials/new'

      click_link 'Import YouTube Playlist'

      expect(current_path).to eql('/admin/import_playlist/new')
      expect(page).to have_field('playlist_id')
    end

    it "I fill out playlist id, click import, redirect to admin/dashboard with happy flash message" do
      visit '/admin/import_playlist/new'

      fill_in :playlist_id, with: "FLTfabOKD7Yty6sDF4POBVqA"
      click_button 'Import'

      expect(current_path).to eql('/admin/dashboard')

      tutorial = Tutorial.last
      expect(tutorial.title).to eql('Favorites')
      expect(tutorial.description).to eql('')
      expect(tutorial.thumbnail).to eql('https://i.ytimg.com/vi/CKx8yuFCw1Q/default.jpg')
      expect(tutorial.playlist_id).to eql("FLTfabOKD7Yty6sDF4POBVqA")
      expect(tutorial.videos.count).to eql(55)

      expect(page).to have_content('Successfully created tutorial. View it here.')
      expect(page).to have_link("Favorites")
      expect(page).to have_link('View it here')

      click_link('View it here')

      expect(current_path).to eql("/tutorials/#{tutorial.id}")
    end

    describe "When I visit the page for newly imported tutorial" do
      it "I see all videos and in the same order as on YouTube" do
        visit '/admin/import_playlist/new'

        fill_in :playlist_id, with: "PL1Y67f0xPzdMzHBjW0k2uGSoiKM3py--_"
        click_button 'Import'
        click_link('View it here')
        expect(page.all('.show-link')[0].native.children.text).to eql('FE Project: Wheel of Fortune (Jake Lauer)')
        expect(page.all('.show-link')[1].native.children.text).to eql('FE Project: Terminal Commander (Heather Hartley)')
        expect(page.all('.show-link')[2].native.children.text).to eql('FE Project: Rabbit Hole (Jamie Rushford)')
        expect(page.all('.show-link')[3].native.children.text).to eql('BE Project: Ticket Talk (Andrew Johnson, Evette Telyas, Corina Allen, Tylor Schafer)')
        expect(page.all('.show-link')[4].native.children.text).to eql('FE + BE: Mockr (Sejin Kim, Aurie Gochenour, Djavan Munroe, Eric O\'Neill)')
      end
    end
  end
end
