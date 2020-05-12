require "rails_helper"

RSpec.describe "As an admin", type: :feature do
  let(:admin)    { create(:admin) }
  before(:each) do
    page1 = File.read('spec/fixtures/youtube_playlist1_items_pg1.json')
    page2 = File.read('spec/fixtures/youtube_playlist1_items_pg2.json')
    playlist_info = File.read('spec/fixtures/youtube_playlist1.json')
    stub_request(:get, "https://www.googleapis.com/youtube/v3/playlists?id=FLTfabOKD7Yty6sDF4POBVqA&key=AIzaSyAtTp3fGqcu-LCxliFHUR035EtIpuXzqs4&part=snippet").
      to_return(status: 200, body: playlist_info)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/playlistItems?key=AIzaSyAtTp3fGqcu-LCxliFHUR035EtIpuXzqs4&maxResults=50&pageToken=&part=snippet&playlistId=FLTfabOKD7Yty6sDF4POBVqA").
      to_return(status: 200, body: page1)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/playlistItems?key=AIzaSyAtTp3fGqcu-LCxliFHUR035EtIpuXzqs4&maxResults=50&pageToken=CDIQAA&part=snippet&playlistId=FLTfabOKD7Yty6sDF4POBVqA").
      to_return(status: 200, body: page2)
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

        fill_in :playlist_id, with: "FLTfabOKD7Yty6sDF4POBVqA"
        click_button 'Import'
        click_link('View it here')
        expect(page.all('.show-link')[0].native.children.text).to eql('RCA 1957 FILM introducting High Fidelity, Stereo Sound, and their new 1957 Hi-Fi\'s')
        expect(page.all('.show-link')[1].native.children.text).to eql('A SONY Stereo Demonstration! Exploring the SONY TC126 Vintage Stereo Cassette Recorder')
        expect(page.all('.show-link')[2].native.children.text).to eql('Rose Marie on the staying-power of The Dick Van Dyke Show - EMMYTVLEGENDS.ORG')
        expect(page.all('.show-link')[3].native.children.text).to eql('Ubuntu 11.04')
        expect(page.all('.show-link')[4].native.children.text).to eql('INTERFACE - Tips, Tricks & How-To - How To Setup A Turntable')
      end
    end
  end
end
