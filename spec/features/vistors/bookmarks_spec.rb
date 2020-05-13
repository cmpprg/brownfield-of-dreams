require 'rails_helper'

RSpec.describe 'as a visitor when i click a bookmark button', type: :feature do
  it 'i see a flash message that i am not logged in and stay on that page' do
    tutorial = create(:tutorial)
    video = create(:video, tutorial_id: tutorial.id)
    visit "/tutorials/#{tutorial.id}?video_id=#{video.id}"
    click_button 'Bookmark'

    expect(current_path).to eql("/tutorials/#{tutorial.id}")
    expect(current_url).to include("/tutorials/#{tutorial.id}?video_id=#{video.id}")
    expect(page).to have_content('User must login to bookmark videos.')
  end
end
